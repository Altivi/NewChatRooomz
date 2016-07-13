module Sessionable
  
  extend ActiveSupport::Concern

  def signed_in?
    !current_session.nil?
  end

  def current_session
    access_token  = request.headers["HTTP_ACCESS_TOKEN"]
    @current_session ||= Session.find_by(access_token: access_token)
  end

  def current_session=(session)
    @current_session = session
  end

  def current_user
    @current_user ||= current_session.user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

end