module TimeScopes

  # range must overlap record's timespan
  # overlaps(range)
  # overlaps(from, to)
  def overlaps(range_or_valid_from, valid_to = nil, options = {})
    options = defaultize_options(options)
    valid_from, valid_to = parse_params(range_or_valid_from, valid_to)
    where(self.arel_table[options[:valid_from]].lteq(valid_to)).where(self.arel_table[options[:valid_to]].gteq(valid_from))
  end

  
  private

  
  def defaultize_options(options)
    return options.reverse_merge(:valid_from => :valid_from, :valid_to => :valid_to)
  end

  def parse_params(range_or_valid_from, valid_to)
    return range_or_valid_from.begin, range_or_valid_from.end if Range === range_or_valid_from && valid_to.nil?
    return range_or_valid_from, valid_to unless range_or_valid_from.nil? || valid_to.nil?
    raise ArgumentError
  end

end
