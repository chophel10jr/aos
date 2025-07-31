# frozen_string_literal: true

require 'json'

class OboApplicationSaveService < ApplicationService
  include OboHelper
  attr_accessor :account_data, :first_response, :second_response

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
      'applicantDetailsMasterId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['id'],
      'applicantDetailsId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['id'],
      'applicantId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['applicantId'],
      'individualDetailsId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['individualDetailsModel']['id'],
      'applicantCommunicationAddressId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['address'].find { |address| address["addressType"] == "C" }['id'],
      'applicantPermanentAddressId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['address'].find { |address| address["addressType"] == "P" }['id'],
      'applicantCommunicationAddressEmlId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['address'].find { |address| address["addressType"] == "C" }['contactDetails'].find { |email| email['mediaType'] == 'EML'}['id'],
      'applicantCommunicationAddressMblId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['address'].find { |address| address["addressType"] == "C" }['contactDetails'].find { |email| email['mediaType'] == 'MBL'}['id'],
      'applicantPermanentAddressEmlId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['address'].find { |address| address["addressType"] == "P" }['contactDetails'].find { |email| email['mediaType'] == 'EML'}['id'],
      'applicantPermanentAddressMblId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['address'].find { |address| address["addressType"] == "P" }['contactDetails'].find { |email| email['mediaType'] == 'MBL'}['id'],
      'applicantSignatureId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['signature'].first['id'],
      'applicantIdentificationId': second_response['data']['domainData']['CmnApplicant'].first['applicantDetailsMasterModel']['applicantDetailsModel'].first['identificationDetails'].first['id'],
      'financialDetailsMasterId': second_response['data']['domainData']['CmnApplicant'].first['financialDetailsMasterModel']['id']
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
                      "processRefNo": nil,
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
                          "preferred": nil
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
                          "preferred": nil
                        }
                      ]
                    },
                    {
                      "id": data[:applicantPermanentAddressId],
                      "applicantDetailsId": data[:applicantDetailsId],
                      "processRefNo": nil,
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
                          "preferred": nil
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
                          "preferred": nil
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
            "financialDetailsMasterModel": {
              "id": nil,
              "applicationNumber": data[:applicationNumber],
              "remarks": nil,
              "dataSegmentCode": nil,
              "updatedBy": nil,
              "updatedTimeStamp": nil,
              "stageCode": "RPM_INITIATION",
              "createdBy": nil,
              "version": "1",
              "createdTimestamp": nil,
              "recordStat": "W",
              "status": "COMPLETE",
              "processRefNo": data[:processRefNumber],
              "loanCurrency": "BTN",
              "loanCurrencyDesc": "NGULTRUM",
              "accountType": nil,
              "applicationIncomeAmount": 0,
              "applicationExpenseAmount": 0,
              "applicationAssetAmount": 0,
              "applicationLiabilityAmount": 0,
              "applicationNetAmount": 0,
              "finDtvalPrd": "Months",
              "finPeriod": 12,
              "channel": "OBDX",
              "action": data[:action],
              "financialDetailsModel": [
                {
                  "id": nil,
                  "applicationNumber": data[:applicationNumber],
                  "financialMasterId": nil,
                  "existingCustomer": false,
                  "cifNumber": nil,
                  "applicantRole": "PRIMARY",
                  "customerType": "IND",
                  "onboarded": false,
                  "totalIncomeAmount": account_data[:income_detail][:gross_annual_income],
                  "totalIncomeCurrencyCode": "BTN",
                  "totalExpenseAmount": 0,
                  "totalExpenseCurrencyCode": "BTN",
                  "totalAssetAmount": 0,
                  "totalAssetCurrencyCode": "BTN",
                  "totalLiabilityAmount": 0,
                  "totalLiabilityCurrencyCode": "BTN",
                  "netAmount": account_data[:income_detail][:gross_annual_income],
                  "netCurrencyCode": "BTN",
                  "applicantId": data[:applicantId],
                  "applicantName": data[:applicantName],
                  "deleteFinancial": false,
                  "primaryApplicant": true,
                  "financeAmend": false,
                  "lastUpdatedOn": nil,
                  "financialModel": [
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "seqFinancialNo": 1,
                      "employmentType": "SVC",
                      "employeeNumber": "#{account_data[:employment_detail][:employee_id]}",
                      "industryType": "INTE",
                      "officeName": account_data[:employment_detail][:organization_name],
                      "designation": account_data[:employment_detail][:designation]&.upcase,
                      "employmentStartDate": "2022-01-06",
                      "employmentEndDate": nil,
                      "addressType": "P",
                      "address": {},
                      "organizationCategory": "COR",
                      "demographics": "DOM",
                      "employeeType": "F",
                      "empAgreement": "Y"
							      }
                  ],
                  "incomeModel": [
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "PN",
                      "description": "Pension",
                      "incomeAmount": 0,
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 1
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "ITI",
                      "description": "Investment Income",
                      "incomeAmount": 0,
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 2
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "AGR",
                      "description": "Agriculture",
                      "incomeAmount": 0,
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 3
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "SAL",
                      "description": "Salary",
                      "incomeAmount": get_income(account_data[:income_detail], 'salary'),
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 4
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "INT",
                      "description": "Interest Amount",
                      "incomeAmount": 0,
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 5
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "RNT",
                      "description": "Rentals",
                      "incomeAmount": get_income(account_data[:income_detail], 'rental'),
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 6
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "BNS",
                      "description": "Bonus",
                      "incomeAmount": 0,
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 7
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "CSH",
                      "description": "Cash Gifts",
                      "incomeAmount": 0,
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 8
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "OTH",
                      "description": "Other Income",
                      "incomeAmount": get_income(account_data[:income_detail], 'other'),
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 9
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "incomeType": "BUS",
                      "description": "Business",
                      "incomeAmount": 0,
                      "incomeCurrencyCode": "BTN",
                      "seqIncomeNo": 10
                    }
                  ],
                  "expenseModel": [
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "MDL",
                      "description": "Medical",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 1
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "EDU",
                      "description": "Education",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 2
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "RNT",
                      "description": "Rentals",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 3
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "HOU",
                      "description": "Household",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 4
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "VEH",
                      "description": "Vehicle",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 5
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "FUL",
                      "description": "Fuel",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 6
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "OTH",
                      "description": "Other Expenses",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 7
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "LPY",
                      "description": "Loan Payments",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 8
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "UPY",
                      "description": "Utility Payments",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 9
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "CPY",
                      "description": "Insurance Payments",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 10
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "expenseType": "CCP",
                      "description": "Credit Card Payments",
                      "expenseAmount": 0,
                      "expenseCurrencyCode": "BTN",
                      "seqExpenseNo": 11
                    }
                  ],
                  "assetModel": [
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "assetType": "HOU",
                      "description": "House",
                      "assetAmount": 0,
                      "assetCurrencyCode": "BTN",
                      "seqAssetNo": 1
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "assetType": "DEP",
                      "description": "Deposit",
                      "assetAmount": 0,
                      "assetCurrencyCode": "BTN",
                      "seqAssetNo": 2
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "assetType": "VEH",
                      "description": "Vehicle",
                      "assetAmount": 0,
                      "assetCurrencyCode": "BTN",
                      "seqAssetNo": 3
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "assetType": "OTH",
                      "description": "Other",
                      "assetAmount": 0,
                      "assetCurrencyCode": "BTN",
                      "seqAssetNo": 4
                    }
                  ],
                  "liabilityModel": [
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "PLN",
                      "description": "Property Loan",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 1
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "VHL",
                      "description": "Vehicle Loan",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 2
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "CCD",
                      "description": "Credit Card Outstanding",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 3
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "OVD",
                      "description": "Overdrafts",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 4
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "PRL",
                      "description": "Personal Loan",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 5
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "OTH",
                      "description": "Other Liability",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 6
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "HLN",
                      "description": "Home Loan",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 7
                    },
                    {
                      "applicationNumber": data[:applicationNumber],
                      "processRefNo": data[:processRefNumber],
                      "liabilityType": "EDL",
                      "description": "Education Loan",
                      "liabilityAmount": 0,
                      "liabilityCurrencyCode": "BTN",
                      "seqLiabilityNo": 8
                    }
                  ],
                  "financialProfile": [],
                  "isSectionEditable": false,
                  "financialRatioProfile": {}
					      }
              ]
				    },
            "relationshipMasterModel": {
              "id": nil,
              "applicationNumber": data[:applicationNumber],
              "remarks": nil,
              "dataSegmentCode": nil,
              "updatedBy": nil,
              "updatedTimeStamp": nil,
              "stageCode": "RPM_INITIATION",
              "createdBy": nil,
              "version": nil,
              "createdTimestamp": nil,
              "recordStat": nil,
              "status": nil,
              "processRefNo": data[:processRefNumber],
              "productType": "S",
              "channel": "OBDX",
              "action": data[:action],
              "isExistingCustomer": nil,
              "customerDetailsModel": [
                {
                  "customerName": data[:applicantName],
                  "applicantId": data[:applicantId]
                }
              ],
              "relationshipDetailsModel": []
            },
            "partyConsentMasterModel": nil,
            "accountConsentMasterModel": nil
          }
        ],
        "LoanAccOpenProcess": [],
        "SavingAccOpenProcess": [
          {
            "accountDetailsModel": {
              "id": nil,
              "applicationNumber": data[:applicationNumber],
              "remarks": nil,
              "dataSegmentCode": nil,
              "updatedBy": nil,
              "updatedTimeStamp": nil,
              "stageCode": "RPM_INITIATION",
              "createdBy": nil,
              "version": nil,
              "createdTimestamp": nil,
              "recordStat": nil,
              "status": nil,
              "action": data[:action],
              "processRefNo": data[:processRefNumber],
              "accountType": "Savings Account",
              "accountBranch": "999",
              "productCode": "SANATL",
              "productName": "SAVINGS ACCOUNT NATIONAL",
              "accountCurrency": "BTN",
              "applicationDate": "2024-05-26",
              "accountName": data[:applicantName],
              "holdingPattern": nil,
              "otherHoldingPattern": nil,
              "ownership": nil,
              "existingCustomer": false,
              "modeOfOperation": nil,
              "fundTheAccount": nil,
              "fundBy": nil,
              "amount": nil,
              "accountNumber": nil,
              "fundByAccountName": nil,
              "valueDate": "2024-05-26",
              "overdraft": nil,
              "odConfigured": "N",
              "chequeNumber": nil,
              "chequeDate": nil,
              "chequeBankName": nil,
              "chequeBranchName": nil,
              "chequeRoutingNumber": nil,
              "customerIds": nil,
              "channel": "OBDX",
              "sourceEmpCode": nil,
              "sourceEmpName": nil,
              "stageChanged": false,
              "glCode": nil,
              "glDesc": nil,
              "fundByCash": "A",
              "fundByAcc": "M",
              "fundByCheque": "M",
              "bankName": "Bhutan National Bank.",
              "bankCode": "BNB",
              "txnRefNumber": nil,
              "sourceSystemAccBrn": nil,
              "isCollateralCreated": nil,
              "businessProductDtls": {
                "businessProductCode": "SANATL",
                "businessProductImage": nil,
                "businessProductSummary": "SAVINGS ACCOUNT NATIONAL SANATL",
                "productType": nil,
                "productBrochure": nil,
                "termsandcondition": nil
              }
            },
            "nomineeDetailsMasterModel": {
              "id": nil,
              "applicationNumber": data[:applicationNumber],
              "remarks": nil,
              "dataSegmentCode": nil,
              "updatedBy": nil,
              "updatedTimeStamp": nil,
              "stageCode": "RPM_INITIATION",
              "createdBy": nil,
              "version": nil,
              "createdTimestamp": nil,
              "recordStat": nil,
              "status": nil,
              "processRefNo": data[:processRefNumber],
              "applicationDate": nil,
              "minorAge": 18,
              "channel": "OBDX",
              "action": data[:action],
              "nomineeDetailsModel": account_data[:nominees_detail].map do |nominee|
                {
                  "applicationNumber": data[:applicationNumber],
                  "processRefNo": data[:processRefNumber],
                  "isMinor": "N",
                  "relationType": nominee[:relationship],
                  "dateOfBirth": nominee[:date_of_birth],
                  "percentage": nominee[:share_percentage].to_int,
                  "title": "Mr",
                  "firstName": split_name(nominee[:name])[:first_name]&.upcase,
                  "lastName": split_name(nominee[:name])[:last_name]&.upcase || split_name(nominee[:name])[:first_name]&.upcase,
                  "gender": "M",
                  "address": {
                    "addressType": "C",
                    "location": "000",
                    "preferredMailAddress": true,
                    "buildingName": account_data[:permanent_address][:district]&.upcase,
                    "streetName": account_data[:permanent_address][:district]&.upcase,
                    "city": account_data[:permanent_address][:sub_district]&.upcase,
                    "state": account_data[:permanent_address][:village]&.upcase,
                    "country": "000",
                    "contactDetails": []
                  },
                  "guardianDetails": {}
                }
              end
            },
            "mandateDetailsMasterModel": {
              "id": nil,
              "applicationNumber": data[:applicationNumber],
              "remarks": nil,
              "dataSegmentCode": nil,
              "updatedBy": nil,
              "updatedTimeStamp": nil,
              "stageCode": "RPM_INITIATION",
              "createdBy": nil,
              "version": nil,
              "createdTimestamp": nil,
              "recordStat": nil,
              "status": nil,
              "processRefNo": data[:processRefNumber],
              "applicationDate": nil,
              "modeOfOperation": "SINGLE",
              "channel": "OBDX",
              "action": data[:action],
              "customerType": "IND",
              "ownership": "SINGLE",
              "ccy": "BTN",
              "mandateDetailsModel": [
                {
                  "id": nil,
                  "processRefNo": data[:processRefNumber],
                  "mandateDetailsMasterId": nil,
                  "amountCcy": "BTN",
                  "amountFrom": 0,
                  "amountTo": 0,
                  "reqNoOfSignatory": nil,
                  "remarks": nil
                }
              ]
            },
            "accServicesPrefMasterModel": {
              "id": nil,
              "applicationNumber": data[:applicationNumber],
              "remarks": nil,
              "dataSegmentCode": nil,
              "updatedBy": nil,
              "updatedTimeStamp": nil,
              "stageCode": nil,
              "createdBy": nil,
              "version": nil,
              "createdTimestamp": nil,
              "recordStat": nil,
              "status": nil,
              "action": data[:action],
              "channel": "OBDX",
              "processRefNo": data[:processRefNumber],
              "applicationDate": nil,
              "passbook": nil,
              "passBookAllowed": false,
              "chequeBook": nil,
              "chequeBookAllowed": false,
              "accStatement": nil,
              "accStatementAllowed": true,
              "subscriptionModeEmail": nil,
              "subscriptionModePost": nil,
              "subscriptionFrequency": nil,
              "accServicesPrefDetailsModel": [
                {
                  "id": nil,
                  "accSrvsPrefMasterId": nil,
                  "applicantId": data[:applicantId],
                  "primaryApplicant": true,
                  "applicantDetails": {
                    "customerImage": account_data[:personal_detail][:passport_photo],
                    "title": account_data[:personal_detail][:salutation],
                    "custFullName": data[:applicantName],
                    "customerType": "IND",
                    "dateOfBirth": account_data[:personal_detail][:date_of_birth],
                    "incorporationDate": "",
                    "email": account_data[:contact_detail][:email_id],
                    "mobileNo": "975#{account_data[:contact_detail][:contact_number]}",
                    "phoneNo": nil
                  },
                  "bankingChnlSubscription": {
                    "debitCard": nil,
                    "debitCardAllowed": nil,
                    "directBanking": nil,
                    "directBankingAllowed": nil,
                    "kioskBanking": nil,
                    "kioskBankingAllowed": true,
                    "phoneBanking": nil,
                    "phoneBankingAllowed": nil
                  },
                  "communicationChnlSubscription": {
                    "email": nil,
                    "emailAllowed": true,
                    "post": nil,
                    "postAllowed": true,
                    "sms": nil,
                    "smsAllowed": true,
                    "preference": nil
                  }
                }
              ]
            },
            "odAdvanceDetailsMasterModel": nil,
            "odUnsecuredTempDetailsMasterModel": nil,
            "odAccountLimitDetailsMasterModel": nil
          }
        ],
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
