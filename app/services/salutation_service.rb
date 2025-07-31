# app/services/salutation_service.rb
class SalutationService
    def initialize(gender)
        @gender = gender
    end

    def run
      case @gender.downcase
      when "male"
        "Mr"
      when "female"
        "Mrs"
      else
        "Other"
      end
    end
  end
  