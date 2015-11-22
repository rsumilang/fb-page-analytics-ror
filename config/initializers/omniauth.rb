Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '146154599076289', '7ffbdcd2f53fcc7b457b87928193275b'
end