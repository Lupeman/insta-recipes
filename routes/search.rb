get "/search_bar" do
  erb :search_bar
end

post "/search_bar" do
  if @params["q"] == ""
    erb :search_oops
  else
    @search_results = HTTParty.get("https://www.googleapis.com/customsearch/v1?q=#{@params[:q]}&key=AIzaSyAoJVio5KbpyGK_f7XJ8pFThD-Y-QgeVV4&cx=011373764146364887241:mwbnfd3igny")
    @listings = Blog.where(user_id: session[:user_id])
    if @listings.length > 0
      erb :saved_blogs
    else
      redirect to "/oauth/connect"
    end
  end
end
