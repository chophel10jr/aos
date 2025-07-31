# frozen_string_literal: true

class PersonalDetail < ApplicationRecord
  belongs_to :account
  has_one :employment_detail, dependent: :destroy
  has_one :spouse_detail, dependent: :destroy

  enum :salutation, {
    Mr: "Mr",
    Miss: "Miss",
    Mrs: "Mrs"
  }

  enum :employment_status, {
    employed: "employed",
    self_employed: "self_employed",
    unemployed: "unemployed",
    other: "unemployed"
  }

  enum :marital_status, {
    single: "single",
    married: "married",
    divorced: "divorced"
  }

  validates :salutation, presence: true
  validates :gender, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :nationality, presence: true
  validates :education_level, presence: true
  validates :employment_status, presence: true
  validates :marital_status, presence: true
  validates :account_id, presence: true
end
