class StatsController < ApplicationController
  before_action :set_auth
  before_action :sync_posts

  def index

  end



  protected



  def set_auth
    @auth = session[:omniauth] if session[:omniauth]
  end

  # This method starts to sync all the posts with the database
  def sync_posts
    @fb_page = FbPage.find(params[:id])
    since_timestamp = get_last_post_timestamp @fb_page['id']

    feed_results = nil
    current_user.facebook do |fb|
      payload = since_timestamp ? {:since => since_timestamp} : nil
      feed_results = fb.get_connection(@fb_page['fb_page_id'], 'feed', payload)
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


  # Figure out when the last post was that we saved and return back the timestamp
  # or return back nil
  def get_last_post_timestamp(fb_page_id)
    post = FbPagePost.where(['fb_page_id = ?', fb_page_id]).order('date_posted DESC').limit(1)
    if post.length === 1
      post.first['date_posted'].to_i
    else
      nil
    end
  end


end
