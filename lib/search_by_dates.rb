require 'active_record/connection_adapters/abstract/schema_definitions'

module SearchByDates

  extend ::ActiveSupport::Concern

  attr_reader :period

  [:valid_from, :valid_to].each do |attr|
    attr_reader attr, :"#{attr}_before_type_cast"
  end

  def period=(v)
    @period = v
    return @period unless Date::RECOGNIZED_PERIODS.map(&:to_s).include?(@period.to_s) # Prevent memory attack with this to_s fun # v.to_sym only when it is known to be valid
    self.valid_from = Date.calculate_start(v.to_sym)
    self.valid_to = Date.calculate_end(v.to_sym)
    return @period
  end

  [:valid_from, :valid_to].each do |attr|
    define_method(:"#{attr}=") do |v|
      instance_variable_set(:"@#{attr}_before_type_cast", v)
      instance_variable_set(:"@#{attr}", ActiveRecord::ConnectionAdapters::Column.string_to_date(v))
    end
  end

  included do
    validates :valid_from, :date => {:unless => Proc.new{|r| r.valid_from_before_type_cast.blank? }}
    validates :valid_to, :date => {:unless => Proc.new{|r| r.valid_to_before_type_cast.blank? }}
    # Too lazy to move here code that validates that valid_from and valid_to are valid range.
    validates_inclusion_of :period, :in => Date::RECOGNIZED_PERIODS.map(&:to_s), :allow_blank => true, :allow_nil => true
    attr_accessible :valid_from, :valid_to, :period if respond_to?(:attr_accessible)
  end

end
