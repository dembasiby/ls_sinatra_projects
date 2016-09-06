require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  '<h1>Welcome to the <em>home page</em>!</h1>'
end

get '/about' do
  'This is our first Sinatra app!'
end

get '/roll-die' do
  "Your die roll is...#{rand(1...7)}"
end

get '/square/:number' do
  number = params[:number].to_i
  
  if number.to_s == params[:number]
    "#{number * number}"
  else
    "That's not a number!"  
  end
end

get '/puppies/:name' do
    "Arf, Arf!"
end

get '/puppies/:id' do
    "Woof"
end



