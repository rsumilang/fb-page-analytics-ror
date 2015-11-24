class FbPagePost < ActiveRecord::Base
  belongs_to :fb_page

  validates :fb_page_id, presence: true
  validates :fb_post_id, presence: true
end
