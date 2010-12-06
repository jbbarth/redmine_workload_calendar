require_dependency 'version'

class Version
  belongs_to :version_load
  
  def load_start
    @load_start ||= self.effective_date - (self.version_load.present? ? self.version_load.weeks_before * 7 : 0)
  end
  
  def load_end
    @load_end ||= self.effective_date + (self.version_load.present? ? self.version_load.weeks_after * 7 : 0)
  end
  
  def load_period
    @load_period ||= load_start..load_end
  end
  
  def load_weeks
    @load_weeks ||= load_period.map(&:cweek).uniq
  end
  
  def load_weeks_in_workload(workload)
    load_weeks.reject{|e|!workload.weeks.include?(e)}
  end
end
