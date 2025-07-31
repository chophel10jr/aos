# frozen_string_literal: true

require 'jwt'

class DecodeTokenService < ApplicationService
  attr_accessor :token

  def run
    return nil if token.blank?

    secret = ENV["NDI_NEXUS_X_API_KEY"]
    begin
      decoded = JWT.decode(token, secret)
      decoded[0]['thread_id']
    rescue JWT::DecodeError, TypeError
      nil
    end
  end
end
