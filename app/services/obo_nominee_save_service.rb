# frozen_string_literal: true

require 'json'

class OboNomineeSaveService < ApplicationService
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
    URI.parse(ENV['OBO_NOMINEE_CREATION_URL'])
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
      "processRefNo": data[:processRefNumber],
      "isMinor": is_minor?(account_data[:nominees_detail].first[:date_of_birth]) ? "Y" : "N",
      "relationType": account_data[:nominees_detail].first[:relationship],
      "dateOfBirth": account_data[:nominees_detail].first[:date_of_birth],
      "percentage": account_data[:nominees_detail].first[:share_percentage],
      "title": "Mr",
      "firstName": split_name(account_data[:nominees_detail].first[:name])[:first_name]&.upcase,
      "middleName": split_name(account_data[:nominees_detail].first[:name])[:middle_name]&.upcase,
      "lastName": split_name(account_data[:nominees_detail].first[:name])[:last_name]&.upcase,
      "gender": "M",
      "citizenshipId": account_data[:nominees_detail].first[:cid_number]
    }.as_json
  end
end
