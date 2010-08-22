require_dependency 'version'

class Version
  belongs_to :version_load
  
  def load_start
    @load_start = self.effective_date.cweek - self.version_load.weeks_before
  end
  
  def load_end
    @load_end = self.effective_date.cweek + self.version_load.weeks_after
  end
  
  def load_weeks
    load_start..load_end
  end
end
