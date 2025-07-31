# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :role

  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :branch, presence: true
  validates :password, presence: true, length: { minimum: 8 }

  def admin?
    role.name == 'admin'
  end

  def inputer?
    role.name == 'inputer'
  end
end
