require_dependency 'issue'

class Issue
  def load_start
    @load_start ||= ( self.start_date.present? ? Week.new(self.start_date.to_date) : Week.new(self.created_on.to_date) )
  end

  def load_end
    @load_end ||= ( self.due_date.present? ? Week.new(self.due_date.to_date) : Week.new(Date.today)+50 ) # TODO remove this 50 (hardcoded value)
  end

  def load_weeks
    if load_start && load_end
      @load_weeks ||= load_start..load_end
    else
      @load_weeks ||= nil
    end
  end
  
  def load_weeks_in_workload(workload)
    load_weeks.to_a.reject do |e|
      !workload.weeks.include?(e)
    end
  end

  def load_start_visible?(workload)
    workload.weeks.include?(load_start)
  end

  def load_end_visible?(workload)
    workload.weeks.include?(load_end)
  end
end
