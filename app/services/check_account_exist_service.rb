# frozen_string_literal: true

class CheckAccountExistService < ApplicationService
  attr_accessor :cid

  def run
    response = HTTP.timeout(connect: 5, read: 5).get(ENV['CHECK_ACCOUNT_EXIST_URL'], params: { Account: cid })

    if response.status.success?
      JSON.parse(response.body)
    else
      Rails.logger.warn("API returned an unsuccessful status: #{response.status}")
      nil
    end
  rescue HTTP::TimeoutError, HTTP::ConnectionError => e
    Rails.logger.error("API request failed: #{e.message}")
    nil
  rescue StandardError => e
    Rails.logger.error("Unexpected error: #{e.message}")
    nil
  end
end
