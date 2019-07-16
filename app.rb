require 'sinatra'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/cookies'
require 'sinatra/config_file'
require 'sinatra/activerecord'
require 'commonmarker'
require 'nokogiri'

if development?
  require 'sinatra/reloader'
  require 'byebug'
end

Dir[File.expand_path('../app/controllers/**/*.rb', __FILE__)].sort.each { |file| require file }
Dir[File.expand_path('../app/models/**/*.rb', __FILE__)].sort.each { |file| require file }