module CI_Find
	extend ActiveSupport::Concern
	included do
		scope :ci_find, lambda { |attribute, value| where("lower(#{attribute}) = ?", value.downcase) }
	end
end
