require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

filters = [
  "original",
  "boost",
  "contrast",
  "muted",
  "darken",
  "lighten",
  "greyscale",
  "negative",
]

api_client = Shotstack::EditApi.new

soundtrack = Shotstack::Soundtrack.new(
  effect: "fadeInFadeOut",
  src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/freeflow.mp3")

video_clips = []
title_clips = []
start = 0
length = 3
trim = 0
cut = length

filters.each_with_index do |filter, index|
  # video clips
  video_asset = Shotstack::VideoAsset.new(
    src: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/footage/skater.hd.mp4",
    trim: trim
  )

  video_clip = Shotstack::Clip.new(
    asset: video_asset,
    start: start,
    length: length)

  if filter != "original"
    video_transition = Shotstack::Transition.new(
      _in: "wipeRight")

    video_clip.filter = filter
    video_clip.transition = video_transition
    video_clip.length = length + 1
  end

  video_clips.push(video_clip)

  # title clips
  title_transition = Shotstack::Transition.new(
      _in: "fade",
      out: "fade")

  title_asset = Shotstack::TitleAsset.new(
    text: filter,
    style: "minimal",
    size: "x-small")

  title_clip = Shotstack::Clip.new(
    asset: title_asset,
    length: length - (start == 0 ? 1 : 0),
    start: start,
    transition: title_transition)

  title_clips.push(title_clip)

  trim = cut - 1
  cut = trim + length + 1
  start = trim
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

begin
  response = api_client.post_render(edit).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts response.message
puts ">> Now check the progress of your render by running:"
puts ">> ruby examples/status.rb #{response.id}"
