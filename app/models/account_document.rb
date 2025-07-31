# frozen_string_literal: true

class AccountDocument < ApplicationRecord
  belongs_to :account

  enum :document_type, {
    cid_copy: "cid_copy",
    passport_photo: "passport_photo",
    signature: "signature"
  }

  validates :document_type, presence: true
end
