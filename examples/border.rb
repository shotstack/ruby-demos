require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

api_client = Shotstack::EditApi.new

# Border - top layer (track1)
border_asset = Shotstack::ImageAsset.new(
  src: "https://shotstack-assets.s3.ap-southeast-2.amazonaws.com/borders/80s-acid-pink-square.png")

border_clip = Shotstack::Clip.new(
    asset: border_asset,
    start: 0,
    length: 1)

track1 = Shotstack::Track.new(clips: [border_clip])

# Background image - bottom layer (track2)
background_asset = Shotstack::ImageAsset.new(
  src: "https://shotstack-assets.s3.ap-southeast-2.amazonaws.com/images/dolphins.jpg")

background_clip = Shotstack::Clip.new(
    asset: background_asset,
    start: 0,
    length: 1)

track2 = Shotstack::Track.new(clips: [background_clip])

timeline = Shotstack::Timeline.new(
  background: "#000000",
  tracks: [track1, track2]) # Put track1 first to go above track2

output = Shotstack::Output.new(
  format: "jpg",
  quality: "high",
  size: Shotstack::Size.new(
    width: 1000,
    height: 1000
  ))

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
