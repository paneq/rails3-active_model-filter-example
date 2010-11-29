require 'search_by_dates'

class Search

  include SmartModel
  include SearchByDates

  Attributes = [:producent, :brand, :color]

  attr_accessor *Attributes
  attr_accessible *Attributes

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def results
    scope = Car.scoped
    scope = scope.overlaps(valid_from, valid_to) if valid_from.present? && valid_to.present?
    scope = scope.where(:producent => producent) unless producent
    scope = scope.where(:brand => brand) unless brand.blank?
    scope = scope.where(:color => color) unless color_blank?
    return scope
  end

  def color_blank?
    return color.to_a.reject{|p| p.blank? }.blank? if color.respond_to?(:to_a)
    return color.blank?
  end

end
