#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db,name
	db.execute('select * from Barbers where name=?', [name]).size > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
		db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'select *from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS Users
	("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT,
	"phone" TEXT, "datestamp" TEXT, "barber" TEXT, "color" TEXT);'

	db.execute 'CREATE TABLE IF NOT EXISTS Barbers
	("id" INTEGER PRIMARY KEY AUTOINCREMENT, "name" TEXT);'

	seed_db db, ['Walter White', 'Jessie Pinky', 'Jhon Woo', 'Davie Jhons']
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

get '/show' do
	db = get_db
	@results = db.execute 'select * from Users order by id desc'
	erb :base
end


