CALLBACK_URL = "http://localhost:4567/oauth/callback"

Instagram.configure do |config|
  config.client_id = ENV["INSTAGRAM_CLIENT_ID"]
  config.client_secret = ENV["INSTAGRAM_CLIENT_SECRET"]
  config.scope = "public_content follower_list"
end

get "/oauth/connect" do
  redirect to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

# Redirect URI
get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect to "/blogs"
end
