require File.join(File.expand_path(File.dirname(__FILE__)), '../../lib/cron/configuration')
require File.join(File.expand_path(File.dirname(__FILE__)), '../../lib/cron/task')

describe Scheduler::Cron::Configuration do
  
   before do
     Scheduler::Cron::Configuration.configure do |cron|
        cron.run 'do_stuff'
        cron.run 'do_more_stuff'
     end
   end
   
   it "should collect scheduled tasks" do
     tasks = Scheduler::Cron::Configuration.instance.tasks
     tasks.size.should eql(2)
     tasks.find{|task| task.task == 'do_stuff'}.should_not be_nil
     tasks.find{|task| task.task == 'do_more_stuff'}.should_not be_nil
   end
  
end