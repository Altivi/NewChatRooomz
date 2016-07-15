class Web::Auth::RegistrationsController < Devise::RegistrationsController
    
  respond_to :json

  def profile_settings
    @user = current_user
  end

  def profile_settings_update
    @user = current_user
    if @user.update(profile_settings_params)
      redirect_to auth_settings_profile_url
      flash[:notice] = "Profile Info was updated!"
    else
      render 'profile_settings'
    end
  end

  private 
    def profile_settings_params
      params.require(:user).permit(:nickname, :avatar, :delete_avatar)
    end
 
end
