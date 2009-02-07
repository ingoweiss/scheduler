require File.join(File.expand_path(File.dirname(__FILE__)), '../../lib/cron/task')

describe Scheduler::Cron::Task do
  
  before do
    @task = Scheduler::Cron::Task.new('do_something')
  end
  
  it "initializer should take task as argument" do
    @task.task.should eql('do_something')
  end
  
  it "should have a 'at_minute' method that sets the minute and returns the task" do
    @task.at_minute(1, 30).should eql(@task)
    @task.minute.should ==(Set[1, 30])
  end
  
  
  describe "'at_minute' method" do
    
    it "should set the minute and return the task" do
      @task.at_minute(0,20).should eql(@task)
      @task.minute.should ==(Set[0, 20])
    end
    
    it "should raise an argument error if minutes don't exist" do
      lambda { 
        @task.at_minute(60)
      }.should raise_error
    end
    
  end
  
  describe "'minute_string' method" do
    
    it "should return minutes, sorted and separated by commas" do
      @task.at_minute(22, 50, 9)
      @task.minute_string.should eql('9,22,50')
    end
  
    it "should return '*' if all minutes are specified" do
      @task.at_minute(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59)
      @task.minute_string.should eql('*')
    end
    
  end
  
  describe "'at_hour' method" do
    
    it "should set the hour and return the task" do
      @task.at_hour(0, 20).should eql(@task)
      @task.hour.should ==(Set[0, 20])
    end
    
    it "should raise an argument error if hours don't exist" do
      lambda { 
        @task.at_hour(24)
      }.should raise_error
    end
    
  end
  
  describe "'hour_string' method" do
    
    it "should return hours, sorted and separated by commas" do
      @task.at_hour(0, 22, 20)
      @task.hour_string.should eql('0,20,22')
    end
  
    it "should return '*' if all hours are specified" do
      @task.at_hour(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
      @task.hour_string.should eql('*')
    end
    
  end
  
  describe "'on_month' method" do
    
    it "should set the month and return the task" do
      @task.on_month(1).should eql(@task)
      @task.month.should ==(Set[1])
    end
    
    it "should raise an argument error if months don't exist" do
      lambda { 
        @task.on_month(13)
      }.should raise_error
      lambda { 
        @task.on_month(0)
      }.should raise_error
    end
    
    it "should understand month symbols" do
      @task.on_month(:jan, :mar)
      @task.month.should ==(Set[1, 3])
    end
  
    it "should raise error when fed bad month symbols" do
      lambda {
        @task.on_month(:wed)
      }.should raise_error
    end
    
  end
  
  describe "'month_string' method" do
    
    it "should return months, sorted and separated by commas" do
      @task.on_month(11,3,5)
      @task.month_string.should eql('3,5,11')
    end
  
    it "should return '*' if all days are specified" do
      @task.on_month(1,2,3,4,5,6,7,8,9,10,11,12)
      @task.month_string.should eql('*')
    end
    
  end
  
  describe "'on_day_of_month' method" do
    
    it "should set the month and return the task" do
      @task.on_day_of_month(2).should eql(@task)
      @task.day_of_month.should ==(Set[2])
    end
    
    it "should raise an argument error if months don't exist" do
      lambda { 
        @task.on_day_of_month(32)
      }.should raise_error
      lambda { 
        @task.on_day_of_month(0)
      }.should raise_error
    end
    
  end
  
  describe "'day_of_month_string' method" do
    
    it "should return days, sorted and separated by commas" do
      @task.on_day_of_month(4,5)
      @task.day_of_month_string.should eql('4,5')
    end
  
    it "should return '*' if all days are specified" do
      @task.on_day_of_month(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      @task.day_of_month_string.should eql('*')
    end
    
  end
  
  describe "'on_day_of_week' method" do
  
    it "should set the day of week and return the task" do
      @task.on_day_of_week(3).should eql(@task)
      @task.day_of_week.should ==(Set[3])
    end
  
    it "should raise an argument error if days don't exist" do
      lambda { 
        @task.on_day_of_week(1,7) # 7 is > 6
      }.should raise_error
    end
  
    it "should understand day symbols" do
      @task.on_day_of_week(:mon, :wed)
      @task.day_of_week.should ==(Set[1, 3])
    end
  
    it "should raise error when fed bad day symbols" do
      lambda {
        @task.on_day_of_week(:april)
      }.should raise_error
    end
    
  end
  
  describe "'day_of_week_string' method" do
  
    it "should return days, sorted and separated by commas" do
      @task.on_day_of_week(4,5)
      @task.day_of_week_string.should eql('4,5')
    end
  
    it "should return '*' if all days are specified" do
      @task.on_day_of_week(0,1,2,3,4,5,6)
      @task.day_of_week_string.should eql('*')
    end
    
  end
  
  describe "'schedule_string' method" do
    
    it "should stitch all five schedule elements together with tabs" do
      @task.should_receive(:minute_string).and_return('minute')
      @task.should_receive(:hour_string).and_return('hour')
      @task.should_receive(:day_of_month_string).and_return('day_of_month')
      @task.should_receive(:month_string).and_return('month')
      @task.should_receive(:day_of_week_string).and_return('day_of_week')
      @task.schedule_string.should eql("minute hour day_of_month month day_of_week")
    end
    
  end
  
  
end
