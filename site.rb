require "rubygems"
require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || :development)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class RingClub < Sinatra::Base
  register ScssInitializer
  use Rack::Deflater

  layout :main
  configure do
    RACK_ENV = (ENV['RACK_ENV'] || :development).to_sym
    connections = {
      :development => "postgres://localhost/ringclub",
      :test => "postgres://postgres@localhost/ringclub_test",
      :production => ENV['DATABASE_URL']
    }

    url = URI(connections[RACK_ENV])
    options = {
      :adapter => url.scheme,
      :host => url.host,
      :port => url.port,
      :database => url.path[1..-1],
      :username => url.user,
      :password => url.password
    }

    case url.scheme
    when "sqlite"
      options[:adapter] = "sqlite3"
      options[:database] = url.host + url.path
    when "postgres"
      options[:adapter] = "postgresql"
    end
    set :database, options

    use Rack::Session::Cookie, :key => 'rack.session',
      :path => '/',
      :expire_after => 86400, # 1 day
      :secret => ENV['SESSION_SECRET'] || '*&(^B234'
  end

  get "/" do
    erb :index
  end
end
