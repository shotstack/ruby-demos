require "shotstack"

configuration = Shotstack::Configuration.new do |config|
  config.api_key = {"x-api-key" => ENV["SHOTSTACK_KEY"] }
  config.host = "api.shotstack.io"
  config.base_path = "stage"

  config
end

images = [
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-712850.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-867452.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-752036.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-572487.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-114977.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-347143.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-206290.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-940301.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-266583.jpeg",
  "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-539432.jpeg"
]

api_client = Shotstack::ApiClient.new(configuration)

soundtrack = Shotstack::Soundtrack.new(
  effect: "fadeInOut",
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/gangsta.mp3")

clips = []
start = 0
length = 1.5

options = Shotstack::ImageClipOptions.new(
    effect: "zoomIn")

images.each_with_index do |image, index|
  clip = Shotstack::ImageClip.new(
    type: "image",
    src: image,
    in: 0,
    out: length,
    start: start,
    options: options)

  start += length
  clips.push(clip)
end

track1 = Shotstack::Track.new(clips: clips)

timeline = Shotstack::Timeline.new(
  background: "#000000",
  soundtrack: soundtrack,
  tracks: [track1])

output = Shotstack::Output.new(
  format: "mp4",
  resolution: "sd")

edit = Shotstack::Edit.new(
  timeline: timeline,
  output: output)

render = Shotstack::RenderApi.new(api_client)

begin
  response = render.post_render(edit).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts response.message
puts ">> Now check the progress of your render by running:"
puts ">> ruby examples/status.rb #{response.id}"
