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

  def attributes=(values)
    sanitize_for_mass_assignment(values).each do |k, v|
      send("#{k}=", v)
    end
  end


end
