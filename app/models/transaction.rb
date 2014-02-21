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
#  pending    :boolean          default(TRUE)
#

class Transaction < ActiveRecord::Base
	belongs_to :payee, class_name: "User"
	belongs_to :payer, class_name: "User"
	validates :payee_id, presence: true
	validates :value, presence: true

	default_scope {order("created_at DESC")}

	scope :by_users, 						-> { where.not(payer_id: 0)}
	scope :ten_recent, -> { by_users.where.not(payee_id: 0).limit(10)}

	def payee
		User.find(payee_id)
	end

	def payer
		if payer_id
			User.find(payer_id)
		end
	end

end
