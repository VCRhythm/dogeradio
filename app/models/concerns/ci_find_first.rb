module CI_Find_First
	extend ActiveSupport::Concern

	included do
		scope :ci_find_first, lambda { |attribute, value| where("lower(#{attribute}) = ?", value.downcase).first }
	end
end
