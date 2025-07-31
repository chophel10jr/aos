# frozen_string_literal: true

class IdentityDetail < ApplicationRecord
  belongs_to :account

  enum :id_type, {
    cid: "cid",
    passport: "passport",
    work_permit: "work_permit",
    resident_permit: "resident_permit",
    green_card: "green_card",
    mohca_letter: "mohca_letter",
    marriage_certificate: "marriage_certificate"
  }

  validates :id_type, presence: true
  validates :id_number, presence: true, length: { minimum: 6 }
  validates :id_issued_on, presence: true
  validates :id_expires_on, presence: true
  validates :account_id, presence: true
end
