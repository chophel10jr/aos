# frozen_string_literal: true

require 'json'

class OboAppInitiationService < ApplicationService
  def run
    send_post_request(url, body, headers)
  rescue StandardError => e
    Rails.logger.error("Error: #{e.message}")
  end

  private

  def url
    URI.parse(ENV['OBO_APPLICATION_INITIATION_URL'])
  end

  def headers
    {
      'APPID': 'RPMPROCESSDRIVER',
      'AUTHTOKEN': 'Y',
      'BRANCHCODE': '999',
      'CONTENT-TYPE': 'application/json',
      'entityId': 'DEFAULTENTITY',
      'USERID': 'PHUNTSHOLOB'
    }.as_json
  end

  def body
    {
      "channel": "OBDX",
      "fullInitiation": false,
      "products": [
        {
          "businessProductCode": "SANATL",
          "lifeCycleCode": "SavOrig",
          "productType": "S",
          "subProductType": "R"
        }
      ]
    }.as_json
  end
end
