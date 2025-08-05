export const validCID = (cid) => {
  const cidPattern = /^\d{11}$/;
  return cidPattern.test(cid.trim());
};

export const validContactNumber = (contactNumber) => {
  const contactNumberPattern = /^(77|17|16)\d{6}$/;
  return contactNumberPattern.test(contactNumber);
};

export const validBnbAccount = (accountNumber) => {
  const bnbAccountNumberPattern = /^(65)\d{7}$/;
  return bnbAccountNumberPattern.test(accountNumber);
};

export const validMandatory = (value) => {
  return value.trim() !== "";
};

export const validDOB = (value) => {
  const dob = new Date(value);
  const today = new Date();

  if (!value || isNaN(dob) || dob > today) {
    return false;
  } else {
    return true;
  }
};

export const validEmail = (email) => {
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailPattern.test(email.trim());
};

export const validIssueAndExpiresDate = (issueDate, expireDate) => {
  const issue = new Date(issueDate);
  const expire = new Date(expireDate);

  if (isNaN(issue) || isNaN(expire) || expire <= issue) {
    return false;
  }

  return true;
};

export const validFileUpload = (file) => {
  if (!file) {
    return false;
  }
  const validFileTypes = ["image/jpeg", "image/png"];
  const maxSizeInBytes = 2 * 1024 * 1024;

  if (!validFileTypes.includes(file.type) || file.size > maxSizeInBytes) {
    return false;
  }

  return true;
};

export const validPassword = (value) => {
  const passwordRegex =
    /^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$/;

  return passwordRegex.test(value);
};
