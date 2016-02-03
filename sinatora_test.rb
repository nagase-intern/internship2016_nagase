require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "./bbs.db"
)

helpers do
    include  Rack::Utils
    alias_method :h, :escape_html
end
class Bbs < ActiveRecord::Base
end

get '/' do
   
    erb :index
end

get '/home/' do
    erb :home
end

get '/main/' do
    @text = Bbs.order("no desc").all
    erb :main
end


post '/new' do
    Bbs.create({:name => params[:name],:maintext => params[:maintext]})
    redirect '/main/'
end

post '/delete' do
    Bbs.find(params[:id]).destroy
    #redirect '/main/'
end