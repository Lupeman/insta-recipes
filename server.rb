require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require 'sinatra/activerecord'
require 'json'
require 'pg'
require 'instagram'
require 'httparty'
require_relative 'models/blog'
require_relative 'models/cse'
require_relative 'models/user'
require_relative 'routes/insta_oath'
require_relative 'routes/login'
require_relative 'routes/register'
require_relative 'routes/select_blogs'
require_relative 'routes/search'
enable :sessions

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

get "/" do
  erb :index
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



delete "/index" do
  session[:user_id] = nil
  session[:access_token] = nil
  redirect to "/"
end
