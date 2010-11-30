
class CustomBuilder < Formtastic::SemanticFormBuilder

  def date_range_select(field, options = {})
    options.reverse_merge!(
      :as => :select,
      :collection =>  Date::RECOGNIZED_PERIODS.inject({}){|hash, p| hash[p.to_s]= p.to_s; hash},
      :input_html => {:class => :date_range_select}
    )

    input field, options
  end

  def date_select_trio
    String.new.tap do |html|
      html << date_range_select(:period)
      html << input(:valid_from, :as => :calendar)
      html << input(:valid_to, :as => :calendar)
    end.html_safe
  end

end
