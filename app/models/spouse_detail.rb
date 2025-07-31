# frozen_string_literal: true

class SpouseDetail < ApplicationRecord
  belongs_to :personal_detail

  validates :personal_detail_id, presence: true
end
