# frozen_string_literal: true

if ENV["AIRBRAKE_API_KEY"]
  require "airbrake"
  Airbrake.configure do |config|
    config.host = ENV["AIRBRAKE_HOST"] if ENV["AIRBRAKE_HOST"]
    config.project_id = ENV["AIRBRAKE_PROJECT_ID"]
    config.project_key = ENV["AIRBRAKE_API_KEY"]
  end

  use Airbrake::Rack::Middleware
  enable :raise_errors

  Airbrake.add_filter do |notice|
    # Bots gonna bot
    notice.ignore! if notice[:errors].any? { |e| e[:type] == "Sinatra::NotFound" } && (/\/wp-(?:admin|includes|content|login)/ =~ notice[:context][:url] || /\/facebook\/\d+\/?$/ =~ notice[:context][:url])
  end
end
