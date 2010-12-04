class Week < Struct.new(:year,:cweek)
  def initialize(*args)
    if args.first.is_a?(Date)
      super(args.first.year, args.first.cweek)
    else
      super(*args)
    end
  end

  def first_day
    Date.commercial(self.year,self.cweek,1)
  end

  def last_day
    Date.commercial(self.year,self.cweek,7)
  end

  def <=>(other)
    [self.year,self.cweek] <=> [other.year,other.cweek]
  end
end
