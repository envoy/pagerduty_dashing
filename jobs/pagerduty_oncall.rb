require 'faraday'
require 'json'

url = ENV['PAGERDUTY_URL']
api_key = ENV['PAGERDUTY_APIKEY']
env_schedules = ENV['PAGERDUTY_SCHEDULES']
parsed_data = JSON.parse(env_schedules)

schedules = {}

parsed_data['schedules'].each do |key, value|
  schedules[key] = value
end

SCHEDULER.every '30s' do
  schedules.each do |key, value|
    conn = Faraday.new(url: "#{url}") do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-type'] = 'application/json'
      faraday.headers['Authorization'] = "Token token=#{api_key}"
      faraday.headers['Accept'] = 'application/vnd.pagerduty+json;version=2'
      faraday.params['since'] = Time.now.utc.iso8601
      faraday.params['until'] = (Time.now.utc + 60).iso8601
    end

    oncalls = conn.get '/oncalls', {'schedule_ids' => [value] }
    oncalls_hash = JSON.parse(oncalls.body)

    user_name = oncalls_hash['oncalls'][0]['user']['summary']

    send_event("#{key}-name", text: user_name)
  end
end
