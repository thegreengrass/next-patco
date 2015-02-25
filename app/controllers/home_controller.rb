class HomeController < ApplicationController

  def index
    @stations = Gtfs_stops.all
  end

  # Show the stop times, both inbound and outbound, for a provided stop 
  def stop_times
    @toPhiladelphia = []
    @toLindenwold = []

    @dateToUse = DateTime.now
    @times = getStopTimes(@dateToUse)

    @times.each do |s| 
      # Note: direction_id of 1 is to LINDENWOLD and
      # direction_id of 0 is to PHILADELPHIA
      if (s.direction_id == 0)
        @toPhiladelphia.push(s)
      elsif (s.direction_id == 1)
        @toLindenwold.push(s)
      end
    end
  end

  # Get the details of a specific trip, based around a specific stop
  def trip_details
    @thisStation =
      Gtfs_stops.find_by_slug(params[:station])

    @tripStopTimes =
      Gtfs_stop_times
        .select('gtfs_stop_times.*, gtfs_stops.stop_name')
        .joins("inner join gtfs_stops on gtfs_stop_times.stop_id = gtfs_stops.stop_id")
        .where('gtfs_stop_times.trip_id = ?', params[:trip])
        .order('departure_time asc')

    @timeAtThisStop =
      @tripStopTimes.where('gtfs_stop_times.stop_id = ?', @thisStation.stop_id).first.departure_time
  end
  
  private

  def getStopTimes(dateTime)
    if params[:station].is_number?
      s = Gtfs_stops.find_by_stop_id(params[:station])
    else
      s = Gtfs_stops.find_by_slug(params[:station])
    end

    # Get the name of the station with the provided id
    @theStation = s

    # Figure out which service id to use based on what day it is, and if it's a holiday or not
    holidayDay = Gtfs_calendar_dates
      .where('date = ? and exception_type = 1', dateTime.strftime('%Y%m%d'))

    if (holidayDay.count > 0)
      todaysServiceId = holidayDay.first.service_id
    else 
      case dateTime.strftime('%A').downcase
        when "monday"
          todaysServiceId = Gtfs_calendar.where("monday = ?", 1).first.service_id
        when "tuesday"
          todaysServiceId = Gtfs_calendar.where("tuesday = ?", 1).first.service_id
        when "wednesday"
          todaysServiceId = Gtfs_calendar.where("wednesday = ?", 1).first.service_id
        when "thursday"
          todaysServiceId = Gtfs_calendar.where("thursday = ?", 1).first.service_id
        when "friday"
          todaysServiceId = Gtfs_calendar.where("friday = ?", 1).first.service_id
        when "saturday"
          todaysServiceId = Gtfs_calendar.where("saturday = ?", 1).first.service_id
        when "sunday"
          todaysServiceId = Gtfs_calendar.where("sunday = ?", 1).first.service_id
      end
    end

    @debug_serviceId = todaysServiceId

    Gtfs_stop_times
      .select('gtfs_stop_times.*, gtfs_trips.direction_id')
      .where('stop_id = ? and departure_time > ?', s.id, dateTime.strftime('%H:%M:%S')).order('departure_time')
      .joins('LEFT OUTER JOIN gtfs_trips ON gtfs_stop_times.trip_id = gtfs_trips.trip_id').where('gtfs_trips.service_id = ?', todaysServiceId)
  end
end

class String
  def is_number?
    true if Float(self) rescue false
  end
end
