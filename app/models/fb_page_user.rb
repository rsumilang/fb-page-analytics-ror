class FbPageUser < ActiveRecord::Base
  belongs_to :fb_page
  belongs_to :user

  validates :fb_page_id, presence: true
  validates :users_id, presence: true

  # This will sync the current pages the user manages
  #
  # @param user
  def self.sync_user_pages(user)
    # Create an index of current pages in memory for speed
    indexed_user_pages = Hash.new
    current_user_pages = FbPageUser.where(['users_id = ?', user.id])
    current_user_pages.each do |current_user_page|
      indexed_user_pages[current_user_page.fb_page_id.to_s] = true
    end


    # Fetch FB User Pages
    user_fb_accounts = user.facebook_accounts


    # Create an index of current pages in memory for speed
    indexed_fb_pages = Hash.new
    fb_page_ids = []
    user_fb_accounts.each do |fb_account|
      fb_page_ids << fb_account['id']
    end
    fb_pages = FbPage.where(fb_page_id: fb_page_ids)
    fb_pages.each do |fb_page|
      indexed_fb_pages[fb_page.fb_page_id.to_s] = fb_page.id
    end


    # Add missing pages
    self.add_user_to_pages(user, user_fb_accounts, indexed_user_pages, indexed_fb_pages)

    # Remove pages no longer associated with
    self.remove_user_from_pages(user, user_fb_accounts, indexed_user_pages, indexed_fb_pages)

  end



  private



  # Loops through user's fb_accounts and adds fb page associations where missing
  #
  # @param user User account
  #
  # @param fb_accounts Fb Accounts
  #
  # @param current_pages A hash of the current pages accessible
  #
  # @param fb_pages A hash of fb pages and their id
  def self.add_user_to_pages(user, fb_accounts, current_pages, fb_pages)
    fb_accounts.each do |fb_user_account|
      fb_page_id = fb_pages[ fb_user_account['id'] ].to_s
      create(
          users_id: user.id,
          fb_page_id: fb_page_id
      ) if !current_pages.has_key?(fb_page_id)
    end
  end


  # Loops through user's fb_accounts and removes fb page associations where
  # user is no longer an admin
  #
  # @param user User account
  #
  # @param fb_accounts Fb Accounts
  #
  # @param current_pages A hash of the current pages accessible
  #
  # @param fb_pages A hash of fb pages and their id
  def self.remove_user_from_pages(user, fb_accounts, current_pages, fb_pages)
    user_fb_pages = Hash.new

    fb_accounts.each do |fb_user_account|
      user_fb_pages[fb_user_account['id'].to_s] = true
    end

    current_pages.each do |fb_page_id, x|
      if user_fb_pages.has_key?(fb_page_id)
        FbPageUser.destroy(['users_id = ? AND fb_page_id = ?', user.id, fb_pages[fb_page_id]])
      end
    end

  end


end
