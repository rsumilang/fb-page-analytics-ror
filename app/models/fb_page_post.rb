class FbPagePost < ActiveRecord::Base
  belongs_to :fb_page

  validates :fb_page_id, presence: true
  validates :fb_post_id, presence: true

  # The purpose of this is to get the last 5 posts and sort in order of likes and
  # comments for the sake of example
  def self.topPosts(page_id, limit = 5)
    where(fb_page_id: page_id).order(like_count: :desc, comment_count: :desc).limit(limit)
  end
end
