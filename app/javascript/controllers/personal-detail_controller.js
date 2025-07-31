import { Controller } from "@hotwired/stimulus";
import {
  validFileUpload,
  validIssueAndExpiresDate,
} from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "issueDate",
    "expireDate",
    "issuedOnError",
    "expiresOnError",
    "signatureError",
    "signatureImage",
    "cidCopyError",
    "cidCopyImage",
  ];

  connect() {}

  validateIssueAndExpireDate() {
    const message = validIssueAndExpiresDate(
      this.issueDateTarget.value,
      this.expireDateTarget.value
    )
      ? ""
      : "Invalid Issued and Expires Date";
    this.issuedOnErrorTarget.textContent = message;
    this.expiresOnErrorTarget.textContent = message;
  }

  validateSignature(event) {
    const file = event.target.files[0];
    const display_path = document.getElementById("signature-path");
    const message = validFileUpload(file) ? "" : "Invalid Signature";
    this.signatureErrorTarget.textContent = message;
    display_path.innerHTML = validFileUpload(file) ? file.name : "";
  }

  validateCidCopy(event) {
    const file = event.target.files[0];
    const display_path = document.getElementById("cid-copy-path");
    const message = validFileUpload(file) ? "" : "Invalid CID Copy";
    this.cidCopyErrorTarget.textContent = message;
    display_path.innerHTML = validFileUpload(file) ? file.name : "";
  }
}
