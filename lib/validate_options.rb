
module ValidateOptions

  DefaultColumnNames = [:valid_from, :valid_to]

  def validate_column_names_option
    if @options[:column_names]
      raise ArgumentError, 'invalid :column_names option given. Must be Array with two Strings or Symbols' if invalid_column_names?
    else
      @options[:column_names] = DefaultColumnNames
    end

    @column_names = @options[:column_names].map(&:to_sym)
    @from = @column_names.first
    @to = @column_names.second
  end

  def invalid_column_names?
    object = @options[:column_names]
    return true unless object.respond_to?(:to_a)
    return true unless object.to_a.size == 2
    return true unless object.to_a.all? {|e| e.respond_to?(:to_sym)}
    return false
  end
  
end