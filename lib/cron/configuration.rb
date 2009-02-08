require 'singleton'

module Scheduler
  module Cron
    class Configuration
      
      include Singleton
      attr_accessor :tasks
      
      def initialize # :nodoc:
        @tasks = []
      end
      
      # Run task with specified name
      #   # Example:
      #   run('do:some:stuff')
      def run(task_name)
        task = Cron::Task.new(task_name)
        @tasks << task
        task
      end
      
      # Write crontab file to disk
      #   # Example:
      #   Scheduler::Cron.write(File.join(RAILS_ROOT, 'config/crontab'))
      def self.write(file='/tmp/crontab')
        File.open(file, 'w') do |crontab_file|
          self.instance.tasks.each do |task|
            crontab_file.puts task.to_s
          end
        end
      end
      
      # Install crontab file
      #   # Example:
      #   Scheduler::Cron.install(File.join(RAILS_ROOT, 'config/crontab'))
      def self.install(file='/tmp/crontab')
        %x[crontab #{file}]
      end
      
      # Yield Configuration singleton instance
      #   # Example:
      #   Scheduler::Cron::Configuration.configure do |cron|
      #     cron.run(...)
      #   end
      def self.configure
        yield self.instance
      end
      
    end
  end
end