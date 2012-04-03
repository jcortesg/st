module ApplicationHelper  
  def current_entity_id
    user_session[:entity_id].to_s
  end
  
  def current_entity_name
    user_session[:entity_name].to_s
  end
  
  def current_user_type
    current_user.user_type + "s"
  end
end