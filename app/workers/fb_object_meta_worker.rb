class FbObjectMetaWorker

  # Initializer just sets a few variables.
  #
  # @param oauth_token Current user logged in to access oauth_token
  #
  # @param object_id String of object_id we are working with
  def initialize(oauth_token, object_id)
    @object_id = object_id
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  # Syncs Fetches all meta info for object id and updates the database.
  def sync
    Delayed::Worker.logger.debug "[FbObjectMetaWorker] Starting job for [#{@object_id}]"

    fields = {
      :like_count => get_likes,
      :impression_count => get_impressions,
      :comment_count => get_comment_count,
      :share_count => get_share_count
    }

    FbPagePost.where(fb_post_id: @object_id).limit(1).update_all(fields)

    Delayed::Worker.logger.debug "[FbObjectMetaWorker] Completed job for [#{@object_id}]"
  end

  # Returns number of likes
  def get_likes
    @facebook.get_object("#{@object_id}/likes?summary=1").raw_response['summary']['total_count']
  end

  # Returns the number of impressions
  def get_impressions
    # Should be something like this?:
    # 510029472504391_511077702399568/insights/page_impressions?period=lifetime
    (Random.new).rand 100
  end

  # Returns the number of comments
  def get_comment_count
    @facebook.get_object("#{@object_id}/comments?summary=1").raw_response['summary']['total_count']
  end

  # Returns number of shares
  def get_share_count
    @facebook.get_object("#{@object_id}/sharedposts?summary=1").length
  end

  handle_asynchronously :sync

end