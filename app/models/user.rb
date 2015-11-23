class User < ActiveRecord::Base
  has_many :fb_page_user, dependent: :destroy
  has_many :fb_page, through: :fb_page_user

  validates :name, presence: true
  validates :email, presence: true
  validates :uid, presence: true
  validates :oauth_token, presence: true
  validates :oauth_expires_at, presence: true


  # This is called from the `session_controller.create` method when a successful
  # login has taken place.
  #
  # @param auth Omniauth response from login.
  #
  # @return User
  def self.sign_in_from_omniauth(auth)
    user = find_by(provider: auth['provider'], uid: auth['uid'])
    if user
      update_user user, auth
    else
      create_user_from_omniauth(auth)
    end
  end


  # Called when an existing user was not found in the database. We'll be
  # creating a new user in the database and storing their information.
  #
  # @param auth Omniauth response from login.
  #
  # @return User
  def self.create_user_from_omniauth(auth)
    create(
      provider: auth['provider'],
      uid: auth['uid'],
      name: auth['info']['name'],
      email: auth['info']['email'],
      oauth_token: auth['credentials']['token'],
      oauth_expires_at: auth['credentials']['expires_at']
    )
  end


  # Updates user name, email, and oauth information when logging in.
  #
  # @param user User object to update
  #
  # @param auth Authentication information returned by Omniauth
  #
  # @return User
  def self.update_user(user, auth)
    user.update(
      name: auth['info']['name'],
      email: auth['info']['email'],
      oauth_token: auth['credentials']['token'],
      oauth_expires_at: auth['credentials']['expires_at']
    )
    user
  end


  # Creates facebook instance variable and handles exceptions thrown by the API.
  # This is useful by passing a "block" to be yielded.
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

end
