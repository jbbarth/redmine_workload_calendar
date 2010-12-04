require File.dirname(__FILE__) + '/../test_helper'

class WeekTest < ActiveSupport::TestCase
  should "initialize correctly" do
    week = Week.new(2011,1)
    assert_equal 2011, week.year
    assert_equal 1, week.cweek
    week = Week.new(Date.new(2011,1,3))
    assert_equal 2011, week.year
    assert_equal 1, week.cweek
  end
end
