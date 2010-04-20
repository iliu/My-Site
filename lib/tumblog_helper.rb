
require 'time'

module TumblogHelper

  DAYS = {}
  (1..31).each {|day| DAYS[day] = "%dth" % day}
  DAYS[1]  = "1st"
  DAYS[2]  = "2nd"
  DAYS[3]  = "3rd"
  DAYS[21] = "21st"
  DAYS[22] = "22nd"
  DAYS[23] = "23rd"
  DAYS[31] = "31st"

  def tumblog_date( time )
    <<-HTML
    <p class="postdate">
      <strong class="day">#{TumblogHelper::DAYS[time.day]}</strong>
      <strong class="month">#{Time::RFC2822_MONTH_NAME.at(time.month-1)}</strong>
      <strong class="year">#{time.year}</strong>
    </p>
    HTML
  end

end  # module TumblogHelper

Webby::Helpers.register(TumblogHelper)

# EOF
