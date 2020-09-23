module IssuesHelper
  # Creates the options for select type inputs for enums
  def create_select_options_for_enum(enum_name, enum_hash_keys)
    enum_hash_keys.collect { |key| [Issue.human_enum_name(enum_name, key), key] }
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
