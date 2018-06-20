require 'dashing'

configure do
  set :auth_token, '74962f5f2d1e0bc8fc633ee0f927bff267417073336bf19214fc3e3260861005e6d78abc6882311c80200f092bd356bb9e96ce7e72ba015af085a69cd0488000'

  set :protection, :except => :frame_options

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
