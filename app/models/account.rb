# frozen_string_literal: true

class Account < ApplicationRecord
  has_one :personal_detail, dependent: :destroy
  has_one :contact_detail, dependent: :destroy
  has_one :income_detail, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :identity_details, dependent: :destroy
  has_many :nominees, dependent: :destroy
  has_many :emergency_contacts, dependent: :destroy
  has_many :account_documents, dependent: :destroy

  enum :account_type, {
    normal_saving: "normal_saving",
    pensioners_saving: "pensioners_saving"
  }

  enum :currency, {
    BTN: "BTN",
    USD: "USD",
    Euro: "Euro",
    AUD: "AUD",
    GBP: "GBP",
    JPY: "JPY"
  }

  enum :mode_of_operation, {
    single: "single",
    any_one: "any_one",
    any_two: "any_two",
    all_account: "all_account"
  }

  enum :status, {
    inprogress: "inprogress",
    rejected: "rejected",
    approved: "approved"
  }

  validates :account_number, uniqueness: true, allow_blank: true
  validates :currency, presence: true
  validates :account_type, presence: true
  validates :mode_of_operation, presence: true
  validates :status, presence: true
  validates :branch_code, presence: true
  validates :thread_id, presence: true
end
