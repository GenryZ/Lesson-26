require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure do  #create a new tables for db = database
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users" (
    "Id"        INTEGER PRIMARY KEY AUTOINCREMENT,
    "Name"      VARCHAR,
    "Phone"     VARCHAR,
    "DateStamp" VARCHAR,
    "Barber"    VARCHAR,
    "Color"     VARCHAR
)'

db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" (
	"id" 	INTEGER PRIMARY KEY AUTOINCREMENT,
	"name" TEXT


)'
before do
	db = get_db
	@barberito = db.execute 'select * from Barbers' #new variable for all views
end

def is_barber_exists? db, name #function name hold ? cos is return boolean true or false
	db.execute('select * from Barbers where name=?',[name]).length > 0 # return true or false
end
def seed_db db, barbers #seed meens napolnit'

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

seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
end


get '/' do
	erb "Hello there <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	
	erb :about
end

get '/visit' do
	erb :visit
end

get '/author' do
	erb :author
end
get '/contacts' do
	erb :contacts
end
get '/admin' do
  	erb :admin
end
post '/visit' do 
	@user_name = params[:username]
	@phone = params[:phone]
	@date_time = params[:datetime]
	@walter = params[:barbers]
	@color = params[:color]

# Validation check form

	hh = {  :username => "Enter name", :phone => "Enter phone", 
  			:datetime => "Enter datetime"}

  	hh.each do |key, value|
  		#Если параметр пуст

  		if params[key] == ""

  		#переменной error присвоить value из хэша hh

  			@error = hh[key]

  			return erb :visit
		end
	end
	db = get_db
	db.execute 'insert into
	 Users 
	 (Name, Phone, DateStamp, Barber, Color) values (?, ?, ?, ?, ?)', [@user_name, @phone, @date_time, @walter, @color]

	
	db.execute 'insert into Barbers (name) values (?)', [@walter]
	
=begin	
#Еще короче способ есть 
@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
if @error != ''
	return erb :visit
end
=end
	
	@t = Time.now
	f = File.open './public/user.txt', 'a'
	f.write "Time: #{@t} User: #{@user_name}, Phone: #{@phone}, Date: #{@date_time}, Barber: #{@walter}, Color: #{@color}\n"
	f.close
	erb :message	
end
post '/contacts' do 
	
	@email = params[:email]
	@messages = params[:messages]

#Vaditation of contacts 
gg = {:email => "Enter email",
		:messages => "You write nothing"
}
gg.each do |key, value| 
	if params[key] == ""
		@error = gg[key]
		return erb :contacts
	end
end

	f = File.open './public/contact.txt', 'a'
	f.write "Email user: #{@email}\nMessage: #{@messages}\n"
	f.close
	erb :message_2	

end

post '/admin' do 
	@login = params[:login]
	@pass = params[:password]
	
	if @login == "admin" && @pass == "secret"
		@file = File.open("./public/user.txt", "r")
	erb :result
	else 
	@report = '<p><h1>Access denied</h1></p>'
	erb :admin
	end
end
get '/showusers' do 
	db = get_db
	@show = db.execute 'select * from Users order by id desc'
	erb :showusers
		
end