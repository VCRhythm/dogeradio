class SoundcloudTrack < ActiveRecord::Base
  belongs_to :user
	has_attached_file :upload
end
