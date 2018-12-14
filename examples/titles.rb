require "shotstack"

configuration = Shotstack::Configuration.new do |config|
  config.api_key = {"x-api-key" => ENV["SHOTSTACK_KEY"] }
  config.host = "api.shotstack.io"
  config.base_path = "stage"

  config
end

styles = [
  "minimal",
  "blockbuster",
  "vogue",
  "sketchy",
  "skinny",
]

api_client = Shotstack::ApiClient.new(configuration)

soundtrack = Shotstack::Soundtrack.new(
  effect: "fadeInOut",
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/dreams.mp3")

clips = []
start = 0
length = 4

styles.each_with_index do |style, index|
  options = Shotstack::TitleClipOptions.new(
    style: style,
    effect: "zoomIn")

  transition = Shotstack::Transition.new(
    in: "wipeRight",
    out: "wipeRight")

  clip = Shotstack::TitleClip.new(
    type: "title",
    src: style,
    in: 0,
    out: length,
    start: start,
    transition: transition,
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
