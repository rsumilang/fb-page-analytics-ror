class PagesController < ApplicationController
  before_action :set_auth

  # Page handler
  def index
    sync_user_pages

    logger.debug "Debugging current user"
    #logger.debug current_user.fb_page

  end



  private



  # Updates all the facebook pages that the user is an administer for
  def sync_user_pages
    FbPageUser.sync_user_pages current_user
  end

  # Sets the auth variable
  def set_auth
    @auth = session[:omniauth] if session[:omniauth]
  end

end
