require_dependency 'issue'

class Issue
  def load_start
    start_date_setting = Setting[:plugin_redmine_workload_calendar][:start_date]

    if start_date_setting.to_i > 0
      custom_field_value = self.custom_value_for(start_date_setting)
      if custom_field_value.present?
        start_date = custom_field_value.value.to_date
      end
    end

    if start_date.blank?
      start_date = self.start_date.present? ? self.start_date.to_date : self.created_on.to_date
    end

    @load_start ||= Week.new(start_date)
  end

  def load_end
    end_date_setting = Setting[:plugin_redmine_workload_calendar][:end_date]

    if end_date_setting.to_i > 0
      custom_field_value = self.custom_value_for(end_date_setting)
      if custom_field_value.present?
        end_date = custom_field_value.value.to_date
      end
    end

    if end_date.blank?
      end_date = self.due_date.present? ? self.due_date.to_date : (self.closed_on.present? ? self.closed_on.to_date : (Date.today + 50.days)) # TODO remove this 50 (hardcoded value)
    end

    @load_end ||= Week.new(end_date)
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
