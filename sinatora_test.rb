require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require "pry"

ActiveRecord::Base.establish_connection(
    adapter:   'sqlite3',
    database:  "./bbs.db"
)

helpers do
    include  Rack::Utils
    alias_method :h, :escape_html
end

get '/' do
    erb :index
end

get '/home/' do
    erb :home
end

get '/main/' do
    @text = ActiveRecord::Base.connection.execute("select * from bbs order by no desc;")
    erb :main
end

post '/new/' do
    ActiveRecord::Base.connection.execute("INSERT INTO bbs(name,maintext) VALUES('#{params[:name]}','#{params[:maintext]}');")
    redirect '/main/'
end

post '/delete/' do
    ActiveRecord::Base.connection.execute("DELETE FROM bbs WHERE no is #{params[:no]};")
    redirect '/main/'
end

