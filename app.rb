require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db 
	@db=SQLite3::Database.new 'Orgon.db'
	@db.results_as_hash= true

end

before do
	init_db
end

configure do
	init_db

	@db.execute'CREATE TABLE IF NOT EXISTS Posts
	(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	content TEXT,
	created_date DATE,
	user TEXT
	)'

	@db.execute'CREATE TABLE IF NOT EXISTS Comment
	(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	content TEXT,
	created_date DATE,
	post_id INTEGER
	)'
end


get '/' do

	@results=@db.execute'select *from Posts order by id desc'
	erb :index
end

get '/new' do

	erb :new
end

post '/new' do
	content= params[:content]
	user=params[:user]

	hash={:user=>'Enter nick-name',:content=>'Enter text'}

	hash.each do |key,value|
		if params[key]==''
			@error=hash[key]
			return erb :new
		end
	end

	@db.execute'insert into Posts (user,content,created_date) values(?,?,datetime())',[user,content]

	redirect to '/'

end

get '/details/:post_id' do
	post_id=params[:post_id]

	result=@db.execute 'select  * from Posts where id=?',[post_id]

	@row=result[0]


	@comments=@db.execute'select * from Comment where post_id = ? order by id',[post_id]


	erb :details
end


post '/details/:post_id' do
	post_id=params[:post_id]
	content=params[:content]

		@db.execute 'insert into Comment
		(
			content,
			created_date,
			post_id
		)
			values
		(
			?,
			datetime(),
			?
		)', [content, post_id]


	redirect to ('/details/' + post_id)
end
