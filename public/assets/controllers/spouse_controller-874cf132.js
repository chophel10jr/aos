import { Controller } from "@hotwired/stimulus";
import {
  validCID,
  validContactNumber,
  validBnbAccount,
} from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "spouseDetails",
    "cidError",
    "contactError",
    "bnbAccountError",
    "spouseBnbAccount",
  ];

  connect() {
    this.toggleSpouseDetails();
  }

  toggleSpouseDetails() {
    const maritalStatus = this.element.querySelector(
      '[name="spouse_detail[marital_status]"]'
    ).value;
    this.spouseDetailsTarget.style.display =
      maritalStatus === "married" ? "block" : "none";
  }

  toggleBnbAccount(event) {
    if (event.target.value.toLowerCase() === "yes") {
      this.spouseBnbAccountTarget.classList.remove("hidden");
    } else {
      this.spouseBnbAccountTarget.classList.add("hidden");
    }
  }

  validateCID(event) {
    const message = validCID(event.target.value) ? "" : "Invalid CID";
    this.cidErrorTarget.textContent = message;
  }

  validateContactNumber(event) {
    const message = validContactNumber(event.target.value)
      ? ""
      : "Invalid Contact Number";
    this.contactErrorTarget.textContent = message;
  }

  validateBnbAccount(event) {
    const message = validBnbAccount(event.target.value)
      ? ""
      : "Invalid BNB Account Number";
    this.bnbAccountErrorTarget.textContent = message;
  }
}
