ENV["RACK-ENV"] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../contacts'

class ContactsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # def setup
  #   FileUtils.mkdir_p(data_path)
  # end
  #
  # def teardown
  #   FileUtils.rm_rf(data_path)
  # end

  def test_home_page
    get '/'

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response['Content-Type']
    assert_includes last_response.body, "Hello World!"
  end

  def test_contacts_main_page
    skip
    get '/contacts'

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response['Content-Type']
    # assert_includes last_response.body, "Hello World!"
  end

  def test_parents_page
    skip
    get '/contacts/parents'

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response['Content-Type']
    # assert_includes last_response.body, "Hello World!"
  end








end
