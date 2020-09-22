module ApplicationHelper
  include Pagy::Frontend

  def bootstrap_color_for_alert(alert_type)
    case alert_type
    when 'error'
      'danger'
    when 'notice'
      'success'
    else
      'info'
    end
  end
end
