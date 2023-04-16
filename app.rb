require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb 'hello'
end

get '/new' do

	erb :new
end

post '/new' do
	content= params[:content]

	erb "You post: #{content}"

end
