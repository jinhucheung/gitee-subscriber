require './app'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser

map('/') { run HomeController }
map('/logs') { run LogsController }