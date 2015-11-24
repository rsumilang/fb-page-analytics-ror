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
    likes = get_likes
  end

  # Returns number of likes
  def get_likes
    @facebook.get_object("#{@object_id}/likes?summary=1").raw_response['summary']['total_count']
  end

  handle_asynchronously :sync

end