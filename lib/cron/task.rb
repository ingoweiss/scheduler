require 'set'

module Scheduler
  module Cron
    class Task
    
      attr_reader :task, :task_root, :options, :minute, :hour, :day_of_month, :month, :day_of_week
      
      WILDCARD = '*'
    
      def initialize(task) # :nodoc:
        @task = task
      end
    
      ALL_MINUTES = Set[*0..59]
      
      # Specify the minute(s) at which the task should run
      #   # Example:
      #   at_minute(1)
      #   at_minute(1,30)
      # valid minute values are 0..59
      def at_minute(*minutes)
        set_of_minutes = minutes.to_set
        raise ArgumentError, 'invalid minutes (0..59 are valid)' unless set_of_minutes.subset?(ALL_MINUTES)
        @minute = set_of_minutes
        self
      end
    
      def minute_string # :nodoc:
        return WILDCARD if (@minute.nil? or @minute == ALL_MINUTES)
        @minute.sort.join(',')
      end
    
      ALL_HOURS = Set[*0..23]
      
      # Specify the hours(s) at which the task should run
      #   # Example: 
      #   at_hour(3)
      #   at_hour(1,12)
      # valid hour values are 0..23
      def at_hour(*hours)
        set_of_hours = hours.to_set
        raise ArgumentError, 'invalid hours (0..23 are valid)' unless set_of_hours.subset?(ALL_HOURS)
        @hour = set_of_hours
        self
      end
    
      def hour_string # :nodoc:
        return WILDCARD if (@hour.nil? or @hour == ALL_HOURS)
        @hour.sort.join(',')
      end
    
      ALL_MONTHS = Set[*1..12]
      
      # Specify the month(s) at which the task should run
      #   # Example: 
      #   on_month(1)
      #   on_month(1,6)
      #   on_month(:jan)
      #   on_month(:jan, :jul)
      # valid month values are 1..12, or :jan, :feb, :mar, :apr, :may, :jun, :jul, :aug, :sep, :oct, :nov, :dec
      def on_month(*months)
        months = months.collect{|m| numberize_month(m) }
        set_of_months = months.to_set
        raise ArgumentError, 'invalid months (1..12 are valid)' unless set_of_months.subset?(ALL_MONTHS)
        @month = set_of_months
        self
      end
    
      def numberize_month(month) # :nodoc:
        return month if month.is_a?(Integer)
        month_index = [:jan, :feb, :mar, :apr, :may, :jun, :jul, :aug, :sep, :oct, :nov, :dec].index(month)
        raise ArgumentError, "invalid month: #{month}" unless month_index
        month_index + 1
      end
    
      def month_string # :nodoc:
        return WILDCARD if (@month.nil? or @month == ALL_MONTHS)
        @month.sort.join(',')
      end
    
      ALL_DAYS_OF_MONTH = Set[*1..31]
      
      # Specify the day(s)_of_month at which the task should run
      #   # Example: 
      #   on_day_of_month(1)
      #   on_month(1,15)
      # valid month values are 1..31
      def on_day_of_month(*days)
        set_of_days = days.to_set
        raise ArgumentError, 'invalid days of month (1..31 are valid)' unless set_of_days.subset?(ALL_DAYS_OF_MONTH)
        @day_of_month = set_of_days
        self
      end
    
      def day_of_month_string # :nodoc:
        return WILDCARD if (@day_of_month.nil? or @day_of_month == ALL_DAYS_OF_MONTH)
        @day_of_month.sort.join(',')
      end
    
      ALL_DAYS_OF_WEEK = Set[*0..6]
      
      # Specify the day(s)_of_week at which the task should run
      #   # Example: 
      #   on_day_of_week(1)
      #   on_day_of_week(1,5)
      #   on_day_of_week(:mon)
      #   on_day_of_week(:mon, :fri)
      # valid month values are 0..6, or :mon, :tue, :wed, :thu, :fri, :sat, :sun
      def on_day_of_week(*days)
        days = days.collect{|d| numberize_day_of_week(d) }
        set_of_days = days.to_set
        raise ArgumentError, 'invalid days of week (0..6 are valid)' unless set_of_days.subset?(ALL_DAYS_OF_WEEK)
        @day_of_week = set_of_days
        self
      end
    
      def day_of_week_string # :nodoc:
        return WILDCARD if (@day_of_week.nil? or @day_of_week == ALL_DAYS_OF_WEEK)
        @day_of_week == ALL_DAYS_OF_WEEK ? '*' : @day_of_week.sort.join(',')
      end
    
      def numberize_day_of_week(day) # :nodoc:
        return day if day.is_a?(Integer)
        day_index = [:sun, :mon, :tue, :wed, :thu, :fri, :sat, :sun].index(day)
        raise ArgumentError, "invalid day of week: #{day}" unless day_index
        day_index
      end
      
      # Specify the directory from which the task should run
      #   # Example:
      #   from(RAILS_ROOT)
      def from(path_to_task_root)
        @task_root = path_to_task_root
        self
      end
      
      # Specify the options for the task
      #   # Example:
      #   with(:RAILS_ENV => 'production')
      def with(opts)
        @options = opts
        self
      end
      
      def options_string # :nodoc:
        return if @options.nil? or @options.empty?
        @options.collect{|key, value| [key,value].join('=') }.join(' ')
      end
      
      def schedule_string # :nodoc:
        [minute_string, hour_string, day_of_month_string, month_string, day_of_week_string].join(" ")
      end
      
      def task_string # :nodoc:
        "cd #{@task_root};`which rake` #{@task} #{options_string}"
      end
      
      def to_s # :nodoc:
        [schedule_string, task_string].join(' ')
      end
    
    end
  end
end
