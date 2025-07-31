# frozen_string_literal: true

class EmergencyContact < ApplicationRecord
  belongs_to :account

  validates :name, presence: true
  validates :relationship, presence: true
  validates :contact_number, presence: true
  validates :cid_number, presence: true
  validates :address, presence: true
  validates :account_id, presence: true
end
