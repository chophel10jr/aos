# frozen_string_literal: true

class GetProofUrlService < ApplicationService
  attr_accessor :body

  def run
    response = send_post_request(url, body, headers)
  end

  private

  def url
    URI.parse(ENV['NDI_NEXUS_CREATE_PROOF_REQUEST_URL'])
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'X-API-KEY' => ENV['NDI_NEXUS_X_API_KEY']
    }
  end
end
