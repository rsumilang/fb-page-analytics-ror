class PagesController < ApplicationController
  before_action :set_auth
  before_action :sync_user_pages


  # Page handler
  def index
    @fb_pages = current_user.fb_pages
    if @fb_pages.length === 1
      redirect_to controller: 'stats', action: 'index', id: @fb_pages.first['id']
    end
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
