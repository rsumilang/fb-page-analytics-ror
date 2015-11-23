class FbPageUser < ActiveRecord::Base
  belongs_to :fb_page
  belongs_to :user

  validates :fb_page_id, presence: true
  validates :users_id, presence: true

  # This will sync the current pages the user manages
  # @param user
  def self.sync_user_pages(user)
    current_user_pages = FbPageUser.where(['users_id = ?', user.id])

    # Create an index of current pages in memory for speed
    indexed_user_pages = Hash.new
    current_user_pages.each do |current_user_page|
      indexed_user_pages[current_user_page.fb_page_id.to_f] = true
    end

    # Loop through user accounts user is an admin for and add them to the table
    user.facebook_accounts.each do |fb_user_account|
      create(
          users_id: user.id,
          fb_page_id: fb_user_account['id']
      ) if !indexed_user_pages.has_key?(fb_user_account['id'].to_f)
    end

  end

end
