require "shotstack"

configuration = Shotstack::Configuration.new do |config|
  config.api_key = {"x-api-key" => ENV["SHOTSTACK_KEY"] }
  config.host = "api.shotstack.io"
  config.base_path = "stage"

  config
end

api_client = Shotstack::ApiClient.new(configuration)

soundtrack = Shotstack::Soundtrack.new(
  effect: "fadeInOut",
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/disco.mp3")

titleOptions = Shotstack::TitleClipOptions.new(
  style: "minimal",
  effect: "zoomIn")

titleClip = Shotstack::TitleClip.new(
    type: "title",
    src: "Hello World",
    in: 0,
    out: 5,
    start: 0,
    options: titleOptions)

track1 = Shotstack::Track.new(clips: [titleClip])

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
