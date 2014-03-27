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

	# Environment-specific direct upload url verifier screens for malicious posted upload locations.
	DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/dogeradio#{!Rails.env.production? ? "\\-#{Rails.env}" : ''}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze
	UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/myapp#{!Rails.env.production? ? "\\-#{Rails.env}" : ''}\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

	include CI_Find
	include CI_Find_First

	belongs_to :user
	has_attached_file :upload
	validates_attachment_content_type :upload, content_type: ['audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio']
	#validates_attachment_file_name :upload, matches: [/mp3\Z/, /mpeg\Z/, /ogg\Z/]
	#do_not_validate_attachment_file_type :upload

	validates :direct_upload_url, presence: true, format: { with: DIRECT_UPLOAD_URL_FORMAT }

  before_create :set_upload_attributes
  after_create :queue_processing

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
	def direct_upload_url=(escaped_url)
		write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
	  music = Music.find(id)
		direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(music.direct_upload_url)
		clean_direct_upload_url = direct_upload_url_data[:filename].gsub(/[^0-9A-Za-z.\-]/, '_')

	  s3 = AWS::S3.new

    paperclip_file_path = "musics/uploads/#{id}/original/#{clean_direct_upload_url}"
    s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])

	  music.processed = true
    music.save

		user = music.user

		user.tracks.create(name:music.name, url: music.upload.url, source: "upload")

		s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
	end

	def associated_track
		Track.where(url:self.upload.url).first
	end

	protected

	# Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
	  tries ||= 5
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
    s3 = AWS::S3.new
    direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head

    self.upload_file_name     = direct_upload_url_data[:filename]
		self.upload_file_size     = direct_upload_head.content_length
    self.upload_content_type  = direct_upload_head.content_type
    self.upload_updated_at    = direct_upload_head.last_modified
  rescue AWS::S3::Errors::NoSuchKey => e
		tries -= 1
    if tries > 0
	    sleep(3)
 	    retry
	  else
	    false
	  end
	end

	# Queue file processing
  def queue_processing
	  Music.transfer_and_cleanup(id)
  end

#	def transliterate(str)
#		s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s
#		s.downcase!
#		s.gsub!(/[^A-Za-z0-9]+/, ' ')
#		s.gsub!(/'/, '')
#		s.strip!
#		s.gsub!(/\ +/, '-')
#		return s
#	end

end
