module IssuesHelper
  def select_options_for_statuses
    select_options_for_enum Issue.statuses
  end

  def select_options_for_priorities
    select_options_for_enum Issue.priorities
  end

  def select_options_for_issue_types
    select_options_for_enum Issue.issue_types
  end

  def select_options_for_enum(enum_hash)
    enum_hash.collect { |key, _| [key.humanize, key] }
  end
end
