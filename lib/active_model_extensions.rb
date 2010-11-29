
require 'validity_dates_validator_proxy'

module ActiveModel

  module Validations
    
    module ClassMethods

      # options:
      #  - column_names - default: [:valid_from, :valid_to]
      #  - if
      #  - unless
      def validate_validity_dates(options = {})
        validates_with ValidityDatesValidatorProxy, options
      end
      
    end
    
  end

end