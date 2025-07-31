# frozen_string_literal: true

class ContactDetail < ApplicationRecord
  belongs_to :account

  validates :contact_number, presence: true
  validates :email_id, presence: true
  validates :account_id, presence: true
end
