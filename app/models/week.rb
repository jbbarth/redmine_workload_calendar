class Week < Struct.new(:year,:cweek)
  def initialize(*args)
    if args.first.is_a?(Date)
      super(args.first.year, args.first.cweek)
    else
      super(*args)
    end
  end

  def self.today
    Week.new(Date.today)
  end

  def first_day
    Date.commercial(year,cweek,1)
  end

  def last_day
    Date.commercial(year,cweek,7)
  end

  def <=>(other)
    [year,cweek] <=> [other.year,other.cweek]
  end

  def +(int)
    Week.new(first_day + 7*int)
  end

  def -(int)
    Week.new(first_day - 7*int)
  end

  def succ
    Week.new(first_day + 7)
  end

  def to_i
    "#{year}#{"%0.2d" % cweek}".to_i
  end
end
