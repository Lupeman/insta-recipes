get "/register" do
    erb :register
end

post "/register" do
  username = params[:username]
  user = User.find_by(username: username)
  if user
    @error = "That username is taken. Try again!"
    erb :register
  else
    user = User.new(username: username, password: params[:password])
    user.save
    session[:user_id] = user.id
    redirect to "/oauth/connect"
  end
end
