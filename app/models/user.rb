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
#  state                   :string(255)
#  zipcode                 :string(255)
#  country                 :string(255)
#  lat                     :float
#  lng                     :float
#  publish_address         :boolean          default(FALSE)
#  distance                :float
#  time_zone               :string(255)      default("UTC")
#  admin                   :boolean          default(FALSE)
#  guest                   :boolean
#

class User < ActiveRecord::Base
	include ActiveModel::Validations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	before_validation :init, on: :create

	has_many :tags, foreign_key: :object_id, dependent: :destroy
	has_many :venues
	has_and_belongs_to_many :events, join_table: "users_events"
	has_and_belongs_to_many :created_events, join_table: "creators_events", class_name: "Event", autosave:true
	geocoded_by :address, latitude: :lat, longitude: :lng
	after_validation :geocode,
		if: ->(obj){ obj.address.present? and obj.address_changed? }

	acts_as_mappable

	searchkick index_name: 'users_index', text_start: ['display_name', 'address']
	validates_format_of :username, with: /\A[A-Za-z0-9.&]*\Z/, message: "can only be alphanumeric.", unless: :guest
	validates_uniqueness_of :username, case_sensitive: false
	validates :username, :email, :display_name, presence: true

	validates :default_tip_amount, :wow_tip_amount, :transaction_fee, :prev_received, numericality: {greater_than_or_equal_to: 0}
	validates :donation_percent, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}

	class CodeValidator < ActiveModel::EachValidator #not currently being validated
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

	def should_index?
		is_artist?
	end

	validates :website, website: true, allow_blank: true
#	validates :code, code: true

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


	has_attached_file :avatar,
		styles: {
			tinythumb: '50x50#',
			thumb: '100x100#',
			square: '200x200>',
			medium: '300x300'
		},
		convert_options: {
			tinythumb: '-quality 75 -strip',
			thumb: '-quality 75 -strip'
		},
		bucket: 'dogeradio-avatar'

	validates_attachment_content_type :avatar, content_type: /\Aimage/

	scope :artists, -> {joins(:tracks).uniq}
	scope :no_guests, -> { where(guest: false) }

	include CI_Find
	include CI_Find_First

	def self.local(distance, origin)
		artists.within(distance, origin: origin).where(publish_address: true).order('distance DESC')
	end

	def followers_count
		followers.count
	end

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
		!guest #define this later
	end

	def self.random_user
		count = self.count
		offset = rand(count)
		offset(offset).first
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

	def init
		self.display_name = self.username
	end



end
