require "spec_helper"

describe "Week" do
  it "should initialize correctly" do
    week = Week.new(2011,1)
    week.year.should == 2011
    week.cweek.should == 1
    week = Week.new(Date.new(2011,1,3))
    week.year.should == 2011
    week.cweek.should == 1
  end

  it "should be comparable" do
    week1 = Week.new(2011,1)
    week2 = Week.new(2011,2)
    week3 = Week.new(2012,1)
    sorted = [week1,week2,week3]
    [week1,week3,week2].sort.should == sorted
    [week3,week2,week1,week2].uniq.sort.should == sorted
  end

  it "should allow + and - operations" do
    week1 = Week.new(2011,1)
    week2 = Week.new(2011,2)
    week3 = Week.new(2012,1)
    (week1 + 1 - 1).should == week1
    (week1 + 1).should == week2
    (week1 + 52).should == week3
    (week2 - 1).should == week1
    (week3 - 52).should == week1
  end

  it "should be iterable" do
    week = Week.new(2010,52)
    week.succ.should == Week.new(2011,1)
    week.succ.succ.should == Week.new(2011,2)
    Week.new(2012,52).succ.should == Week.new(2013,1)
  end

  it "should have an integer representation" do
    Week.new(2010,1).to_i.should == 201001
    Week.new(2010,31).to_i.should == 201031
  end

  it "should return this week for #today" do
    Week.today.should == Week.new(Date.today)
  end
end
