class FbPage < ActiveRecord::Base
  has_many :fb_page_user, dependent: :destroy
  has_many :fb_page_post, dependent: :destroy
  has_many :user, through: :fb_page_user

  validates :name, presence: true
  validates :page_id, presence: true
end
