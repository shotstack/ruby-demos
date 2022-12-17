require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

api_client = Shotstack::EditApi.new

video_asset = Shotstack::VideoAsset.new(
  src: "{{URL}}",
  trim: "{{TRIM}}"
)

video_clip = Shotstack::Clip.new(
  asset: video_asset,
  start: 0,
  length: "{{LENGTH}}"
)

track = Shotstack::Track.new(clips: [video_clip])

timeline = Shotstack::Timeline.new(
  background: "#000000",
  tracks: [track]
)

output = Shotstack::Output.new(
  format: "mp4",
  resolution: "sd"
)

edit = Shotstack::Edit.new(
  timeline: timeline,
  output: output
)

template = Shotstack::Template.new(
  name: "Trim Template",
  template: edit
)

begin
  response = api_client.post_template(template).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts response.message
puts ">> Now render the template using the id:"
puts ">> ruby examples/templates/render.rb #{response.id}"
