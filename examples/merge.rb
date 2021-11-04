require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

api_client = Shotstack::EditApi.new

soundtrack = Shotstack::Soundtrack.new(
  effect: "fadeInFadeOut",
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/disco.mp3")

title_asset = Shotstack::TitleAsset.new(
  style: "minimal",
  text: "Hello {{NAME}}")

title_clip = Shotstack::Clip.new(
    asset: title_asset,
    length: 5,
    start: 0,
    effect: "zoomIn")

track1 = Shotstack::Track.new(clips: [title_clip])

timeline = Shotstack::Timeline.new(
  background: "#000000",
  soundtrack: soundtrack,
  tracks: [track1])

output = Shotstack::Output.new(
  format: "mp4",
  resolution: "sd")

mergeField = Shotstack::MergeField.new(
  find: "NAME",
  replace: "Jane")

edit = Shotstack::Edit.new(
  timeline: timeline,
  output: output,
  merge: [mergeField])

begin
  response = api_client.post_render(edit).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts response.message
puts ">> Now check the progress of your render by running:"
puts ">> ruby examples/status.rb #{response.id}"
