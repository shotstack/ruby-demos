require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

api_client = Shotstack::EditApi.new

video_asset = Shotstack::VideoAsset.new(
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/footage/skater.hd.mp4"
)

rotate = Shotstack::RotateTransformation.new(
  angle: 45
)

skew = Shotstack::SkewTransformation.new(
  x: 0.25,
  y: 0.1
)

flip = Shotstack::FlipTransformation.new(
  horizontal: true,
  vertical: true
)

transformation = Shotstack::Transformation.new(
  rotate: rotate,
  skew: skew,
  flip: flip
)

video_clip = Shotstack::Clip.new(
  asset: video_asset,
  start: 0,
  length: 8,
  scale: 0.6,
  transform: transformation)

track = Shotstack::Track.new(clips: [video_clip])

timeline = Shotstack::Timeline.new(
  background: "#000000",
  tracks: [track])

output = Shotstack::Output.new(
  format: "mp4",
  resolution: "sd")

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
