get "/blogs" do
  if session[:access_token]
    client = Instagram.client(:access_token => session[:access_token])
    @users = []
    @followers = client.user_follows
    @followers.each do |follower|
      @users.push(client.user(follower["id"]))
    end
    erb :blogs
  else
    redirect to "/login"
  end
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
