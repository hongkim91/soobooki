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
end
