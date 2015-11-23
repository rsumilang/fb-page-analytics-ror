Rails.application.config.middleware.use OmniAuth::Builder do
  # Facebook Config: Environment variables required when starting app
  provider :facebook, ENV['FB_APP_ID'], ENV['FB_APP_SECRET'], :scope => 'email,manage_pages'
end
