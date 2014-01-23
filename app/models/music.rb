# == Schema Information
#
# Table name: musics
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  user_id             :integer          not null
#  direct_upload_url   :string(255)      not null
#  upload_file_name    :string(255)
#  upload_content_type :string(255)
#  upload_file_size    :integer
#  upload_updated_at   :datetime
#  processed           :boolean          default(FALSE), not null
#  created_at          :datetime
#  updated_at          :datetime
#

class Music < ActiveRecord::Base
	DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/dogeradio#{!Rails.env.production? ? "\\-#{Rails.env}" : ''}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

	belongs_to :user
	has_attached_file :upload

	validates :direct_upload_url, presence: true, format: {with: DIRECT_UPLOAD_URL_FORMAT }
	
	before_create :set_upload_attributes
	after_create :queue_processing

	# Store an unescaped version of the escaped URL that Amazon returns from direct upload.
	def direct_upload_url=(escaped_url)
		write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
	end

	# Determines if file requires post-processing (image resizing, etc)
	def post_process_required?
		%r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(upload_content_type).present?
	end

	# Final upload processing step
	def self.transfer_and_cleanup(id)
		music = Music.find(id)
		direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(music.direct_upload_url)
		s3 = AWS::S3.new

		if music.post_process_required?
			music.upload = URI.parse(URI.escape(music.direct_upload_url))
		else
			paperclip_file_path = "uploads/#{id}/#{direct_upload_url_data[:filename]}"
			s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])
		end

		music.processed = true
		music.save

		s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
	end

	protected

	#Set attachment attributes from the direct upload
	#@note Retry Logic handles S3 "eventual consistency" lag
	def set_upload_attributes
		tries ||= 5
		direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
		s3 = AWS::S3.new
		direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head
		
		self.upload_file_name = direct_upload_url_data[:filename]
		self.upload_file_size = direct_upload_head.content_length
		self.upload_content_type = direct_upload_head.content_type
		self.upload_updated_at = direct_upload_head.last_modified
	
	rescue AWS::S3::Errors::NoSuchKey => e
		tries -= 1
		if tries > 0
			sleep(3)
			retry
		else
			false
		end
	end

	#Queue file processing
	def queue_processing
		Music.delay.transfer_and_cleanup(id)
	end

end
