require "shotstack"

Shotstack.configure do |config|
  config.api_key['x-api-key'] = ENV["SHOTSTACK_KEY"]
  config.host = "api.shotstack.io"
  config.base_path = ENV["SHOTSTACK_BASE_PATH"] || "stage"
end

if ARGV[0].nil?
  abort ">> Please provide the UUID of the template (i.e. node examples/templates/render.rb 7feabb0e-b5eb-8c5e-847d-82297dd4802a)"
end

id = ARGV[0]
api_client = Shotstack::EditApi.new

merge_field_url = Shotstack::MergeField.new(
  find: "URL",
  replace: "https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/footage/skater.hd.mp4"
)

merge_field_trim = Shotstack::MergeField.new(
  find: "TRIM",
  replace: 3
)

merge_field_length = Shotstack::MergeField.new(
  find: "LENGTH",
  replace: 6
)

template = Shotstack::TemplateRender.new(
  id: id,
  merge: [
    merge_field_url,
    merge_field_trim,
    merge_field_length
  ]
)

begin
  response = api_client.post_template_render(template).response
rescue => error
  abort("Request failed: #{error.message}")
end

puts response.message
puts ">> Now check the progress of your render by running:"
puts ">> ruby examples/status.rb #{response.id}"
