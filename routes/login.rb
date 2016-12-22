get "/login" do
  erb :login
end

post "/login" do
  username = params[:username]
  password = params[:password]
  user = User.find_by(username: username)
  if user && user.authenticate(password)
    session[:user_id] = user.id
    redirect to "/search_bar"
  else
    @error = "Log in failed. Try again!"
    erb :login
  end
end
