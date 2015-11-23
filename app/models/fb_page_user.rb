class FbPageUser < ActiveRecord::Base
  belongs_to :fb_page
  belongs_to :user

  validates :fb_page_id, presence: true
  validates :users_id, presence: true

  # This will sync the current pages the user manages
  #
  # @param user
  def self.sync_user_pages(user)
    current_user_pages = FbPageUser.where(['users_id = ?', user.id])

    # Create an index of current pages in memory for speed
    indexed_user_pages = Hash.new
    current_user_pages.each do |current_user_page|
      indexed_user_pages[current_user_page.fb_page_id.to_f] = true
    end

    user_fb_accounts = user.facebook_accounts

    # Add missing pages
    self.add_user_to_pages(user, user_fb_accounts, indexed_user_pages)

    # Remove pages no longer associated with
    self.remove_user_from_pages(user, user_fb_accounts, indexed_user_pages)

  end



  private



  # Loops through user's fb_accounts and adds fb page associations where missing
  #
  # @param user User account
  #
  # @param fb_accounts Fb Accounts
  #
  # @param current_pages A hash of the current pages accessible
  def self.add_user_to_pages(user, fb_accounts, current_pages)
    fb_accounts.each do |fb_user_account|
      create(
          users_id: user.id,
          fb_page_id: fb_user_account['id']
      ) if !current_pages.has_key?(fb_user_account['id'].to_f)
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
  def self.remove_user_from_pages(user, fb_accounts, current_pages)
    fb_pages = Hash.new

    fb_accounts.each do |fb_user_account|
      fb_pages[fb_user_account['id'].to_f] = true
    end

    current_pages.each do |fb_page_id, x|
      if fb_pages.has_key?(fb_page_id)
        FbPageUser.limit(1).delete_all(['users_id = ? AND fb_page_id = ?', user.id, fb_page_id])
      end
    end

  end


end
