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
    name=params[:name]
    trip=nil
    tripstart=params[:name].rindex("#")
    if tripstart != nil
        trip=tripcreate(name,tripstart)
        name=name[0..tripstart-1]
    end
    ActiveRecord::Base.connection.execute("INSERT INTO bbs(name,maintext,trip) VALUES('#{name}','#{params[:maintext]}','#{trip}');")
    redirect '/main/'
end

post '/delete/' do
    ActiveRecord::Base.connection.execute("DELETE FROM bbs WHERE no is #{params[:no]};")
    redirect '/main/'
end

def tripcreate(str,n)
    trip=str[n+1..-1]
    if trip==""
       trip=" " 
    end
    key= (trip + "H.").slice(1, 2)
    key = key.gsub(/[^\.-z]/, ".")
    key = key.tr(":;<=>?@[\\]^_`", "ABCDEFGabcdef")
    trip = trip.crypt(key).slice(-10, 10);
    trip="◆"+trip
    return trip
end
