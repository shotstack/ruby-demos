require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = "stage"
end

styles = [
  "minimal",
  "blockbuster",
  "vogue",
  "sketchy",
  "skinny",
]

api_client = Shotstack::DefaultApi.new

soundtrack = Shotstack::Soundtrack.new(
  effect: "fadeInOut",
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/dreams.mp3")

clips = []
start = 0
length = 4

styles.each_with_index do |style, index|
  title_asset = Shotstack::TitleAsset.new(
    style: style,
    text: style
    )

  transition = Shotstack::Transition.new(
    _in: "fade",
    out: "fade")

  clip = Shotstack::Clip.new(
    asset: title_asset,
    length: length,
    start: start,
    transition: transition,
    effect: "zoomIn")

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

begin
  response = api_client.post_render(edit).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts response.message
puts ">> Now check the progress of your render by running:"
puts ">> ruby examples/status.rb #{response.id}"
