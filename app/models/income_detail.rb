# frozen_string_literal: true

class IncomeDetail < ApplicationRecord
  belongs_to :account

  validates :source_of_income, presence: true
  validates :gross_annual_income, presence: true
  validates :account_id, presence: true
end
