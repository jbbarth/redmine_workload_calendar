require "spec_helper"

describe "Week" do
  it "should initialize correctly" do
    week = Week.new(2011,1)
    expect(week.year).to eq 2011
    expect(week.cweek).to eq 1
    week = Week.new(Date.new(2011,1,3))
    expect(week.year).to eq 2011
    expect(week.cweek).to eq 1
  end

  it "should be comparable" do
    week1 = Week.new(2011,1)
    week2 = Week.new(2011,2)
    week3 = Week.new(2012,1)
    sorted = [week1,week2,week3]
    expect([week1,week3,week2].sort).to eq sorted
    expect([week3,week2,week1,week2].uniq.sort).to eq sorted
  end

  it "should allow + and - operations" do
    week1 = Week.new(2011,1)
    week2 = Week.new(2011,2)
    week3 = Week.new(2012,1)
    expect((week1 + 1 - 1)).to eq week1
    expect((week1 + 1)).to eq week2
    expect((week1 + 52)).to eq week3
    expect((week2 - 1)).to eq week1
    expect((week3 - 52)).to eq week1
  end

  it "should be iterable" do
    week = Week.new(2010,52)
    expect(week.succ).to eq Week.new(2011,1)
    expect(week.succ.succ).to eq Week.new(2011,2)
    expect(Week.new(2012,52).succ).to eq Week.new(2013,1)
  end

  it "should have an integer representation" do
    expect( Week.new(2010,1).to_i).to eq 201001
    expect(Week.new(2010,31).to_i).to eq 201031
  end

  it "should return this week for #today" do
    expect(Week.today).to eq Week.new(Date.today)
  end
end
