import { Controller } from "@hotwired/stimulus";
import {
  validEmail,
  validMandatory,
  validPassword,
} from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "userNameError",
    "userEmailError",
    "userPasswordError",
    "userName",
    "email",
    "branch",
    "role",
    "password",
  ];

  static values = {
    validCount: Array,
    initialUserName: String,
    initialEmail: String,
    initialBranch: String,
    initialRole: String,
  };

  connect() {
    this.validCount = ["user_name", "user_email", "user_password"];
    this.initialUserName = this.userNameTarget.value;
    this.initialEmail = this.emailTarget.value;
    this.initialBranch = this.branchTarget.value;
    this.initialRole = this.roleTarget.value;
    this.enableUpdateButton();
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
    this.userPasswordErrorTarget.textContent =
      validInput || event.target.value.length === 0 ? "" : "Invalid Password";
    this.updateCompletedCount(
      validInput || event.target.value.length === 0,
      "user_password"
    );
  }

  updateCompletedCount(status, value) {
    if (status) {
      if (!this.validCount.includes(value)) {
        this.validCount.push(value);
      }
    } else {
      if (this.validCount.includes(value)) {
        this.validCount = this.validCount.filter((item) => item !== value);
      }
    }
    this.enableUpdateButton();
  }

  enableUpdateButton() {
    const submitButton = document.getElementById(
      "submit-update-user-form-button"
    );
    if (this.checkFormCompleted() & this.checkChanges()) {
      submitButton.classList.remove("disabled");
      submitButton.disabled = false;
    } else {
      submitButton.classList.add("disabled");
      submitButton.disabled = true;
    }
  }

  checkFormCompleted() {
    if (this.validCount.length === 3) {
      return true;
    } else {
      return false;
    }
  }

  checkChanges() {
    if (
      this.initialUserName !== this.userNameTarget.value ||
      this.initialEmail !== this.emailTarget.value ||
      this.initialBranch !== this.branchTarget.value ||
      this.initialRole !== this.roleTarget.value ||
      this.passwordTarget.value.length > 0
    ) {
      return true;
    } else {
      return false;
    }
  }
}
