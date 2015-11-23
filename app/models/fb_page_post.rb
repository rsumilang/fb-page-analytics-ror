class FbPagePost < ActiveRecord::Base
  belongs_to :fb_page
  belongs_to :user

  validates :fb_page_id, presence: true
  validates :user_id, presence: true
end
