require 'active_record'
require 'sidekiq-scheduler'
require_relative '../workers/keys_worker'

class HighloadWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'keys'

  def perform
    KeysWorker.perform_async if Key.where(status: true).count < 20
  end
end
