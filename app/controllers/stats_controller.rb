class StatsController < ApplicationController
  before_action :set_auth
  before_action :sync_posts

  def index

  end


  private


  def set_auth
    @auth = session[:omniauth] if session[:omniauth]
  end

  def sync_posts
    @fb_page = FbPage.find(params[:id])
    feed_results = nil
    current_user.facebook do |fb|
      feed_results = fb.get_connection(@fb_page['fb_page_id'], 'feed')
    end

    # Loop through results and add them to db
    feed_results.each do |post|
      payload = {
        fb_page_id: @fb_page['id'],
        fb_post_id: post['id'],
        message: post['message'],
        date_posted: post['created_time']
      }
      FbPagePost.create payload

      # Create jobs to update the meta information
      fb_object_meta_worker = FbObjectMetaWorker.new current_user['oauth_token'], post['id']
      fb_object_meta_worker.sync
    end

  end

end
