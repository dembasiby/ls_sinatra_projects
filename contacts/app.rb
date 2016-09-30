require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

configure do
  enable :sessions
  set :session_secret, 'secret_key'
end

configure do
  set :erb, :escape_html => true
end

before do
  session[:categories] ||= []
end

def next_element_id(elements)
  max = elements.map { |element| element[:id] }.max || 0
  max + 1
end

def error_for_category_name(name)
  if !(1..50).cover?(name.size)
    'Category name must be between 1 and 50 characters.'
  elsif session[:categories].any? do |category|
          category[:name].downcase == name.downcase
        end
    'Category name must be unique!'
  end
end

def error_for_contact_details(contact)
  contact_firstname = params[:contact_firstname].strip
  contact_lastname = params[:contact_lastname].strip
  contact_phone = params[:contact_phone].strip
  contact_email = params[:contact_email].strip

  if contact_firstname.empty? || contact_lastname.empty? ||
    contact_phone.empty? || contact_email.empty?
    session[:error] = "Contact details must be filled"
  end
end

def load_category(id)
  category = session[:categories].find { |cat| cat[:id] == id }
  return category if category

  session[:error] = 'The specified category was not found.'
  redirect '/categories'
end

# ROUTES

get '/' do
  redirect '/categories'
end

# View all the categories
get '/categories' do
  @categories = session[:categories]
  @category_id = params[:id].to_i
  erb :index
end

# Render the form for creating a new category
get '/categories/new' do
  erb :new_category
end

# Create a new category
post '/categories/new' do
  category = params[:category].strip
  error = error_for_category_name(category)

  if error
    session[:error] = error
    erb :new_category
  else
    id = next_element_id(session[:categories])
    session[:categories] << { id: id, name: category, contacts: [] }
    session[:success] = "The new category has been created"
    redirect '/categories'
  end
end

# View a single category
get '/categories/:id' do
  @category_id = params[:id].to_i
  @category = load_category(@category_id)

  erb :category
end

# Delete a category
post '/categories/:id/delete' do
  @category_id = params[:id].to_i
  @category = load_category(@category_id)
  session[:categories].delete(@category)

  redirect '/categories'
end

# Render the edit category form
get '/categories/:id/edit' do
  @category_id = params[:id].to_i
  @category = load_category(@category_id)

  erb :edit_category
end

# Update a category name
post '/categories/:id/edit' do
  @category_id = params[:id].to_i
  @category = load_category(@category_id)
  category = params[:category].strip

  error = error_for_category_name(category)

  if error
    session[:error] = error
    erb :edit_category
  else
    @category[:name] = category
    session[:success] = 'The category has been updated.'
    redirect "/categories/#{@category_id}"
  end
end

# Render the new contact form
get "/categories/:category_id/contacts/new" do
  @category_id = params[:category_id].to_i
  @category = load_category(@category_id)

  erb :new_contact
end

# Create a new contact
post '/categories/:category_id/contacts/new' do
  contact_firstname = params[:contact_firstname].strip
  contact_lastname = params[:contact_lastname].strip
  contact_phone = params[:contact_phone].strip
  contact_email = params[:contact_email].strip

  @category_id = params[:category_id].to_i
  @category = load_category(@category_id)
  error = error_for_contact_details({ firstname: contact_firstname, lastname: contact_lastname, phone: contact_phone, email: contact_email })

  if error
    session[:error] = error
    erb :new_contact
  else
    @category[:contacts] << { firstname: contact_firstname, lastname: contact_lastname, phone: contact_phone, email: contact_email }
    session[:success] = 'The new contact has been created.'
    redirect "/categories/#{@category_id}"
  end
end

# Delete a single contact
post '/categories/:category_id/contacts/:idx/delete' do
  @category_id = params[:category_id].to_i
  @category = load_category(@category_id)
  index = params[:idx].to_i

  @category[:contacts].delete_at(index)

  session[:success] = 'The contact has been deleted.'
  redirect "/categories/#{@category_id}"
end


# Render the edit contact form
get '/categories/:category_id/contacts/:idx/edit' do
  @category_id = params[:category_id].to_i
  @category = load_category(@category_id)
  index = params[:idx].to_i
  @contact = @category[:contacts][index]

  erb :edit_contact
end

# Update contact details
post '/categories/:category_id/contacts/:idx/edit' do
  @category_id = params[:category_id].to_i
  @category = load_category(@category_id)
  index = params[:idx].to_i
  @contact = @category[:contacts][index]

  contact_firstname = params[:contact_firstname].strip
  contact_lastname = params[:contact_lastname].strip
  contact_phone = params[:contact_phone].strip
  contact_email = params[:contact_email].strip

  error = error_for_contact_details({ firstname: contact_firstname, lastname: contact_lastname, phone: contact_phone, email: contact_email })

  if error
    session[:error] = error
    erb :new_contact
  else
    @contact[:firstname] = contact_firstname
    @contact[:lastname] = contact_lastname
    @contact[:phone] = contact_phone
    @contact[:email] = contact_email

    session[:success] = 'The contact has been updated.'
    redirect "/categories/#{@category_id}"
  end
end

# List all the contacts
get '/contacts' do
  @categories = session[:categories]
  erb :contacts
end
