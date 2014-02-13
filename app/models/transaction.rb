# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  payee_id   :integer
#  payer_id   :integer
#  value      :float
#  created_at :datetime
#  updated_at :datetime
#  method     :string(255)
#  track_id   :integer
#

class Transaction < ActiveRecord::Base
	belongs_to :payee, class_name: "User"
	belongs_to :payer, class_name: "User"
	validates :payer_id, presence: true
	validates :payee_id, presence: true
	validates :value, presence: true

	default_scope {order("created_at DESC")}

	scope :ten_recent, -> { where.not(payee_id: 0).limit(10)}

	def payee
		User.find(payee_id)
	end

	def payer
		User.find(payer_id)
	end

end
