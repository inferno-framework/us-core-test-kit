require 'inferno'
require_relative './monkey_patch/static_assets.rb'

use Rack::Static,
    urls: Inferno::Utils::StaticAssets.static_assets_map,
    root: Inferno::Utils::StaticAssets.inferno_path

puts "===== DEBUG =================="
puts Inferno::Utils::StaticAssets.static_assets_map
puts "===== DEBUG =================="

Inferno::Application.finalize!

use Inferno::Utils::Middleware::RequestLogger

run Inferno::Web.app
