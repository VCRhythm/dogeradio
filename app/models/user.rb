# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  username                :string(255)
#  avatar_file_name        :string(255)
#  avatar_content_type     :string(255)
#  avatar_file_size        :integer
#  avatar_updated_at       :datetime
#  account                 :string(255)
#  balance                 :float            default(0.0)
#  code                    :integer
#  prev_received           :float            default(0.0)
#  bio                     :text
#  payout_account          :string(255)
#  soundcloud_access_token :string(255)
#  default_tip_amount      :float            default(5.0)
#  wow_tip_amount          :float            default(5.0)
#  donation_percent        :float            default(0.0)
#  transaction_fee         :float            default(0.04)
#  website                 :string(255)
#  autotip                 :boolean          default(FALSE)
#  display_name            :string(255)
#  address                 :string(255)
#  street                  :string(255)
#  city                    :string(255)
#  zipcode                 :string(255)
#  country                 :string(255)
#  latitude                :float
#  longitude               :float
#

class User < ActiveRecord::Base
	include ActiveModel::Validations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	geocoded_by :address
	reverse_geocoded_by :latitude, :longitude do |obj,results|
		if geo = results.first
			obj.street = geo.street_address
			obj.city = geo.city
			obj.state = geo.state
			obj.zipcode = geo.postal_code
			obj.country = geo.country_code
		end
	end
	after_validation :geocode, :reverse_geocode,
		if: lambda{ |obj| obj.address_changed? }

	searchkick text_start: [:username, :address, :city, :state, :zipcode, :country], index_name: 'users_index'
	validates_format_of :username, with: /\A[A-Za-z0-9.&]*\Z/, message: "can only be alphanumeric."
	validates_uniqueness_of :username
	validates_presence_of :username
	validates_presence_of :email
	
	validates :default_tip_amount, :wow_tip_amount, :transaction_fee, :prev_received, numericality: {greater_than_or_equal_to: 0}
	validates :donation_percent, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
	class CodeValidator < ActiveModel::EachValidator
		def validate_each(record, attribute, value)
			record.errors.add attribute, "is not valid." unless BetaCode.where(value: value).exists?
		end
	end

	class WebsiteValidator < ActiveModel::EachValidator
		def validate_each(record, attribute, value)
			valid = begin
					URI.parse(value)
			rescue URI::InvalidURIError
				false
			end
			unless valid
				record.errors[attribute] << (options[:message] || "is an invalid URL")
			end
		end
	end

	validates :website, website: true, allow_blank: true
	validates :code, code: true 

	has_many :uploaded_tracks, class_name: "Music", dependent: :destroy
	has_many :tracks, -> { order "created_at ASC"}, dependent: :destroy 

	has_many :payouts

	has_many :votes

	has_many :playlists
	has_many :plays

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed

	has_many :reverse_relationships, foreign_key: "followed_id",
																	 class_name: "Relationship",
																	 dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower															
	has_many :favorites, dependent: :destroy
	has_many :favorite_tracks, through: :favorites, source: :track

	has_many :tips_given, foreign_key: "payer_id",
												class_name: "Transaction"
	has_many :tips_received, foreign_key: "payee_id",
													 class_name: "Transaction"


	has_attached_file :avatar, styles: {
		thumb: '100x100>',
		square: '200x200#',
		medium: '300x300'
	}, bucket: 'dogeradio-avatar'

	validates_attachment_content_type :avatar, content_type: /\Aimage/

	include CI_Find
	include CI_Find_First

	def queue
		playlists.where(category:"queue").first
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	def vote?(tag)
		votes.find_by(tag_id: tag.id)
	end

	def vote_up!(tag)
		votes.create!(tag_id: tag.id)
	end

	def vote_down!(tag)
		votes.find_by(tag_id: tag.id).destroy
	end
	
	def favorite?(track)
		favorites.find_by(track_id: track.id)
	end

	def favorite!(track)
		favorites.create!(track_id: track.id)
	end

	def unfavorite!(track)
		favorites.find_by(track_id: track.id).destroy
	end

	def is_artist?
		tracks.exists?	
	end

	def self.random_artist
		count = User.count
		begin  		
			offset = rand(count)
			user = self.offset(offset).first
		end while !user.is_artist?
		return user
	end

	def pending_tips
		tips_given.where(pending:true)
	end

	def pending_receipts
		tips_received.where(pending:true)
	end

	def to_param
		username
	end

	def full_address
		"#{street}, #{city}, #{state} #{zipcode}, #{country}"
	end

end
