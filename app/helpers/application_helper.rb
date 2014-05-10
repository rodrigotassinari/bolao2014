module ApplicationHelper

  def css_class_for_flash_type(type)
    return '' if type.to_sym == :notice
    return 'warning' if type.to_sym == :alert
    return 'alert' if (type.to_sym == :error || type.to_sym == :failure)
    type.to_s
  end

end
