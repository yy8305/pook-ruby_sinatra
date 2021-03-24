require 'sinatra'
require 'data_mapper'
enable :sessions


DataMapper::setup(:default, "sqlite3://#{File.dirname(__FILE__)}/hotel.db")

class User
  include DataMapper::Resource
  property :id, Serial
  property :user_email, String 
  property :user_password, String
  property :created_at, DateTime 
end

class Hotel
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :description, String, :length => 100000
  property :image_src, String, :length => 500
end

class Top10
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :description, String, :length => 100000
  property :image_src, String, :length => 500
end

class Review
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, String, :length => 100000
end

DataMapper.finalize

User.auto_upgrade!
Hotel.auto_upgrade!
Review.auto_upgrade!
Top10.auto_upgrade!

get '/' do
  @email_name = session[:email] 
  erb :index
end





get '/login' do 
  erb :login
end

post '/login_process' do

  database_user = User.first(:user_email => params[:user_email])

  md5_user_password = Digest::MD5.hexdigest(params[:user_password])

  if !database_user.nil?
    if database_user.user_password == md5_user_password
      session[:email] = params[:user_email]
      redirect '/'
    else
      "비밀번호가 틀렸습니다."
    end
  else
   "해당 유저가 없습니다."
  end
  
end


get '/logout' do
  session.clear
  redirect '/'
end

get '/join' do
  erb :join
end

post '/join_process' do

  n_user = User.new
  n_user.user_email = params[:user_email] 

  md5_password = Digest::MD5.hexdigest(params[:user_password])
  n_user.user_password = md5_password
  n_user.save

  redirect '/'
end

get '/admin' do 
  @users = User.all
  erb :admin
end

get '/user_delete/:user_id' do
  user = User.first(:id => params[:user_id])
  user.destroy
  redirect '/admin'
end

get '/soge' do
	erb :soge
end

get '/map' do
	erb :map
end

get '/top10' do
@top10=Top10.all
	erb :top10
end

get '/review' do
 @review=Review.all
 erb :review
end

post '/review_process' do
  r = Review.new
  r.title = params[:review_title]
  r.body = params[:content]
  r.save
  redirect '/review'
end


get '/gsfood' do
 @hotel=Hotel.all
 erb :gsfood
end

get '/write' do
	erb :write
end

get '/add_gsfood' do
        erb :add_gsfood
end

post '/add_gsfood_process' do
  h = Hotel.new
  h.title = params[:hotel_title]
  h.description = params[:hotel_description]
  h.image_src = params[:hotel_image_location]
  h.save
  redirect '/gsfood'
end

get '/detail/:id' do
 @review=Review.first(:id=>params[:id])
 erb :detail
end

get '/add_top10' do
        erb :add_top10
end

post '/add_top10_process' do
  t = Top10.new
  t.title = params[:top10_title]
  t.description = params[:top10_description]
  t.image_src = params[:top10_image_location]
  t.save
  redirect '/top10'
end

get '/admin_review' do 
  @review = Review.all
  erb :admin_review
end

get '/review_delete/:user_id' do
  review = Review.first(:id => params[:user_id])
  review.destroy
  redirect '/admin_review'
end

get '/admin_top10' do 
  @top10 = Top10.all
  erb :admin_top10
end

get '/top10_delete/:user_id' do
  top10 = Top10.first(:id => params[:user_id])
  top10.destroy
  redirect '/admin_top10'
end

get '/admin_gsfood' do 
  @hotel = Hotel.all
  erb :admin_gsfood
end

get '/gsfood_delete/:user_id' do
  hotel = Hotel.first(:id => params[:user_id])
  hotel.destroy
  redirect '/admin_gsfood'
end

