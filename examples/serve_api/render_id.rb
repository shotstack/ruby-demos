require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_SERVE_BASE_PATH"] || "serve/stage"
end

if ARGV[0].nil?
  abort ">> Please provide the UUID of the render task (i.e. ruby examples/serve-api/render_id.rb 2abd5c11-0f3d-4c6d-ba20-235fc9b8e8b7)"
end

id = ARGV[0]
api_client = Shotstack::ServeApi.new

begin
  data = api_client.get_asset_by_render_id(id).data
rescue => error
  abort("Request failed: #{error.message}")
end

data.each do |asset|
  case asset.attributes.status
  when "failed"
    puts ">> Something went wrong, asset could not be copied."
  else
    puts "Status: #{asset.attributes.status}"
    puts ">> Asset CDN URL: #{asset.attributes.url}"
    puts ">> Asset ID: #{asset.attributes.id}"
    puts ">> Render ID: #{asset.attributes.render_id}"
  end
end
