require_dependency 'version'

class Version
  belongs_to :version_load
  
  def load_start
    @load_start = self.effective_date - self.version_load.weeks_before * 7
  end
  
  def load_end
    @load_end = self.effective_date + self.version_load.weeks_after * 7
  end
  
  def load_weeks
    load_start.cweek..load_end.cweek
  end
end
