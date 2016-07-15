class Web::Auth::SessionsController < Devise::SessionsController

  protected

  def after_sign_in_path_for(user) 
    (current_user.signup_status != 'active' ? after_signup_index_path : root_path )
  end 

end
