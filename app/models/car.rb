require 'time_scopes'

class Car < ActiveRecord::Base

  extend TimeScopes

  def self.colors
    Car.select("distinct(color)").map(&:color) # TODO: FIXME use select_value instead. No need to map to AR objects
  end

  def self.brands
    Car.select("distinct(brand)").map(&:brand) # TODO: FIXME use select_value instead. No need to map to AR objects
  end

  def self.producents
    Car.select("distinct(producent)").map(&:producent) # TODO: FIXME use select_value instead. No need to map to AR objects
  end

end
