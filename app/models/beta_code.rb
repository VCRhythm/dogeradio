# == Schema Information
#
# Table name: beta_codes
#
#  id         :integer          not null, primary key
#  value      :integer
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#

class BetaCode < ActiveRecord::Base
end
