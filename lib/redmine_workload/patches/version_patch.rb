require_dependency 'version'

class Version
  belongs_to :version_load
  
  #TODO: cleanup this calculation
  def load_start
    @load_start ||= Week.new(self.effective_date) - (self.version_load.present? ? self.version_load.weeks_before : 0)
  end
  
  #TODO: cleanup this calculation
  def load_end
    @load_end ||= Week.new(self.effective_date) + (self.version_load.present? ? self.version_load.weeks_after : 0)
  end
  
  def load_weeks
    @load_weeks ||= load_start..load_end
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
