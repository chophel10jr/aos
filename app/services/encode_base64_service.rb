# frozen_string_literal: true

require 'base64'

class EncodeBase64Service < ApplicationService
  attr_accessor :uploaded_file

  def run
    return nil unless uploaded_file.respond_to?(:read)

    Base64.strict_encode64(uploaded_file.read)
  end
end
