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
    # List of user FB pages
    user_fb_pages = Hash.new
    user.facebook_accounts.each do |user_fb_page|
      user_fb_pages[user_fb_page['id'].to_s] = user_fb_page
    end

    # Query the data and update it
    fb_pages = where(fb_page_id: user_fb_pages.keys)
    existing_ids = []
    fb_pages.each do |fb_page|
      existing_ids << fb_page['fb_page_id'].to_s
      current_page_info = user_fb_pages[ fb_page['fb_page_id'].to_s ]
      if fb_page['name'] != current_page_info['name'] and fb_page['category'] != current_page_info['category']
        fb_page['name'] = current_page_info['name']
        fb_page['category'] = current_page_info['category']
        fb_page.save
        logger.debug "Updating fb_pages[#{fb_page['id']}] with recent information"
      else
        logger.debug "Found fb_pages[#{fb_page['id']}] but nothing to do"
      end
    end

    # Store new entries in db
    new_pages = user_fb_pages.select { |k,v| !existing_ids.include?(k) }
    new_pages.each do |fb_page|
      create(
        name: fb_page[1]['name'],
        fb_page_id: fb_page[1]['id'],
        category: fb_page[1]['category']
      )
      logger.debug "Inserting new fb_pages[#{fb_page[1]['id']}]"
    end

  end

end
