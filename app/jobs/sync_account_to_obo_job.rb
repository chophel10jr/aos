# frozen_string_literal: true

require 'base64'

class SyncAccountToOboJob < ApplicationJob
  queue_as :default

  def perform(account_id)
    account = Account.find(account_id)
    acc_data = account_data(account)

    first_response = OboAppInitiationService.new.run
    unless handle_response(first_response, account, "OBO Application Initiation Failed")
      return
    end

    first_response_body = parse_response_body(first_response)
    second_response = OboCustomerSaveService.new(
      first_response: first_response_body,
      account_data: acc_data
      ).run
    unless handle_response(second_response, account, "OBO Customer Save Failed")
      return
    end

    second_response_body = parse_response_body(second_response)
    a_response = OboNomineeSaveService.new(
      first_response: first_response_body,
      account_data: acc_data
    ).run
    unless handle_response(a_response, account, "OBO Nominees Save Failed")
      return
    end

    b_response = OboSpouseSaveService.new(
      first_response: first_response_body,
      account_data: acc_data
    ).run
    unless handle_response(b_response, account, "OBO Spouse Save Failed")
      return
    end

    third_response = OboApplicationSaveService.new(
      first_response: first_response_body,
      second_response: second_response_body,
      account_data: acc_data
    ).run
    unless handle_response(third_response, account, "OBO Application Save Failed")
      return
    end

    third_response_body = parse_response_body(third_response)
    final_response = OboSubmitService.new(
      first_response: first_response_body,
      second_response: second_response_body,
      third_response: third_response_body,
      account_data: acc_data
    ).run

    if final_response.status.success?
      update_account_sync_status(account, true, first_response_body['messages']['keyId'])
    else
      handle_response(final_response, account, "OBO Submit Failed")
    end
  end

  private

  def handle_response(response, account, error_message)
    if response.status.success?
      true
    else
      Rails.logger.error("#{error_message}: #{response.inspect}")
      update_account_sync_status(account, false, "")
      false
    end
  end

  def parse_response_body(response)
    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse response body: #{e.message}")
    {}
  end

  def update_account_sync_status(account, status, application_number)
    account.update(sync_with_obo: status, obo_application_no: application_number)
    if status
      Rails.logger.info("Account ID #{account.id} successfully synced with OBO.")
    else
      Rails.logger.error("Account ID #{account.id} failed to sync with OBO.")
    end
  end

  def account_data(account)
    {
      'account': {
        'currency': account.currency,
        'mode_of_operation': account.mode_of_operation
      },
      'personal_detail': {
        'salutation': personal_detail(account).salutation,
        'gender': personal_detail(account).gender,
        'first_name': personal_detail(account).first_name,
        'middle_name': personal_detail(account).middle_name,
        'last_name': personal_detail(account).last_name,
        'date_of_birth': personal_detail(account).date_of_birth,
        'nationality': personal_detail(account).nationality,
        'education_level': personal_detail(account).education_level,
        'tax_payer_no': personal_detail(account).tax_payer_no,
        'passport_photo': account_documents(account, 'passport_photo'),
        'signature': account_documents(account, 'signature')
      },
      'identity_detail': {
        'id_number': identity_detail(account).id_number,
        'id_issued_on': identity_detail(account).id_issued_on,
        'id_expires_on': identity_detail(account).id_expires_on
      },
      'permanent_address': {
        'house_number': permanent_address(account).house_number,
        'land_record_number': permanent_address(account).land_record_number,
        'village': permanent_address(account).village,
        'sub_district': permanent_address(account).sub_district,
        'block': permanent_address(account).block,
        'district': permanent_address(account).district
      },
      'current_address': {
        'house_number': current_address(account).house_number,
        'land_record_number': current_address(account).land_record_number,
        'village': current_address(account).village,
        'sub_district': current_address(account).sub_district,
        'block': current_address(account).block,
        'district': current_address(account).district
      },
      'spouse_detail': {
        'marital_status': account.personal_detail.marital_status,
        'name': spouse_detail(account)&.name,
        'cid_number': spouse_detail(account)&.cid_number,
        'date_of_birth': spouse_detail(account)&.date_of_birth,
        'contact_number': spouse_detail(account)&.contact_number,
        'education_level': spouse_detail(account)&.education_level,
        'employment_status': spouse_detail(account)&.employment_status,
        'account_number': spouse_detail(account)&.account_number,
        'number_of_children': spouse_detail(account)&.number_of_children
      },
      'income_detail': {
        'source_of_income': income_detail(account).source_of_income,
        'gross_annual_income': income_detail(account).gross_annual_income
      },
      'nominees_detail': nominees_detail(account).map do |nominee|
        {
          'name': nominee.name,
          'date_of_birth': nominee.date_of_birth,
          'relationship': nominee.relationship,
          'cid_number': nominee.cid_number,
          'contact_number': nominee.contact_number,
          'share_percentage': nominee.share_percentage
        }
      end,
      'employment_detail': {
        'employment_status': account.personal_detail.employment_status,
        'employee_id': employment_detail(account)&.employee_id,
        'organization_name': employment_detail(account)&.organization_name,
        'organization_address': employment_detail(account)&.organization_address,
        'designation': employment_detail(account)&.designation,
        'employment_type': employment_detail(account)&.employment_type,
        'employee_type': employment_detail(account)&.employee_type
      },
      'contact_detail': {
        'contact_number': contact_detail(account).contact_number,
        'email_id': contact_detail(account).email_id
      }
    }
  end

  def identity_detail(account)
    account.identity_details.where(id_type: "cid").first
  end

  def personal_detail(account)
    account.personal_detail
  end

  def permanent_address(account)
    account.addresses.where(address_type: 'permanent').first
  end

  def current_address(account)
    account.addresses.where(address_type: 'current').first
  end

  def spouse_detail(account)
    account.personal_detail.spouse_detail
  end

  def income_detail(account)
    account.income_detail
  end

  def nominees_detail(account)
    account.nominees
  end

  def employment_detail(account)
    account.personal_detail.employment_detail
  end

  def contact_detail(account)
    account.contact_detail
  end

  def faciility_detail(account)
    account.facilities
  end

  def account_documents(account, document_type)
    account.account_documents.where(document_type: document_type)&.first&.base64_data
  end

  def convert_attachment_to_base64(attachment)
    return nil unless attachment.attached?

    binary_data = attachment.download

    Base64.strict_encode64(binary_data)
  end
end
