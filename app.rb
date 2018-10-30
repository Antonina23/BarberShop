#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS Users
	("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT,
	"phone" TEXT, "datestamp" TEXT, "barber" TEXT, "color" TEXT);'
end

get '/' do
	erb "Hello,there! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@time = params[:time]
	@barber = params[:barber]
	@color = params[:color]
	@title = "Thank you!"
	@message = "Dear #{@username}, #{@phone}, we will be waiting for you at #{@time}, your master is #{@barber}, your choice color is: #{@color}"

	hh = {:username => 'Enter your name please',
		  :phone => 'Please enter your phone number',
		  :time => 'You forgot to type date and time of visit'}

		  hh.each do |key, value|
		  	if params[key] == ''
		  		@error = hh[key]
		  		return erb :visit
		  end
		end

db = get_db
db.execute 'insert into Users (username, phone, datestamp, barber,
color) values (?,?,?,?,?)', [@username, @phone,@time, @barber, @color]
	
	f = File.open './public/users.txt', 'a'
	f.write "\nUser: #{@username},\nPhone number: #{@phone},\nDay and time: #{@time},\nBarber: #{@barber},\nColor: #{@color}"
	f.close
	erb :message
end

def get_db
return SQLite3::Database.new 'barbershop.db'
end


