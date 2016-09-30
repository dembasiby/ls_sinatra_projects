require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'


helpers do
  def timer(start)
    "Minutes: #{start.to_s}"
    @start_time = Time.now
    @start_time = @start_time.strftime("Start to_time: %I:%M:%S %p")
    start.downto(1) { |i| sleep 60 }
    @end_time = Time.now
    @end_time.strftime("Elapsed time: %I:%M:%S %p")
  end
end


get '/' do
  erb :index
end

get '/timer' do
  "Hello Timer"
end

post '/timer/reset' do
  "Hello reset"
end
