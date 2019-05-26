require "shotstack"

OUTPUT_URL = "https://s3-ap-southeast-2.amazonaws.com/shotstack-api-stage-output/"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = "stage"
end

if ARGV[0].nil?
  abort ">> Please provide the UUID of the render task (i.e. ruby examples/status.rb 2abd5c11-0f3d-4c6d-ba20-235fc9b8e8b7)"
end

id = ARGV[0]
api_client = Shotstack::DefaultApi.new()

begin
  response = api_client.get_render(id).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts "Status: #{response.status.upcase}"

case response.status
when "done"
	puts ">> Video URL: #{OUTPUT_URL}#{response.owner}/#{response.id}.mp4"
when "failed"
	puts ">> Something went wrong, rendering has terminated and will not continue."
else
	puts ">> Rendering in progress, please try again shortly."
	puts ">> Note: Rendering may take up to 1 minute to complete."
end
