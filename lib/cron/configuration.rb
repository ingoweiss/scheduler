require 'singleton'

module Scheduler
  module Cron
    class Configuration
      
      include Singleton
      attr_accessor :tasks
      
      def initialize
        @tasks = []
      end
      
      def run(task_name)
        task = Cron::Task.new(task_name)
        @tasks << task
        task
      end
      
      def write
        File.open(File.join(RAILS_ROOT, 'config/crontab'), 'w') do |crontab_file|
          @tasks.each do |task|
            crontab_file.puts task.schedule_string
          end
        end
      end
      
      def self.configure
        yield self.instance
      end
      
    end
  end
end