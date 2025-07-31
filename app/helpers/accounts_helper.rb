module AccountsHelper
  def format_name(account)
    "#{account&.personal_detail&.first_name} #{account&.personal_detail&.middle_name&.presence || ''} #{account&.personal_detail&.last_name}".strip
  end

  def account_detail(account)
    [
      {label: 'Branch', value: account.branch_code},
      {label: 'Account Type', value: account.account_type},
      {label: 'Currency', value: account.currency},
      {label: 'Mode of operation', value: account.mode_of_operation}
    ]
  end

  def nominees_detail(account)
    nominees_list = []
    account.nominees.each do |nominee|
      nominees_list << [
        {label: 'Name', value: nominee.name},
        {label: 'DOB', value: nominee.date_of_birth},
        {label: 'Relationship', value: nominee.relationship},
        {label: 'CID', value: nominee.cid_number},
        {label: 'Contact Number', value: nominee.contact_number},
        {label: 'Share Percentage', value: nominee.share_percentage}
      ]
    end
    nominees_list
  end

  def personal_detail(account)
    [
      {label: 'Salutation', value: account.personal_detail.salutation},
      {label: 'Name', value: "#{account&.personal_detail&.first_name} #{account&.personal_detail&.middle_name&.presence || ''} #{account&.personal_detail&.last_name}".strip},
      {label: 'CID', value: get_cid(account).id_number},
      {label: 'Issued On', value: get_cid(account).id_issued_on},
      {label: 'Expires On', value: get_cid(account).id_expires_on},
      {label: 'Email ID', value: account.contact_detail.email_id},
      {label: 'Tax payer No', value: "#####"},
      {label: 'Fixes Line No', value: "#####"},
      {label: 'Contact Number', value: account.contact_detail.contact_number || "#####"},
      {label: 'Education', value: account.personal_detail.education_level},
      {label: 'dob', value: account.personal_detail.date_of_birth}
    ]
  end

  def permanent_address(account)
    permanent_address = account.addresses.where(address_type: 'permanent').first
    [
      {label: 'House No', value: permanent_address['house_number']},
      {label: 'Thram No', value: permanent_address['land_record_number']},
      {label: 'Village', value: permanent_address['village']},
      {label: 'Gewog', value: permanent_address['sub_district']},
      {label: 'Dungkhag', value: permanent_address['block'] || "#####"},
      {label: 'Dzongkhag', value: permanent_address['district']}
    ]
  end

  def employment_detail(account)
    if account.personal_detail.employment_status == 'unemployed'
      [
        {label: 'Employment Status', value: account.personal_detail.employment_status}
      ]
    else
      [
        {label: 'Employment Status', value: account.personal_detail.employment_status},
        {label: 'Employee ID', value: account.personal_detail.employment_detail.employee_id || "#####"},
        {label: 'Organization Name', value: account.personal_detail.employment_detail.organization_name || "#####"},
        {label: 'Organization Address', value: account.personal_detail.employment_detail.organization_address || "#####"},
        {label: 'Designation', value: account.personal_detail.employment_detail.designation || "#####"},
        {label: 'Employment Type', value: account.personal_detail.employment_detail.employment_type || "#####"},
        {label: 'Employee Type', value: account.personal_detail.employment_detail.employee_type || "#####"}
      ]
    end
  end

  def income_detail(account)
    [
      {label: 'Source of Income', value: account.income_detail.source_of_income},
      {label: 'Gross Annual Income', value: account.income_detail.gross_annual_income}
    ]
  end

  def spouse_detail(account)
    if account.personal_detail.marital_status == 'married'
      [
        {label: 'Marital Status', value: account.personal_detail.marital_status},
        {label: 'Name of Spouse', value: account.personal_detail.spouse_detail.name || "#####"},
        {label: 'CID', value: account.personal_detail.spouse_detail.cid_number || "#####"},
        {label: 'Contact Number', value: account.personal_detail.spouse_detail.contact_number || "#####"},
        {label: 'Education status', value: account.personal_detail.spouse_detail.education_level || "#####"},
        {label: 'Employment Detail', value: account.personal_detail.spouse_detail.employment_status || "#####"},
        {label: 'BNB Account Number', value: account.personal_detail.spouse_detail.account_number || "#####"},
        {label: 'Number of Children', value: account.personal_detail.spouse_detail.number_of_children || "#####"}
      ]
    else
      [
        {label: 'Marital Status', value: account.personal_detail.marital_status}
      ]
    end
  end

  def current_address_detail(account)
    current_address = account.addresses.where(address_type: 'current').first
    [
      {label: 'Country', value: current_address['country']},
      {label: 'City', value: current_address['district']},
      {label: 'State', value: current_address['sub_district']},
      {label: 'Village', value: current_address['village']}
    ]
  end

  def get_cid(account)
    account.identity_details.where(id_type: "cid").first
  end

  def status_color(status)
    if status == 'approved'
      'bg-success'
    elsif status == 'in_progress'
      'bg-inprogress'
    elsif status == 'rejected'
      'bg-bnb_red'
    else
      'bg-gray-500'
    end
  end
end
