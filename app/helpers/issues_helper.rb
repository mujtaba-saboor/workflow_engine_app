module IssuesHelper
  def select_options_for_statuses
    select_options_for_enum(:status, Issue.statuses)
  end

  def select_options_for_priorities
    select_options_for_enum(:priority, Issue.priorities)
  end

  def select_options_for_issue_types
    select_options_for_enum(:issue_type, Issue.issue_types)
  end

  def select_options_for_enum(enum_name, enum_hash)
    enum_hash.collect { |key, _| [Issue.human_enum_name(enum_name, key), key] }
  end

  def bootstrap_color_string_for_status(status)
    case status
    when 'open'
      'primary'
    when 'in_progress'
      'info'
    when 'resolved'
      'warning'
    when 'closed'
      'success'
    end
  end

  def bootstrap_color_string_for_priority(priority)
    priority == 'high' ? 'danger' : 'warning'
  end

  def bootstrap_color_string_for_issue_type(issue_type)
    issue_type == 'bug' ? 'danger' : 'warning'
  end
end
