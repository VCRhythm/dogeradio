class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
	validate :tag, uniqueness: true, scope: :user
end
