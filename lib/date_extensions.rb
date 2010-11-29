# encoding: UTF-8
# 
# http://github.com/paneq/manage-my-money/raw/master/lib/date_extensions.rb
# LICENCE: http://github.com/paneq/manage-my-money/blob/master/LICENCE

module DateExtensions

  mattr_accessor :logger

  # TODO: proper translation

  ACTUAL_PERIODS = [
    [:this_day, 'dzisiaj'],
    [:this_week, 'aktualny tydzień'],
    [:this_month, 'aktualny miesiąc'],
    [:this_quarter, 'aktualny kwartał'],
    [:this_year, 'aktualny rok'],
  ]

  PAST_PERIODS = [
    [:last_day, 'wczoraj'],
    [:last_week, 'poprzedni tydzień'],
    [:last_7_days, 'ostatnie 7 dni'],
    [:last_month, 'poprzedni miesiąc'],
    [:last_4_weeks, 'ostatnie 4 tygodnie'],
    [:last_quarter, 'poprzedni kwartał'],
    [:last_3_months, 'ostatnie 3 miesiące'],
    [:last_90_days, 'ostatnie 90 dni'],
    [:last_year, 'poprzedni rok'],
    [:last_12_months, 'ostatnie 12 miesięcy'],

  ]


  FUTURE_PERIODS = [
    [:next_day, 'jutro'],
    [:next_week, 'następny tydzień'],
    [:next_7_days, 'następne 7 dni'],
    [:next_month, 'następny miesiąc'],
    [:next_4_weeks, 'następne 4 tygodnie'],
    [:next_quarter, 'następnt kwartał'],
    [:next_3_months, 'następne 3 miesiące'],
    [:next_90_days, 'następne 90 dni'],
    [:next_year, 'następny rok'],
    [:next_12_months, 'następne 12 miesięcy'],
  ]


  PERIOD_CATEGORIES = [
    [:day, 'dzień'],
    [:week, 'tydzień'],
    [:month, 'miesiąc'],
    [:quarter, 'kwartał'],
    [:year, 'rok'],
    [:a_7_days, '7 dni'],
    [:a_4_weeks, '4 tygodnie'],
    [:a_3_months, '3 miesiące'],
    [:a_90_days, '90 dni'],
    [:a_12_months, '12 miesięcy'],
  ]


  RECOGNIZED_PERIODS = (ACTUAL_PERIODS + PAST_PERIODS + FUTURE_PERIODS).map {|symbol, name| symbol}


  def self.included(klass)
    log = self.logger # just for visibility in blocks.

    # altough class methods always have precedence before
    # included modules method just for safty let's just
    # remove those that are already implemented in given rails/ruby
    # version.
    #
    # This is done by cloning the InstanceMethods module
    # and undefining methods before including the clonned module
    # in proper class.
    instance_module = InstanceMethods.clone
    instance_module.module_eval do
      self.instance_methods.each do |im|
        if klass.instance_methods.include?(im)
          eval "undef :#{im}"
          log.info("Undefined method: #{im} before extending #{klass}") if log
        else
          log.info("Extending #{klass} with method #{im}") if log
        end
      end
    end
    klass.send(:include, instance_module)

    klass.extend(ClassMethods)

    klass.send :alias_method_chain, :advance, :quarters
  end

  module InstanceMethods
  
    def advance_with_quarters(options)
      
      # Works fine in Rails3 / Ruby 1.9.2
      #
      #    if options[:weeks]
      #      options[:days] ||= 0
      #      options[:days] += options[:weeks]*7
      #      options[:weeks] = nil
      #    end

      # Still missing
      if options[:quarters]
        options[:months] ||= 0
        options[:months] += options[:quarters]*3
        options[:quarters] = nil
      end
      
      advance_without_quarters(options)
    end

    def shift(period_category)
      result = case period_category
      when :day then self.advance(:days => 1)
      when :week then self.advance(:weeks => 1)
      when :month then self.advance(:months => 1)
      when :quarter then self.advance(:quarters => 1)
      when :year then self.advance(:years => 1)
      when :a_7_days then self.advance(:days => 7)
      when :a_4_weeks then self.advance(:weeks => 4)
      when :a_3_months then self.advance(:months => 3)
      when :a_90_days then self.advance(:days => 90)
      when :a_12_months then self.advance(:months => 12)
      else
        raise "Unrecognized period symbol: #{period_category}"
      end
      result - 1
    end

  end

  module ClassMethods

    # Returns range based on given symbol
    def calculate(symbol)
      raise ArgumentError, "Unrecognized period symbol: #{symbol}" unless RECOGNIZED_PERIODS.include?(symbol)
      Range.new(Date.calculate_start(symbol), Date.calculate_end(symbol))
    end


    def calculate_start(symbol)
      return case symbol
        #actual periods
      when :this_day        then Date.today
      when :this_week       then Date.today.beginning_of_week
      when :this_month      then Date.today.beginning_of_month
      when :this_quarter    then Date.today.beginning_of_quarter
      when :this_year       then Date.today.beginning_of_year
        #past periods
      when :last_day        then Date.yesterday
      when :last_week       then Date.today.beginning_of_week.yesterday.beginning_of_week
      when :last_7_days     then 6.days.ago.to_date
      when :last_month      then Date.today.months_ago(1).beginning_of_month
      when :last_4_weeks    then 3.weeks.ago.to_date.beginning_of_week
      when :last_quarter    then Date.today.beginning_of_quarter.yesterday.beginning_of_quarter
      when :last_3_months   then Date.today.months_ago(2).beginning_of_month
      when :last_90_days    then 89.days.ago.to_date
      when :last_year       then Date.today.years_ago(1).beginning_of_year
      when :last_12_months  then Date.today.months_ago(11).beginning_of_month
        #future periods
      when :next_day        then Date.tomorrow
      when :next_week       then Date.today.end_of_week.next
      when :next_7_days     then Date.today
      when :next_month      then Date.today.end_of_month.next
      when :next_4_weeks    then Date.today
      when :next_quarter    then Date.today.end_of_quarter.next
      when :next_3_months   then Date.today
      when :next_90_days    then Date.today
      when :next_year       then Date.today.end_of_year.next
      when :next_12_months  then Date.today

      else
        raise ArgumentError, "Unrecognized period symbol: #{symbol}"
      end
    end


    def calculate_end(symbol)
      return case symbol
        #actual periods
      when :this_day        then Date.today
      when :this_week       then Date.today.end_of_week
      when :this_month      then Date.today.end_of_month
      when :this_quarter    then Date.today.end_of_quarter
      when :this_year       then Date.today.end_of_year
        #past periods
      when :last_day        then Date.yesterday
      when :last_week       then Date.today.beginning_of_week.yesterday.end_of_week
      when :last_7_days     then Date.today
      when :last_month      then Date.today.months_ago(1).end_of_month
      when :last_quarter    then Date.today.beginning_of_quarter.yesterday
      when :last_4_weeks    then Date.today
      when :last_3_months   then Date.today.end_of_month
      when :last_90_days    then Date.today
      when :last_year       then Date.today.years_ago(1).end_of_year
      when :last_12_months  then Date.today.end_of_month

        #future periods
      when :next_day        then Date.tomorrow
      when :next_week       then Date.today.advance(:weeks => 1).end_of_week
      when :next_7_days     then Date.today.advance(:days => 6)
      when :next_month      then Date.today.advance(:months => 1).end_of_month
      when :next_quarter    then Date.today.advance(:quarters => 1).end_of_quarter
      when :next_4_weeks    then Date.today.advance(:weeks => 4)
      when :next_3_months   then Date.today.advance(:months => 3).end_of_month
      when :next_90_days    then Date.today.advance(:days => 89)
      when :next_year       then Date.today.advance(:years => 1).end_of_year
      when :next_12_months  then Date.today.advance(:months => 12)

      else
        raise ArgumentError, "Unrecognized period symbol: #{symbol}"
      end
    end

    def period_category(period)
      case period
      when :this_day, :last_day, :next_day then :day
      when :this_week, :last_week, :next_week then :week
      when :this_month, :last_month, :next_month then :month
      when :this_quarter, :last_quarter, :next_quarter then :quarter
      when :this_year, :last_year, :next_year then :year
      when :last_7_days, :next_7_days then :a_7_days
      when :last_4_weeks, :next_4_weeks then :a_4_weeks
      when :last_3_months, :next_3_months then :a_3_months
      when :last_90_days, :next_90_days then :a_90_days
      when :last_12_months, :next_12_months then :a_12_months
      else
        raise "Unrecognized period symbol: #{period}"
      end
    end


    def period_category_name(period)
      PERIOD_CATEGORIES.find{|el|  el[0] == period_category(period)}[1]
    end


    def split_period(period_division, period_start, period_end)
      case period_division
      when :day then
        split_into_days(period_start, period_end)
      when :week, :month, :quarter, :year then
        meta_split_period(period_division, period_start, period_end)
      when :none then
        [[period_start, period_end]]
      end
    end


    def split_into_days(period_start, period_end)
      result = []
      act_date = period_start
      next_date = nil
      while act_date <= period_end do
        next_date = act_date.advance :days => 1
        result << [act_date, next_date - 1.day]
        act_date = next_date
      end
      result
    end


    #
    # Podaje tablice etykiet dla zakresu daty z podziałem
    #
    # Parametry:
    #  period_division podział, moze być :day, :week, :month :quarter :year :none, domyślnie :none
    #  period_start, period_end zakres
    #
    # Wyjście:
    #  tablica stringów
    #  sortowanie od etykiety opisujacej najstarsza wartosc
    def get_date_range_labels(period_start, period_end, period_division = :none)
      dates = Date.split_period(period_division, period_start, period_end)
      result = []
      case period_division
      when :day then
        dates.each do |range|
          result << "#{range[0].to_s}"
        end
      when :week then
        dates.each do |range|
          result << "#{range[0].to_s} do #{range[1].to_s}"
        end
      when :month then
        dates.each do |range|
          result << I18n.l(range[0], :format => '%Y %b ')
        end
      when :quarter then
        dates.each do |range|
          result << "#{quarter_number(range[0])} kwartał #{range[0].strftime('%Y')}"
        end
      when :year then
        dates.each do |range|
          result << range[0].strftime('%Y')
        end
      when :none then
        dates.each do |range|
          result << "#{range[0].to_s} do #{range[1].to_s}"
        end
      end
      result
    end


    private

    
    #numer kwartału po rzymsku
    def quarter_number(date)
      case (date.at_beginning_of_quarter.month)
      when 1 then "I"
      when 4 then "II"
      when 7 then "III"
      when 10 then "IV"
      end
    end


    def meta_split_period(split_unit, period_start, period_end)

      beginning_method = "at_beginning_of_#{split_unit}"
      end_method = "at_end_of_#{split_unit}"
      adv_symbol = split_unit.to_s.pluralize.intern

      result = []
      act_date = period_start
      next_date = nil
      if period_start.send(end_method) == period_end.send(end_method)
        result << [period_start, period_end]
      else
        #1. od daty poczatkowej do konca okresu
        result << [period_start, period_start.send(end_method)]
        #2.srodek
        if period_start.send(end_method).next.send(end_method) != period_end.send(end_method)
          act_date = period_start.send(end_method).next.send(beginning_method)
          while act_date <= period_end.send(beginning_method).prev_day do
            next_date = act_date.advance adv_symbol => 1
            result << [act_date, act_date.send(end_method)]
            act_date = next_date
          end
        end
        #3.od poczatku okresu do daty koncowej
        result << [period_end.send(beginning_method), period_end]
      end
      result
    end
  end
end
