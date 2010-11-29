require 'test/unit/assertions'
require 'validate_options'
require 'validity_dates_validator'

class ValidityDatesValidatorProxy < ::ActiveModel::Validator

  include ValidateOptions
  include Test::Unit::Assertions

  def initialize(options)
    @options = options.dup
    check_validity!
    @options.freeze
  end

  def setup(klass)
    columns = @column_names
    options = @options
      
    klass.class_eval do
      validates_presence_of *columns, options.slice(:if, :unless)
      validates_with ::InTime::ValidityDatesValidator, options
    end

  end

  def check_validity!
    validate_column_names_option
    assert @column_names
  end

  def validate(record)
    # deliberately empty method
  end
    
end