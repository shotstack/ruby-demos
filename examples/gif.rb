require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

images = [
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-712850.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-867452.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-752036.jpeg"
]

api_client = Shotstack::EditApi.new

clips = []
start = 0
length = 1.5

images.each_with_index do |image, index|
  image_asset = Shotstack::ImageAsset.new(
      src: image)

  clip = Shotstack::Clip.new(
    asset: image_asset,
    length: length,
    start: start,
    effect: "zoomIn")

  start += length
  clips.push(clip)
end

track1 = Shotstack::Track.new(clips: clips)

timeline = Shotstack::Timeline.new(
  background: "#000000",
  tracks: [track1])

output = Shotstack::Output.new(
  format: "gif",
  resolution: "preview",
  fps: 12,
  repeat: false)

edit = Shotstack::Edit.new(
  timeline: timeline,
  output: output)

begin
  response = api_client.post_render(edit).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts response.message
puts ">> Now check the progress of your render by running:"
puts ">> ruby examples/status.rb #{response.id}"
