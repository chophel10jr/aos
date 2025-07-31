# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :account

  enum :address_type, {
    current: "current",
    permanent: "permanent"
  }

  validates :country, presence: true
  validates :district, presence: true
  validates :sub_district, presence: true
  validates :village, presence: true
end
