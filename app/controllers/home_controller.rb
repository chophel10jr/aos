# frozen_string_literal: true

class HomeController < ApplicationController
  def show; end

  def open_account
    process_proof_request(open_account_attributes)
  end

  def track_application
    process_proof_request(track_application_attributes)
  end

  private

  def process_proof_request(attributes)
    response = GetProofUrlService.new(body: attributes).run

    unless response.status.success?
      flash[:alert] = "Connection error with NDI Server. Please try again later."
      return redirect_to root_path
    end

    parsed_body = parse_response(response.body)

    @svg_qr_code = GenerateQrService.new(code: parsed_body['proof_request_url']).run
    @deep_link_url = parsed_body['deep_link_url']
    @token = EncodeTokenService.new(thread_id: parsed_body['proof_request_threaded_id']).run
  end

  def parse_response(body)
    JSON.parse(body)
  rescue JSON::ParserError
    flash[:alert] = "Invalid response from server."
    redirect_to root_path
  end

  def open_account_attributes
    {
      "attributes": {
        "Foundational ID": [
          "Full Name",
          "Gender",
          "Date of Birth",
          "ID Type",
          "ID Number",
          "Citizenship"
        ],
        "Permanent Address": [
          "House Number",
          "Thram Number",
          "Village",
          "Gewog",
          "Dzongkhag"
        ],
        "Current Address": [
          "Street",
          "City",
          "State",
          "Country",
          "Postal Code"
        ],
        "Mobile Number": [
          "Mobile Number",
          "Type"
        ],
        "Email": [
          "Email"
        ],
        "Passport-Size Photo": [
          "Passport-Size Photo"
        ]
      }
    }
  end

  def track_application_attributes
    {
      "attributes": {
        "Foundational ID": [
          "Full Name",
          "ID Type",
          "ID Number"
        ]
      }
    }
  end 
end
