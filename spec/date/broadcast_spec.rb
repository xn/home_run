require File.expand_path('../../spec_helper', __FILE__)

describe :date_broadcast, :shared => true do
  ruby_version_is "" ... "1.9" do
    it "creates a Date for the day of Julian calendar reform in Italy by default" do
      d = Date.send(@method)
      d.year.should  == 1582
      d.month.should == 10
      d.day.should   == 15
    end
  end

  ruby_version_is "1.9" do
    it "creates a Date for Julian Day Number day 0 by default" do
      Date.send(@method).jd.should == 0
    end
  end

  ruby_version_is "" ... "1.9" do
    it "Creates a Date for the friday in the year and week given" do
      d = Date.send(@method, 2000, 1)
      d.year.should  == 2000
      d.month.should == 1
      d.day.should   == 7
      d.bwday.should == 5
    end
  end

  ruby_version_is "1.9" do
    it "Creates a Date for the monday in the year and week given" do
      d = Date.send(@method, 2000, 1)
      d.year.should  == 2000
      d.month.should == 1
      d.day.should   == 3
      d.bwday.should == 1
    end
  end

  it "Creates a Date for the correct day given the year, week and day number" do
    d = Date.send(@method, 2004, 1, 1)
    d.year.should   == 2003
    d.month.should  == 12
    d.day.should    == 29
    d.bwday.should  == 1
    d.bweek.should  == 1
    d.bwyear.should == 2004
  end

  it "raises errors for invalid dates" do
    lambda { Date.send(@method, 2004, 53, 1) }.should_not raise_error(ArgumentError)
    lambda { Date.send(@method, 2004, 53, 0) }.should raise_error(ArgumentError)
    lambda { Date.send(@method, 2004, 53, 8) }.should raise_error(ArgumentError)
    lambda { Date.send(@method, 2004, 54, 1) }.should raise_error(ArgumentError)
    lambda { Date.send(@method, 2004,  0, 1) }.should raise_error(ArgumentError)

    lambda { Date.send(@method, 2003, 52, 1) }.should_not raise_error(ArgumentError)
    lambda { Date.send(@method, 2003, 53, 1) }.should raise_error(ArgumentError)
    lambda { Date.send(@method, 2003, 52, 0) }.should raise_error(ArgumentError)
    lambda { Date.send(@method, 2003, 52, 8) }.should raise_error(ArgumentError)
  end
end

describe "Date.broadcast" do
  it_behaves_like(:date_broadcast, :broadcast)
  
  ruby_version_is "" ... "1.9" do
    it "should have defaults and an optional sg value" do
      Date.broadcast.should == Date.broadcast(1582, 41, 5)
      Date.broadcast(2008).should == Date.broadcast(2008, 41, 5)
      Date.broadcast(2008, 1).should == Date.broadcast(2008, 1, 5)
      Date.broadcast(2008, 1, 1).should == Date.broadcast(2008, 1, 1)
      Date.broadcast(2008, 1, 1, 1).should == Date.broadcast(2008, 1, 1)
    end
  end
  
  ruby_version_is "1.9" do
    it "should have defaults and an optional sg value" do
      Date.broadcast.should == Date.jd
      Date.broadcast(2008).should == Date.broadcast(2008, 1, 1)
      Date.broadcast(2008, 1).should == Date.broadcast(2008, 1, 1)
      Date.broadcast(2008, 1, 1).should == Date.broadcast(2008, 1, 1)
      Date.broadcast(2008, 1, 1, 1).should == Date.broadcast(2008, 1, 1)
    end
  end

  it ".should not accept more than 4 arguments" do
    proc{Date.broadcast(2008, 1, 1, 1, 1)}.should raise_error(ArgumentError)
  end

  it "should raise ArgumentError for invalid dates" do
    proc{Date.broadcast(2008, 54, 6)}.should raise_error(ArgumentError)
    proc{Date.broadcast(2009, 1, 8)}.should raise_error(ArgumentError)
  end

  it "should keep the same class as the receiver" do
    c = Class.new(Date)
    c.broadcast.should be_kind_of(c)
  end
end

ruby_version_is "" ... "1.9" do
  describe "Date.newbw" do
    it_behaves_like(:date_broadcast, :newbw)
  end
end

describe "Date.valid_broadcast?" do

  ruby_version_is "" ... "1.9" do
    it "should be able to determine if the date is a valid broadcast date" do
      Date.valid_broadcast?(1582, 41, 4).should == Date.civil(1582, 10, 14).jd
      Date.valid_broadcast?(1582, 41, 5).should == Date.civil(1582, 10, 15).jd
      
      Date.valid_broadcast?(1582, 41, 4, Date::ENGLAND).should == Date.civil(1582, 10, 14).jd
      Date.valid_broadcast?(1752, 37, 4, Date::ENGLAND).should == Date.civil(1752, 9, 14, Date::ENGLAND).jd
      
      Date.valid_broadcast?(2007, 45, 1).should == 2454410
      Date.valid_broadcast?(2007, 45, 1, 1).should == 2454410
      Date.valid_broadcast?(2007, 54, 1, 1).should == nil
    end
    
    it "#existw? should be the same as valid_broadcast?" do
      Date.existw?(2007, 45, 1, 1).should == Date.valid_broadcast?(2007, 45, 1, 1)
    end

    it "should be able to handle negative week and day numbers" do
      Date.valid_broadcast?(1582, -12, -4).should == Date.civil(1582, 10, 14).jd
      Date.valid_broadcast?(1582, -12, -3).should == Date.civil(1582, 10, 15).jd
      
      Date.valid_broadcast?(2007, -44, -2).should == Date.civil(2007, 3, 3).jd
      Date.valid_broadcast?(2008, -44, -2).should == Date.civil(2008, 3, 1).jd
    end
  end

  ruby_version_is "1.9" do
    it "should be able to determine if the date is a valid broadcast date" do
      Date.valid_broadcast?(1582, 39, 4).should == true
      Date.valid_broadcast?(1582, 39, 5).should == true
      Date.valid_broadcast?(1582, 41, 4).should == true
      Date.valid_broadcast?(1582, 41, 5).should == true
      Date.valid_broadcast?(1582, 41, 4, Date::ENGLAND).should == true
      Date.valid_broadcast?(1752, 37, 4, Date::ENGLAND).should == true
      
      Date.valid_broadcast?(2007, 45, 1).should == true
      Date.valid_broadcast?(2007, 45, 1, 1).should == true
      Date.valid_broadcast?(2007, 54, 1, 1).should == false
    end

    it "should be able to handle negative week and day numbers" do
      Date.valid_broadcast?(1582, -12, -4).should == true
      Date.valid_broadcast?(1582, -12, -3).should == true
      
      Date.valid_broadcast?(2007, -44, -2).should == true
      Date.valid_broadcast?(2008, -44, -2).should == true
    end
  end

end
