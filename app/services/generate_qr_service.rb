# frozen_string_literal: true

class GenerateQrService < ApplicationService
  attr_accessor :code

  def run
    qrcode = RQRCode::QRCode.new(code)
    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true,
    )
  end
end
