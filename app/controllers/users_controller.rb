class UsersController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, :only => [:new, :create]
  load_and_authorize_resource
  layout :sign

  # GET /users/1/all
  # GET /users/1/all.json 
  def all    
    @users = User.all_except_admin
  end
  
  # POST /users/1/approve
  # POST /users/1/approve.json 
  def approve
    @user = User.find(params[:id]) 
    
    if @user.approved
      @user.disapprove 
    else   
      @user.approve
    end
        
    redirect_to "/users/all"
  end
    
  private

  def sign
    action_name == "all" || action_name == "fees" ? "application" : "sign"
  end
  
  def after_inactive_sign_up_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      session[:signed_up_user_id] = resource_or_scope.id
      session[:signed_up_user_type] = resource_or_scope.user_type
      role = resource_or_scope.user_type
      send("new_#{role}_path")
    else
      super
    end
  end
end