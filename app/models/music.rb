class Music < ActiveRecord::Base
	belongs_to :user

	has_attached_file :attachment,
		storage: :s3,
		s3_credentials: "#{Rails.root}/config/s3.yml",
		path: ":attachment/:id/:name.:extension",
		bucket: "dogeradiomusic"

end
