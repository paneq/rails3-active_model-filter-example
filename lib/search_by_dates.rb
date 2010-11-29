
module SearchByDates

  extend ::ActiveSupport::Concern

  attr_accessor :valid_from, :valid_to
  attr_reader :period

  def period=(v)
    @period = v
    return @period unless Date::RECOGNIZED_PERIODS.map(&:to_s).include?(v.to_s) # Prevent memory attack.
    self.valid_from = Date.calculate_start(v.to_sym)
    self.valid_to = Date.calculate_end(v.to_sym)
  end

  included do
    validate_validity_dates

    validate do
      validates_inclusion_of :period, :in => Date::RECOGNIZED_PERIODS.map(&:to_s), :allow_blank => true, :allow_nil => true
    end
  end

end