# frozen_string_literal: true

require 'json'

class OboCustomerSaveService < ApplicationService
  include OboHelper
  attr_accessor :first_response, :account_data

  def run
    send_post_request(url, body, headers)
  rescue StandardError => e
    Rails.logger.error("Error: #{e.message}")
  end

  private

  def url
    URI.parse(ENV['OBO_ACCOUNT_CREATION_URL'])
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

  def data
    {
      'action': 'save',
      'applicationNumber': first_response['messages']['keyId'],
      'processRefNumber': first_response['data']['products'].first['processRefNumber'],
    }
  end

  def body
    {
      "applicationNumber": data[:applicationNumber],
      "channel": "OBDX",
      "action": data[:action],
      "appPriority": nil,
      "domainData": {
        "CurrentAccOpenProcess": [],
        "CmnApplicant": [
          {
            "applicantDetailsMasterModel": {
              "id": data[:applicantDetailsMasterId],
              "applicationNumber": data[:applicationNumber],
              "remarks": nil,
              "dataSegmentCode": nil,
              "updatedBy": "PHUNTSHOLOB",
              "updatedTimeStamp": "2024-05-26T11:58:49+06:00",
              "stageCode": "RPM_INITIATION",
              "createdBy": "PHUNTSHOLOB",
              "version": "1",
              "createdTimestamp": nil,
              "recordStat": "W",
              "status": "COMPLETE",
              "processRefNo": data[:processRefNumber],
              "channel": "OBDX",
              "action": data[:action],
              "applicationDate": "2024-05-26",
              "ownership": "SINGLE",
              "customerType": "IND",
              "numberOfApplicants": 1,
              "stageChanged": false,
              "applicantDetailsModel": [
                {
                  "id": data[:applicantDetailsId],
                  "applicantDetailsMasterId": data[:applicantDetailsMasterId],
                  "processRefNo": data[:processRefNumber],
                  "applicationNumber": data[:applicationNumber],
                  "applicantId": data[:applicantId],
                  "serialNo": 0,
                  "location": "000",
                  "existingCustomer": false,
                  "kycStatus": nil,
                  "kycModel": nil,
                  "applicantRole": "PRIMARY",
                  "incomeReliant": true,
                  "primaryApplicant": true,
                  "cifNumber": nil,
                  "partyHandofftoHostStatus": nil,
                  "partyId": nil,
                  "lastUpdatedOn": nil,
                  "basicInfoAmend": false,
                  "contactAmend": false,
                  "kycAmend": false,
                  "customerType": "IND",
                  "language": "ENG",
                  "currency": "BTN",
                  "languageName": "English",
                  "currencyName": "NGULTRUM",
                  "shortName": nil,
                  "customerSubtype": "001",
                  "individualDetailsModel": {
                    "id": data[:individualDetailsId],
                    "applicantDetailsId": data[:applicantDetailsId],
                    "customerImage": account_data[:personal_detail][:passport_photo],
                    "titleDesc": account_data[:personal_detail][:salutation],
                    "genderDesc": account_data[:personal_detail][:gender].capitalize,
                    "residentStatusDesc": "Resident",
                    "citizenshipDesc": "Birth",
                    "maritalStatusDesc": account_data[:spouse_detail][:marital_status].capitalize,
                    "customerSegmentDesc": nil,
                    "uniqueIdTypeDesc": nil,
                    "countryResidenceDesc": nil,
                    "birthCountryDesc": "BHUTAN",
                    "nationalityDesc": "BHUTAN",
                    "title": account_data[:personal_detail][:salutation],
                    "firstName": account_data[:personal_detail][:first_name]&.upcase,
                    "middleName": account_data[:personal_detail][:middle_name]&.upcase,
                    "lastName": account_data[:personal_detail][:last_name]&.upcase,
                    "dateOfBirth": account_data[:personal_detail][:date_of_birth],
                    "age": calculate_age(account_data[:personal_detail][:date_of_birth]),
                    "gender": account_data[:personal_detail][:gender].first.upcase,
                    "residentStatus": "R",
                    "countryOfResidence": nil,
                    "citizenship": "BIR",
                    "birthPlace": nil,
                    "birthCountry": "000",
                    "maritalStatus": marital_code(account_data[:spouse_detail][:marital_status].downcase),
                    "nationality": "000",
                    "customerSegment": nil,
                    "uniqueIdType": nil,
                    "uniqueIdNo": nil,
                    "uniqueIdExpiryDate": nil,
                    "pep": false,
                    "insider": false,
                    "minor": false,
                    "role": nil,
                    "detailsOfSpecialNeed": nil,
                    "nameInLocalLanguage": nil,
                    "remarksForSpecialNeed": nil,
                    "rmId": nil,
                    "staff": nil,
                    "profession": nil
                  },
                  "smbDetailsModel": nil,
                  "address": [
                    {
                      "id": data[:applicantCommunicationAddressId],
                      "applicantDetailsId": data[:applicantDetailsId],
                      "processRefNo": data[:processRefNumber],
                      "authorizedSignatoryId": nil,
                      "serialNo": nil,
                      "preferredMailAddress": true,
                      "streetName": account_data[:current_address][:district]&.upcase,
                      "localityName": account_data[:current_address][:district]&.upcase,
                      "landmark": nil,
                      "buildingName": account_data[:current_address][:district]&.upcase,
                      "areaDetails": nil,
                      "periodOfStay": nil,
                      "addressType": "C",
                      "addressTypeDesc": "Communication Address",
                      "livingSince": nil,
                      "countryName": "BHUTAN",
                      "country": "000",
                      "state": account_data[:current_address][:village]&.upcase,
                      "city": account_data[:current_address][:sub_district]&.upcase,
                      "pinCode": nil,
                      "email": account_data[:contact_detail][:email_id],
                      "mobileNo": "975#{account_data[:contact_detail][:contact_number]}",
                      "mobileIsd": nil,
                      "phoneNo": nil,
                      "phoneIsd": nil,
                      "location": "000",
                      "department": nil,
                      "subDepartment": nil,
                      "buildingNumber": nil,
                      "floor": nil,
                      "postBox": nil,
                      "room": nil,
                      "districtName": nil,
                      "fromDate": nil,
                      "toDate": nil,
                      "narrative": nil,
                      "addressSearch": nil,
                      "contactDetails": [
                        {
                          "id": data[:applicantCommunicationAddressEmlId],
                          "applicantAddressId": data[:applicantCommunicationAddressId],
                          "mediaType": "EML",
                          "line1": account_data[:contact_detail][:email_id],
                          "line2": nil,
                          "line3": nil,
                          "line4": nil,
                          "line5": nil,
                          "line6": nil,
                          "line7": nil,
                          "preferred": "true"
                        },
                        {
                          "id": data[:applicantCommunicationAddressMblId],
                          "applicantAddressId": data[:applicantCommunicationAddressId],
                          "mediaType": "MBL",
                          "line1": nil,
                          "line2": "975#{account_data[:contact_detail][:contact_number]}",
                          "line3": nil,
                          "line4": nil,
                          "line5": nil,
                          "line6": nil,
                          "line7": nil,
                          "preferred": "true"
                        }
                      ]
                    },
                    {
                      "id": data[:applicantPermanentAddressId],
                      "applicantDetailsId": data[:applicantDetailsId],
                      "processRefNo": data[:processRefNumber],
                      "authorizedSignatoryId": nil,
                      "serialNo": nil,
                      "preferredMailAddress": true,
                      "streetName": account_data[:permanent_address][:district]&.upcase,
                      "localityName": account_data[:permanent_address][:district]&.upcase,
                      "landmark": nil,
                      "buildingName": account_data[:permanent_address][:district]&.upcase,
                      "areaDetails": nil,
                      "periodOfStay": nil,
                      "addressType": "P",
                      "addressTypeDesc": "Permanent Address",
                      "livingSince": nil,
                      "countryName": "BHUTAN",
                      "country": "000",
                      "state": account_data[:permanent_address][:village]&.upcase,
                      "city": account_data[:permanent_address][:sub_district]&.upcase,
                      "pinCode": nil,
                      "email": account_data[:contact_detail][:email_id],
                      "mobileNo": "975#{account_data[:contact_detail][:contact_number]}",
                      "mobileIsd": nil,
                      "phoneNo": nil,
                      "phoneIsd": nil,
                      "location": "000",
                      "department": account_data[:permanent_address][:house_number]&.upcase,
                      "subDepartment": account_data[:permanent_address][:land_record_number]&.upcase,
                      "buildingNumber": nil,
                      "floor": nil,
                      "postBox": nil,
                      "room": nil,
                      "districtName": nil,
                      "fromDate": nil,
                      "toDate": nil,
                      "narrative": nil,
                      "addressSearch": nil,
                      "contactDetails": [
                        {
                          "id": data[:applicantPermanentAddressMblId],
                          "applicantAddressId": data[:applicantPermanentAddressId],
                          "mediaType": "MBL",
                          "line1": nil,
                          "line2": "975#{account_data[:contact_detail][:contact_number]}",
                          "line3": nil,
                          "line4": nil,
                          "line5": nil,
                          "line6": nil,
                          "line7": nil,
                          "preferred": "true"
                        },
                        {
                          "id": data[:applicantPermanentAddressEmlId],
                          "applicantAddressId": data[:applicantPermanentAddressId],
                          "mediaType": "EML",
                          "line1": account_data[:contact_detail][:email_id],
                          "line2": nil,
                          "line3": nil,
                          "line4": nil,
                          "line5": nil,
                          "line6": nil,
                          "line7": nil,
                          "preferred": "true"
                        }
                      ]
                    }
                  ],
                  "signature": [
                    {
                      "id": data[:applicantSignatureId],
                      "applicantDetailsId": data[:applicantDetailsId],
                      "processRefNo": data[:processRefNumber],
                      "serialNo": 1,
                      "isActive": true,
                      "isOnboarded": false,
                      "signatureImage": account_data[:personal_detail][:signature],
                      "signatureId": "1",
                      "signatureName": "SignatureDetails",
                      "partyId": nil,
                      "partyParentId": nil,
                      "remark": "Signature 1"
                    }
                  ],
                  "kycRequired": true,
                  "taxDeclaration": nil,
                  "identificationDetails": [
                    {
                      "id": data[:applicantIdentificationId],
                      "applicantDetailsId": data[:applicantDetailsId],
                      "idType": "CITIZENSHIP ID",
                      "idStatus": "AVL",
                      "uniqueId": account_data[:identity_detail][:id_number],
                      "placeOfIssue": "DCRC",
                      "issueDate": account_data[:identity_detail][:id_issued_on],
                      "expirationDate": account_data[:identity_detail][:id_expires_on],
                      "remarks": "Identity 1"
                    }
                  ],
                  "applicantSupportDocMasterModel": nil,
                  "serviceMemberDetails": nil
                }
              ],
              "residentStabilityYears": 0
            },
            "financialDetailsMasterModel": nil,
            "relationshipMasterModel": nil,
            "accountConsentMasterModel": nil,
            "partyConsentMasterModel": nil
            }
        ],
        "LoanAccOpenProcess": [],
        "SavingAccOpenProcess": [],
        "TDAccOpenProcess": [],
        "CollateralOrigProcess": [],
        "IpaProcess": [],
        "CCAccOpenProcess": []
    },
    "products": [
      {
        "lifeCycleCode": "SavOrig",
        "productType": "S",
        "businessProductCode": "SANATL",
        "subProductType": "R"
      }
    ],
    "remarks": nil
  }.as_json
  end
end
