import { Controller } from "@hotwired/stimulus";
import {
  validCID,
  validContactNumber,
  validDOB,
  validMandatory,
  validIssueAndExpiresDate,
  validFileUpload,
  validBnbAccount,
} from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "stepper",
    "stepperDiv",
    "stepperIcon",
    "nomineesContainer",
    "personalDetailContainer",
    "personalDetailUploadContainer",
    "incomeDetailContainer",
    "spouseDetailContainer",
    "employmentDetailContainer",
  ];
  static values = { presentStep: Number };

  connect() {
    this.presentStepValue = 1;
    this.updateStepper(this.presentStepValue);
    this.checkStepperCompletion();
  }

  randomStep(event) {
    const step = parseInt(event.target.dataset.step);
    this.presentStepValue = step;
    this.toggleStep(step);
    this.updateStepper(step);
  }

  nextStep() {
    const step = this.presentStepValue + 1;
    this.presentStepValue = step > 9 ? 9 : step;
    this.toggleStep(this.presentStepValue);
    this.updateStepper(this.presentStepValue);
  }

  previousStep() {
    const step = this.presentStepValue - 1;
    this.presentStepValue = step < 1 ? 1 : step;
    this.toggleStep(this.presentStepValue);
    this.updateStepper(this.presentStepValue);
  }

  toggleStep(step) {
    for (let i = 1; i <= 9; i++) {
      const content = document.getElementById(`onboard-step${i}-content`);
      if (i !== step) {
        content.classList.add("hidden");
      } else {
        content.classList.remove("hidden");
      }
    }
    this.checkStepperCompletion();
  }

  checkStepperCompletion() {
    this.stepperIconTargets.forEach((_, index) => {
      const status = this[`checkStep${index + 1}`]();
      this.updateStepperIcon(status, index + 1);
    });
  }

  validateBeforeSubmit(event) {
    let incompleteCount = false;
    for (let index = 0; index < this.stepperIconTargets.length; index++) {
      if (!this[`checkStep${index + 1}`]()) {
        incompleteCount = true;
        break;
      }
    }

    if (incompleteCount) {
      event.preventDefault();
      alert("Please complete all fields before submitting the form.");
    }
  }

  updateStepper(step) {
    for (let i = 1; i <= this.stepperTargets.length; i++) {
      if (i !== step) {
        this.stepperDivTargets[i - 1].classList.remove("bg-[rgba(0,0,0,0.07)]");
        this.stepperTargets[i - 1].classList.add("hidden");
      } else {
        this.stepperDivTargets[i - 1].classList.add("bg-[rgba(0,0,0,0.07)]");
        this.stepperTargets[i - 1].classList.remove("hidden");
      }
    }
  }

  updateStepperIcon(status, step) {
    const iconElement = this.stepperIconTargets[step - 1];

    if (this.presentStepValue === step) {
      iconElement.innerHTML =
        '<i class="material-symbols-outlined !text-[18px] text-bnb_red">edit</i>';
      iconElement.classList.remove("bg-bnb_blue");
    } else if (status) {
      iconElement.innerHTML =
        '<i class="material-symbols-outlined text-white">check</i>';
      iconElement.classList.add("bg-bnb_blue");
    } else {
      iconElement.innerHTML = `<span class="text-bnb_red">${step}</span>`;
      iconElement.classList.remove("bg-bnb_blue");
    }
  }

  checkStep1() {
    return true;
  }

  checkStep2() {
    return this.validatePersonalDetailForms();
  }

  checkStep3() {
    return true;
  }

  checkStep4() {
    return this.validateSpouseDetailForms();
  }

  checkStep5() {
    return this.validateNomineeForms();
  }
  checkStep6() {
    return this.validateEmploymentDetailForms();
  }

  checkStep7() {
    return this.validateIncomeDetailForms();
  }

  checkStep8() {
    return this.validateConsentLiability();
  }

  checkStep9() {
    return this.validatePrivacyPolicy();
  }

  validateNomineeForms() {
    let allValid = true;
    let totalPercentage = 0;

    this.nomineesContainerTarget
      .querySelectorAll(".nominee-form")
      .forEach((form, index) => {
        const name = form.querySelector(
          'input[name^="[nominee]["][name$="][name]"]'
        );
        const dob = form.querySelector(
          'input[name^="[nominee]["][name$="][date_of_birth]"]'
        );
        const relationship = form.querySelector(
          'select[name^="[nominee]["][name$="][relationship]"]'
        );
        const cid = form.querySelector(
          'input[name^="[nominee]["][name$="][cid_number]"]'
        );
        const contactNo = form.querySelector(
          'input[name^="[nominee]["][name$="][contact_number]"]'
        );
        const sharePercentage = form.querySelector(
          'input[name^="[nominee]["][name$="][share_percentage]"]'
        );

        totalPercentage += parseFloat(sharePercentage.value);

        if (
          !validMandatory(name.value) ||
          !validDOB(dob.value) ||
          !validMandatory(relationship.value) ||
          !validCID(cid.value) ||
          !validContactNumber(contactNo.value)
        ) {
          allValid = false;
        }
      });

    return allValid && totalPercentage === 100;
  }

  validatePersonalDetailForms() {
    let allValid = true;
    const personalDetails = this.personalDetailContainerTarget;
    const personalDetailUploads = this.personalDetailUploadContainerTarget;

    const issuedOn = personalDetails.querySelector(
      'input[name="personal_detail[cid_issued_on]"]'
    );
    const expiresOn = personalDetails.querySelector(
      'input[name="personal_detail[cid_expires_on]"]'
    );
    const cidCopy = personalDetailUploads.querySelector(
      'input[name="personal_detail[cid_copy]"]'
    );

    if (
      !validIssueAndExpiresDate(issuedOn.value, expiresOn.value) ||
      !validFileUpload(cidCopy.files[0])
    ) {
      allValid = false;
    }
    return allValid;
  }

  validateIncomeDetailForms() {
    let allValid = true;

    const gross_annual_income = this.incomeDetailContainerTarget.querySelector(
      'input[name="income[gross_annual_income]"]'
    );

    if (!validMandatory(gross_annual_income.value)) {
      allValid = false;
    }
    return allValid;
  }

  validateSpouseDetailForms() {
    let allValid = true;

    const spouseDetails = this.spouseDetailContainerTarget;
    if (
      spouseDetails.querySelector(
        'select[name="spouse_detail[marital_status]"]'
      ).value === "married"
    ) {
      const spouse_name = spouseDetails.querySelector(
        'input[name="spouse_detail[name]"]'
      );
      const spouse_cid = spouseDetails.querySelector(
        'input[name="spouse_detail[cid_number]"]'
      );
      const spouse_contact_no = spouseDetails.querySelector(
        'input[name="spouse_detail[contact_number]"]'
      );
      const education_status = spouseDetails.querySelector(
        'select[name="spouse_detail[education_level]"]'
      );
      const employment_detail = spouseDetails.querySelector(
        'select[name="spouse_detail[employment_status]"]'
      );
      const has_bnb_account = spouseDetails.querySelector(
        'select[name="spouse_detail[has_bnb_account]"]'
      );
      const bnb_account_no = spouseDetails.querySelector(
        'input[name="spouse_detail[account_number]"]'
      );

      if (
        !validMandatory(spouse_name.value) ||
        !validCID(spouse_cid.value) ||
        !validContactNumber(spouse_contact_no.value) ||
        !validMandatory(education_status.value) ||
        !validMandatory(employment_detail.value) ||
        !validMandatory(has_bnb_account.value) ||
        !this.validSpouseBnbAccount(has_bnb_account.value, bnb_account_no.value)
      ) {
        allValid = false;
      }
    }

    return allValid;
  }

  validSpouseBnbAccount(has_bnb_account, account_no) {
    return has_bnb_account.toLowerCase() === "yes"
      ? validBnbAccount(account_no)
      : true;
  }

  validateConsentLiability() {
    const liabilityCheckbox = document.getElementById("liability-check");

    if (liabilityCheckbox.checked) {
      return true;
    } else {
      return false;
    }
  }

  validatePrivacyPolicy() {
    const liabilityCheckbox = document.getElementById("privacy-check");

    if (liabilityCheckbox.checked) {
      return true;
    } else {
      return false;
    }
  }

  validateEmploymentDetailForms() {
    let allValid = true;

    const employmentDetails = this.employmentDetailContainerTarget;
    if (
      employmentDetails.querySelector(
        'select[name="employment_detail[employment_status]"]'
      ).value !== "unemployed"
    ) {
      const organization_name = employmentDetails.querySelector(
        'input[name="employment_detail[organization_name]"]'
      );
      const organization_address = employmentDetails.querySelector(
        'input[name="employment_detail[organization_address]"]'
      );
      const designation = employmentDetails.querySelector(
        'input[name="employment_detail[designation]"]'
      );

      if (
        !validMandatory(organization_name.value) ||
        !validMandatory(organization_address.value) ||
        !validMandatory(designation.value)
      ) {
        allValid = false;
      }
    }

    return allValid;
  }
}
