module HomeHelper

  def latest_contributor_action(latest_action)
    action = ""
    case latest_action.class.to_s
      when "Review"
        action << link_to('Reviewed', eval("#{latest_action.reviewed_object.class.to_s.downcase}_reviews_path(#{latest_action.reviewed_object.id})"))
        action << " a #{latest_action.reviewed_object.class.to_s.downcase}: "
        action << link_to(truncate(latest_action.reviewed_object.log_name, :length => 30), eval("#{latest_action.reviewed_object.class.to_s.downcase}_path(#{latest_action.reviewed_object.id})"))
      else
        action << "Submited a #{latest_action.class.to_s.downcase}: "
        action << link_to(truncate(latest_action.log_name, :length => 30), eval("#{latest_action.class.to_s.downcase}_path(#{latest_action.id})"))
    end
    action
  end

end
