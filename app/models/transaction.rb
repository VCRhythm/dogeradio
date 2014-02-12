# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  payee_id   :integer
#  payer_id   :integer
#  value      :float
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Transaction < ActiveRecord::Base
	belongs_to :payee, class_name: "User"
	belongs_to :payer, class_name: "User"
	validates :payer_id, presence: true
	validates :payee_id, presence: true
	validates :value, presence: true

	default_scope order: "created_at DESC"

	scope :ten_recent, -> { limit(10)}

	def payee
		User.where(user_id: payee_id).first
	end

	def payer
		User.where(user_id: payer_id).first
	end

end
