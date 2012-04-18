module ApplicationHelper

  # TODO: Delete
  def current_entity_id
    user_session[:entity_id].to_s
  end

  # TODO: Delete
  def current_entity_name
    user_session[:entity_name].to_s
  end
end