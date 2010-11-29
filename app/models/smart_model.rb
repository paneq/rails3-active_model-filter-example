module SmartModel
  extend ActiveSupport::Concern

  included do
    extend ::ActiveModel::Naming
    extend ::ActiveModel::Translation
    include ::ActiveModel::Conversion
    include ::ActiveModel::Validations
    include ActiveModel::MassAssignmentSecurity
  end

  def persisted?
    false
  end

end
