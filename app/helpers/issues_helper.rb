module IssuesHelper
  # Creates the options for select type inputs for enums
  def create_select_options_for_enum(name, hash_keys, **opt)
    options = hash_keys.collect { |key| [Issue.human_enum_name(name, key), key] }
    opt[:blank_string].present? ? [[opt[:blank_string], '']] + options : options
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
