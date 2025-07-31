import { Controller } from "@hotwired/stimulus";

import { validMandatory } from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "employeeDetail",
    "employeeId",
    "organizationName",
    "organizationNameError",
    "organizationAddress",
    "organizationAddressError",
    "designation",
    "designationError",
  ];

  connect() {
    this.toggleEmploymentDetails();
  }

  toggleEmploymentDetails() {
    const employmentStatus = this.element.querySelector(
      '[name="employment_detail[employment_status]"]'
    ).value;
    if (employmentStatus == "unemployed") {
      this.employeeDetailTarget.classList.add("hidden");
      this.clearDetailIfUnemployed();
    } else {
      this.employeeDetailTarget.classList.remove("hidden");
    }
  }

  clearDetailIfUnemployed() {
    this.employeeIdTarget.value = "";
    this.organizationNameTarget.value = "";
    this.organizationAddressTarget.value = "";
    this.designationTarget.value = "";
    // this.organizationNameErrorTarget.textContent = "";
    // this.organizationAddressErrorTarget.textContent = "";
    // this.cdesignationErrorTarget.textContent = "";
  }

  validateOrganizationName(event) {
    this.organizationNameErrorTarget.textContent = validMandatory(
      event.target.value
    )
      ? ""
      : "Mandatory field";
  }

  validateOrganizationAddress(event) {
    this.organizationAddressErrorTarget.textContent = validMandatory(
      event.target.value
    )
      ? ""
      : "Mandatory field";
  }

  validateDesignation(event) {
    this.designationErrorTarget.textContent = validMandatory(event.target.value)
      ? ""
      : "Mandatory field";
  }
}
