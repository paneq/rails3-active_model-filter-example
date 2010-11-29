require 'test/unit/assertions'
require 'intime/validate_options'

# checks if record.from <= record.to
class ValidityDatesValidator < ::ActiveModel::Validator

  include ValidateOptions
  include Test::Unit::Assertions

  def initialize(options)
    super
    check_validity!
  end

  def check_validity!
    validate_column_names_option
    assert @from
    assert @to
  end

  def validate(record)
    if no_errors?(record) && !valid_dates?(record)
      [@from, @to].each do |attr|
        record.errors.add(attr, :invalid)
      end
    end
  end

    
  private

  def no_errors?(record)
    record.errors[@from].empty? && record.errors[@to].empty?
  end

  def valid_dates?(record)
    validable_dates?(record) && record.send(@from) <= record.send(@to)
  end

  def validable_dates?(record)
    record.send(@from).is_a?(Date) && record.send(@to).is_a?(Date)
  end
    
end
