require 'sinatra'
require 'sass'

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :stylesheet
end

get '/' do
  haml :home, :layout => :index
end

get '/contact' do
  haml :contact, :layout => :index
end

# Contact form
post '/contact' do 
  require 'pony'
  
  Pony.mail(
    # Configured for Heroku here:
    :name => params[:name],
    :mail => params[:mail],
    :body => params[:body],
    # Change contact e-mail here:
    :to => 'someone@somewhere.com',
    :subject => params[:name] + ' ' + params[:mail] + " has contacted you",
    :via => :smtp,
    :via_options => {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  )
  
  redirect '/success' 
end

get '/success' do
  haml :success, :layout => :index
end

