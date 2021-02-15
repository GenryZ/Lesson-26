require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE Users (
    Id        INTEGER PRIMARY KEY AUTOINCREMENT,
    Name      VARCHAR,
    Phone     VARCHAR,
    DateStamp VARCHAR,
    Barber    VARCHAR,
    Color     VARCHAR
);
'

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