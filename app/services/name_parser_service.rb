# app/services/name_parser_service.rb
class NameParserService < ApplicationService
    def initialize(full_name)
      @full_name = full_name
    end
  
    def run
      name_parts = @full_name.split
      first_name = name_parts.first
      last_name = name_parts.last
      middle_name = name_parts.length > 2 ? name_parts[1...-1].join(' ') : nil
  
      { first_name: first_name, last_name: last_name, middle_name: middle_name }
    end
end
  