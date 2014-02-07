# == Schema Information
#
# Table name: payouts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  value      :float
#  done       :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class Payout < ActiveRecord::Base
  belongs_to :user
end
