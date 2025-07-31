require 'date'

module OboHelper
  def marital_code(status)
    codes = {
      'single' => 'UMR',
      'married' => 'MRD',
      'divorced' => 'LSP'
    }
    codes[status]
  end

  def income_code(status)
    codes = {
      'salary' => 'SAL',
      'rental' => 'SAL',
      'other' => 'SAL'
    }
    codes[status]
  end

  def calculate_age(dob)
    today = Date.today
    age = today.year - dob.year
  
    age -= 1 if today < dob + age.years
    age
  end

  def split_name(full_name)
    parts = full_name.split

    case parts.length
    when 1
      { first_name: parts[0], middle_name: nil, last_name: nil }
    when 2
      { first_name: parts[0], middle_name: nil, last_name: parts[1] }
    else
      {
        first_name: parts[0],
        middle_name: parts[1..-2].join(" "),
        last_name: parts[-1]
      }
    end
  end

  def get_income(income, type)
    if income[:source].downcase == type
      income[:gross_annual_income].to_i
    else
      0
    end
  end

  def get_employment_type(type)
    type == 'unemployed' ? 'UEM' : 'EMP'
  end

  def get_employee_type(type)
    employee_types = {
      'Full Time Temporary' => 'T',
      'Retired Non Pensioned' => 'N',
      'Retired Pensioned' => 'R',
      'Part Time' => 'P',
      'Other' => 'O',
      'Full Time Permanent' => 'F',
      'Self Employed' => 'S'
    }
    employee_types.fetch(type, 'U')
  end

  def get_organization_category(type)
    organization_categories = {
      'Government' => 'GOV',
      'Religious Sector' => 'REL',
      'Autonomous' => 'AUT',
      'Corporate' => 'COR',
      'NGO' => 'NGO',
      'Private Limited' => 'PVT'
    }
    organization_categories.fetch(type, 'UEM')
  end

  def get_organization_code(type)
    organization_codes = {
      'Government' => '04',
      'Religious Sector' => '07',
      'Autonomous' => '05',
      'Corporate' => '03',
      'NGO' => '06',
      'Private Limited' => '02'
    }
    organization_codes.fetch(type, '01')
  end

  def is_minor?(dob)
    return false if dob.nil?
    age = ((Date.today - dob).to_i / 365.25).floor
    age <= 14
  end
end
