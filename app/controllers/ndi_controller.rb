class NdiController < ApplicationController
  require 'net/http'
  require 'uri'

  def fetch_status
    token = params[:token]
    external_url = URI("https://ndi-nexus.bnb.bt/verifiable_credentials/fetch?token=#{token}")
    
    response = Net::HTTP.get_response(external_url)
    render json: response.body, status: response.code
  end
end
