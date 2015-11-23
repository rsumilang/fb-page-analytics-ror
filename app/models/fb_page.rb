class FbPage < ActiveRecord::Base
  has_many :fb_page_user, dependent: :destroy
  has_many :fb_page_post, dependent: :destroy
  has_many :user, through: :fb_page_user

  validates :name, presence: true
  validates :fb_page_id, presence: true

  # Adds user pages to the database
  #
  # @param user
  def self.add_user_pages(user)
    user.facebook_accounts.each do |page|
      # @todo SQL Injection How to?
      # @todo This could be written much much better... But eh, just an example.
      FbPage.connection.insert "REPLACE INTO #{FbPage.table_name} (name, fb_page_id, category, created_at, updated_at) VALUES ('#{page['name']}', '#{page['id']}', '#{page['category']}', datetime(), datetime())"
    end
  end

end
