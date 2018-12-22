require "shotstack"

configuration = Shotstack::Configuration.new do |config|
  config.api_key = {"x-api-key" => ENV["SHOTSTACK_KEY"] }
  config.host = "api.shotstack.io"
  config.base_path = "stage"

  config
end

filters = [
  "original",
  "boost",
  "contrast",
  "muted",
  "darken",
  "lighten",
  "greyscale",
  "negative"
]

api_client = Shotstack::ApiClient.new(configuration)

soundtrack = Shotstack::Soundtrack.new(
  effect: "fadeInOut",
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/freeflow.mp3")

video_clips = []
title_clips = []
start = 0
length = 4
cut_in = 0
cut_out = length

transition = Shotstack::Transition.new(
  in: "fade",
  out: "fade")

filters.each_with_index do |filter, index|
  video_options = Shotstack::VideoClipOptions.new

  if filter != "original"
    video_options.filter = filter
  end

  # video clips
  video_clip = Shotstack::VideoClip.new(
    type: "video",
    src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/footage/cat.mp4",
    in: cut_in,
    out: cut_out,
    start: start,
    transition: transition,
    options: video_options)

  video_clips.push(video_clip)

  # title clips
  title_options = Shotstack::TitleClipOptions.new(
    style: "minimal")

  title_clip = Shotstack::TitleClip.new(
    type: "title",
    src: filter,
    in: 0,
    out: length,
    start: start,
    transition: transition,
    options: title_options)

  title_clips.push(title_clip)

  cut_in += 2
  cut_out = cut_in + length
  start += length
end

track1 = Shotstack::Track.new(clips: title_clips)
track2 = Shotstack::Track.new(clips: video_clips)

timeline = Shotstack::Timeline.new(
  background: "#000000",
  soundtrack: soundtrack,
  tracks: [track1, track2])

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
