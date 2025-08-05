import { Controller } from "@hotwired/stimulus";
import {
  validCID,
  validContactNumber,
  validDOB,
  validMandatory,
} from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "container",
    "addNomineeButton",
    "cidError",
    "shareError",
    "sharePercentage",
    "contactError",
    "nameError",
    "dobError",
  ];

  connect() {
    this.nomineeCount = 1;
    this.maxNominees = 3;
    this.updateRemoveButtons();
    this.updateSharePercentages();
    this.updateNomineeIndices();
  }

  updateNomineeIndices() {
    const forms = document.querySelectorAll(".nominee-form");
    forms.forEach((form, index) => {
      const inputs = form.querySelectorAll("input, select");
      inputs.forEach((input) => {
        let name = input.name;
        if (name) {
          const newName = name.replace(
            /\[nominee\](\[\d+\])?\[(\w+)\]/,
            `[nominee][${index}][$2]`
          );
          input.setAttribute("name", newName);
        }
      });
    });
  }

  updateRemoveButtons() {
    const removeButtons =
      this.containerTarget.querySelectorAll(".remove-nominee");
    removeButtons.forEach((button) => {
      button.style.display = this.nomineeCount === 1 ? "none" : "inline-block";
    });
  }

  updateSharePercentages() {
    const equalShare = (100 / this.nomineeCount).toFixed(2);
    this.sharePercentageTargets.forEach((field) => {
      field.value = equalShare;
    });
    this.validateSharePercentages();
  }

  validateName(event) {
    this.validateMandatory(event, '[data-nominees-target="nameError"]');
  }

  validateMandatory(event, queryValue) {
    const errorTarget = event.target
      .closest(".form-group")
      .querySelector(queryValue);
    const message = validMandatory(event.target.value) ? "" : "Mandatory field";

    errorTarget.textContent = message;
  }

  validateDOB(event) {
    const dobErrorTarget = event.target
      .closest(".form-group")
      .querySelector('[data-nominees-target="dobError"]');
    const message = validDOB(event.target.value) ? "" : "Invalid DOB";

    dobErrorTarget.textContent = message;
  }

  validateSharePercentages() {
    let total = 0;
    this.sharePercentageTargets.forEach((field) => {
      total += parseFloat(field.value);
    });

    this.shareErrorTargets.forEach((shareError) => {
      shareError.textContent =
        total !== 100 ? "Total share must be exactly 100%" : "";
    });
  }

  validateCID(event) {
    const cidErrorTarget = event.target
      .closest(".form-group")
      .querySelector('[data-nominees-target="cidError"]');
    const message = validCID(event.target.value) ? "" : "Invalid CID";

    cidErrorTarget.textContent = message;
  }

  validateContactNumber(event) {
    const contactErrorTarget = event.target
      .closest(".form-group")
      .querySelector('[data-nominees-target="contactError"]');
    const message = validContactNumber(event.target.value)
      ? ""
      : "Invalid Contact Number";

    contactErrorTarget.textContent = message;
  }

  addNominee() {
    if (this.nomineeCount < this.maxNominees) {
      this.nomineeCount++;

      const original = this.containerTarget.querySelector(".nominee-form");
      const clone = original.cloneNode(true);

      // Clear input fields in the cloned form
      const inputs = clone.querySelectorAll("input, select");
      inputs.forEach((input) => {
        input.value = input.getAttribute("type") === "number" ? 0 : "";
      });

      this.containerTarget.appendChild(clone);
      this.updateRemoveButtons();
      this.updateSharePercentages();
      this.updateNomineeIndices();

      if (this.nomineeCount === this.maxNominees) {
        this.addNomineeButtonTarget.disabled = true;
      }
    }
  }

  removeNominee(event) {
    if (event.target.classList.contains("remove-nominee")) {
      const nomineeForm = event.target.closest(".nominee-form");
      nomineeForm.remove();
      this.nomineeCount--;

      this.updateRemoveButtons();
      this.updateSharePercentages();
      this.updateNomineeIndices();

      if (this.nomineeCount < this.maxNominees) {
        this.addNomineeButtonTarget.disabled = false;
      }
    }
  }
}
