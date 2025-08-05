import { Controller } from "@hotwired/stimulus";

import {
  validEmail,
  validMandatory,
  validPassword,
} from "services/field-validation_services";

export default class extends Controller {
  static targets = ["userNameError", "userEmailError", "userPasswordError"];
  static values = { completedCount: Array };

  connect() {
    this.completedCount = [];
    this.checkFormCompleted();
  }

  validateUserName(event) {
    const validInput = validMandatory(event.target.value);
    this.userNameErrorTarget.textContent = validInput ? "" : "Mandatory field";
    this.updateCompletedCount(validInput, "user_name");
  }

  validateEmail(event) {
    const validInput = validEmail(event.target.value);
    this.userEmailErrorTarget.textContent = validInput ? "" : "Invalid Email";
    this.updateCompletedCount(validInput, "user_email");
  }

  validatePassword(event) {
    const validInput = validPassword(event.target.value);
    this.userPasswordErrorTarget.textContent = validInput
      ? ""
      : "Invalid Password";
    this.updateCompletedCount(validInput, "user_password");
  }

  updateCompletedCount(status, value) {
    if (status) {
      if (!this.completedCount.includes(value)) {
        this.completedCount.push(value);
      }
    } else {
      if (this.completedCount.includes(value)) {
        this.completedCount = this.completedCount.filter(
          (item) => item !== value
        );
      }
    }
    this.checkFormCompleted();
  }

  checkFormCompleted() {
    const submitButton = document.getElementById("submit-user-form-button");
    if (this.completedCount.length === 3) {
      submitButton.classList.remove("disabled");
      submitButton.disabled = false;
    } else {
      submitButton.classList.add("disabled");
      submitButton.disabled = true;
    }
  }
}
