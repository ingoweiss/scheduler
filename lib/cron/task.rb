require 'set'

module Scheduler
  module Cron
    class Task
    
      attr_reader :task, :minute, :hour, :day_of_month, :month, :day_of_week
    
      def initialize(task)
        @task = task
      end
    
      ALL_MINUTES = Set[*0..59]
    
      def at_minute(*minutes)
        set_of_minutes = minutes.to_set
        raise ArgumentError, 'invalid minutes (0..59 are valid)' unless set_of_minutes.subset?(ALL_MINUTES)
        @minute = set_of_minutes
        self
      end
    
      def minute_string
        @minute == ALL_MINUTES ? '*' : @minute.sort.join(',')
      end
    
      ALL_HOURS = Set[*0..23]
    
      def at_hour(*hours)
        set_of_hours = hours.to_set
        raise ArgumentError, 'invalid hours (0..23 are valid)' unless set_of_hours.subset?(ALL_HOURS)
        @hour = set_of_hours
        self
      end
    
      def hour_string
        @hour == ALL_HOURS ? '*' : @hour.sort.join(',')
      end
    
      ALL_MONTHS = Set[*1..12]
    
      def on_month(*months)
        months = months.collect{|m| numberize_month(m) }
        set_of_months = months.to_set
        raise ArgumentError, 'invalid months (1..12 are valid)' unless set_of_months.subset?(ALL_MONTHS)
        @month = set_of_months
        self
      end
    
      def numberize_month(month)
        return month if month.is_a?(Integer)
        month_index = [:jan, :feb, :mar, :apr, :may, :jun, :jul, :aug, :sep, :oct, :nov, :dec].index(month)
        raise ArgumentError, "invalid month: #{month}" unless month_index
        month_index + 1
      end
    
      def month_string
        @month == ALL_MONTHS ? '*' : @month.sort.join(',')
      end
    
      ALL_DAYS_OF_MONTH = Set[*1..31]
    
      def on_day_of_month(*days)
        set_of_days = days.to_set
        raise ArgumentError, 'invalid days of month (1..31 are valid)' unless set_of_days.subset?(ALL_DAYS_OF_MONTH)
        @day_of_month = set_of_days
        self
      end
    
      def day_of_month_string
        @day_of_month == ALL_DAYS_OF_MONTH ? '*' : @day_of_month.sort.join(',')
      end
    
      ALL_DAYS_OF_WEEK = Set[*0..6]
    
      def on_day_of_week(*days)
        days = days.collect{|d| numberize_day_of_week(d) }
        set_of_days = days.to_set
        raise ArgumentError, 'invalid days of week (0..6 are valid)' unless set_of_days.subset?(ALL_DAYS_OF_WEEK)
        @day_of_week = set_of_days
        self
      end
    
      def day_of_week_string
        @day_of_week == ALL_DAYS_OF_WEEK ? '*' : @day_of_week.sort.join(',')
      end
    
      def numberize_day_of_week(day)
        return day if day.is_a?(Integer)
        day_index = [:sun, :mon, :tue, :wed, :thu, :fri, :sat, :sun].index(day)
        raise ArgumentError, "invalid day of week: #{day}" unless day_index
        day_index
      end
      
      def schedule_string
        [minute_string, hour_string, day_of_month_string, month_string, day_of_week_string].join(" ")
      end
    
    end
  end
end
