require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require 'sinatra/activerecord'
require 'json'
require 'pg'
require 'instagram'
require_relative 'models/blog'
require_relative 'models/cse'
require_relative 'models/user'


enable :sessions

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(user_id: session[:user_id])
  end
end

CALLBACK_URL = "http://localhost:4567/oauth/callback"

Instagram.configure do |config|
  config.client_id = ENV["INSTAGRAM_CLIENT_ID"]
  config.client_secret = ENV["INSTAGRAM_CLIENT_SECRET"]
  config.scope = "public_content follower_list"
end

get "/" do

erb :index
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/login" do
  username = params[:username]
  password = params[:password]
  user = User.find_by(username: username)
  if user
    user.authenticate(password: params[:password])
    if true
      session[:user_id] = user.id
      redirect "/saved_blogs"
    else
      "Incorrect password..please try again"
      redirect "/index"
    end
  else
    "That username doesn't exist in our database! Please connect with instagram first!"
  end
end

post "/register" do
  username = params[:username]
  user = User.find_by(username: username)
  if user
    "That user is already registered"
    redirect "/index"
  else
    user = User.new(username, password: params[:password])
    user.save
    session[:user_id] = user.id
    redirect to "/saved_blogs"
  end
end

get "/saved_blogs" do
  @listings = Blog.where(user_id: session[:user_id])
  erb :saved_blogs
end

# Redirect URI
get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  user = User.new(username: response.user.username, password:)
  user.save
  session[:user_id] = user.id
  session[:access_token] = response.access_token
  redirect "/blogs"
end

get "/feed" do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user
  html = "<h1>#{user.username}'s recent photos</h1>"
  for media_item in client.user_recent_media
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end

get "/blogs" do
  client = Instagram.client(:access_token => session[:access_token])
  @users = []
  @followers = client.user_follows
  @followers.each do |follower|
    @users.push(client.user(follower["id"]))
  end
  erb :blogs
end

post "/blogs" do
  @listings = @params["users"]
  @listings.each do |user|
    @blog_name = user["username"]
    @url = user["website"]
    blog = Blog.new(blog_name: @blog_name, url: @url, user_id: session[:user_id])
    blog.save
  end
  annotation = erb :annotations, :layout => false

  cse = CSE.new(user_id: session[:user_id], annotation: annotation)
  cse.save
  "Great Job!"
end
