# frozen_string_literal: true

require 'json'

class OboSpouseSaveService < ApplicationService
  include OboHelper
  attr_accessor :account_data, :first_response

  def run
    send_post_request(url, body, headers)
  rescue StandardError => e
    Rails.logger.error("Error: #{e.message}")
  end

  private

  def data
    {
      'action': 'save',
      'applicationNumber': first_response['messages']['keyId'],
      'processRefNumber': first_response['data']['products'].first['processRefNumber'],
    }
  end

  def url
    URI.parse(ENV['OBO_SPOUSE_CREATION_URL'])
  end

  def headers
    {
      'APPID': 'OBXV001',
      'AUTHTOKEN': 'Y',
      'BRANCHCODE': '999',
      'CONTENT-TYPE': 'application/json',
      'entityId': 'DEFAULTENTITY',
      'USERID': 'PHUNTSHOLOB'
    }.as_json
  end

  def body
    {
      "applicationNumber": data[:applicationNumber],
      "processRefNumber": data[:processRefNumber],
      "spousedetailsList": [
        {
          "serialNo": "0",
          "spouseName": account_data[:spouse_detail][:name]&.upcase,
          "spouseCID": account_data[:spouse_detail][:cid_number],
          "spousePhoneNo": account_data[:spouse_detail][:contact_number],
          "spouseEmployment": "T",
          "applicationNumber": data[:applicationNumber],
          "processRefNumber": data[:processRefNumber],
          "tpnNumber": "NOTREGIS",
          "uniqueId": "sdfsdgdsfgfdsgsdgg1990-12-17"
        }
      ]
    }.as_json
  end
end
