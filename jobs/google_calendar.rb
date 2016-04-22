require 'icalendar'

ical_url = 'https://calendar.google.com/calendar/ical/jonoklee%40gmail.com/private-7554f44624c80e88ab28bfcc7f181730/basic.ics'
uri = URI ical_url

SCHEDULER.every '15s', :first_in => 4 do |job|
  result = Net::HTTP.get uri
  calendars = Icalendar.parse(result)
  calendar = calendars.first

  events = calendar.events.map do |event|
    {
      start: event.dtstart,
      end: event.dtend,
      summary: event.summary
    }
  end.select { |event| event[:start] > DateTime.now }

  events = events.sort { |a, b| a[:start] <=> b[:start] }

  events = events[0..5]

  send_event('google_calendar', { events: events })
end
