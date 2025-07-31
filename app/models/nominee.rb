# frozen_string_literal: true

class Nominee < ApplicationRecord
  belongs_to :account

  validates :name, presence: true
  validates :date_of_birth, presence: true
  validates :relationship, presence: true
  validates :cid_number, presence: true
  validates :contact_number, presence: true
  validates :share_percentage, presence: true
  validates :account_id, presence: true
end
