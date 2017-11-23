require_relative 'workers/email_worker'
require_relative 'workers/keys_worker'
require_relative 'workers/highload_worker'
require 'sidekiq-limit_fetch'
require 'active_record'
require 'redis'

redis_conn = proc {
  Redis.new
}

Sidekiq.configure_server do |config|
  config.redis = { size: 200, url: "redis://localhost:6379"}
end

Sidekiq.configure_client do |config|
  config.redis = { size: 200, url: "redis://localhost:6379"}
end
