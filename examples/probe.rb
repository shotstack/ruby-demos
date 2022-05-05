require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

if ARGV[0].nil?
  abort ">> Please provide the URL to a media file to inspect (i.e. ruby examples/probe.rb https://github.com/shotstack/test-media/raw/main/captioning/scott-ko.mp4)"
end

url = ARGV[0]
api_client = Shotstack::EditApi.new

begin
  response = api_client.probe(url).response
rescue => error
  abort("Request failed: #{error.message}")
end

response[:metadata][:streams].each_with_index do |stream, index|
  if stream[:codec_type] === 'video'
    puts "Example settings for: #{response[:metadata][:format][:filename]}"
    puts "Width: #{stream[:width]}px"
    puts "Height: #{stream[:height]}px"
    puts "Framerate: #{stream[:r_frame_rate]} fps"
    puts "Duration: #{stream[:duration]} secs"
  end
end
