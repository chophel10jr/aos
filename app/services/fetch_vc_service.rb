# frozen_string_literal: true

class FetchVcService < ApplicationService
  require 'net/http'
  require 'uri'

  attr_accessor :token

  def run
    external_url = URI("https://ndi-nexus.bnb.bt/verifiable_credentials/fetch?token=#{token}")
    response = Net::HTTP.get_response(external_url)
  end
end
