module ApplicationHelper
  def format_time(time)
    if time.present?
      if time.year == Time.now.year
        time.localtime.strftime("%B %-d at %l:%M%P")
      else
        time.localtime.strftime("%B %-d, %Y at %l:%M%P")
      end
    end
  end
  def format_date(year,month,day)
    if day != 0 and month != 0
      "%s %d, %d" % [Date::MONTHNAMES[month],day,year]
    elsif month != 0
      "%s, %d" % [Date::MONTHNAMES[month],year]
    else
      year.to_s
    end
  end
end
