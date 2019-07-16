class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::ConfigFile

  configure :development do
    register Sinatra::Reloader
  end

  set :bind, '0.0.0.0'

  set :environments, %w[development test production default]

  set :root, File.expand_path('../../../', __FILE__)

  set :public_folder, File.join(settings.root, 'public')

  set :views, File.join(settings.root, 'app/views')

  config_file File.join(settings.root, 'config/config.yml.erb')

  helpers Sinatra::Cookies

  before do
    Time.zone = 'Asia/Hong_Kong'.freeze
  end
end