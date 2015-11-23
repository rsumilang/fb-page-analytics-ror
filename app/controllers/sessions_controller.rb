class SessionsController < ApplicationController


  # This will create a session object for the logged in user. We will set the
  # :user_id as well as the :omniauth extra info in the session.
  # When complete, we redirect the user back to the homepage.
  def create
    auth = request.env['omniauth.auth']
    session[:omniauth] = auth.except('extra')
    user = User.sign_in_from_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, notice: 'SIGNED IN'
  end


  # Resets the session :user_id and :omniauth settings and sends the user back
  # to the home page.
  def destroy
    session[:user_id] = nil
    session[:omniauth] = nil
    redirect_to root_url, notice: 'SIGNED OUT'
  end


end
