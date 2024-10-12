// ==UserScript==
// @name         Floating Button to Open Data URL
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Creates a button that opens a data URL in a new tab with amazon transactions
// @author       Miller Hall
// @match        https://www.amazon.com/cpe/yourpayments/transactions
// @icon         https://www.google.com/s2/favicons?sz=64&domain=amazon.com
// @grant        none
// ==/UserScript==

(function () {
  'use strict';
  const DATE_REGEX = /(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}, 20\d{2}/;

  // Create a button element
  const button = document.createElement("button");
  button.innerHTML = "Open CSV";

  // Style the button
  button.style.position = "fixed";
  button.style.top = "10px";
  button.style.right = "10px";
  button.style.zIndex = "1000";
  button.style.padding = "10px 15px";
  button.style.backgroundColor = "#007bff";
  button.style.color = "white";
  button.style.border = "none";
  button.style.borderRadius = "5px";
  button.style.cursor = "pointer";

  // Append the button to the body
  document.body.appendChild(button);

  // Add click event to the button
  button.addEventListener("click", function () {
    let date;
    let charges = [];
    for (const el of document.querySelectorAll("div.pmts-portal-component")) {
      const dateMatch = el.textContent.match(DATE_REGEX);
      if (dateMatch) {
        date = dateMatch[0];
        continue;
      }

      const chargeMatch = el.textContent.match(/-\$\d+\.\d{2}/);
      if (chargeMatch) {
        const charge = chargeMatch[0].replaceAll(/[-$]/g, "");
        charges.push(`${charge},"${date}"`);
      }
    }

    let centsCsv = charges.join("\n");
    let centsCsvEncoded = encodeURIComponent(centsCsv);

    // Define the data URL content
    const data = `data:text/plain,${centsCsvEncoded}`;

    // Create a temporary <a> element
    const link = document.createElement("a");
    // Set the href to the data URL
    link.href = data;
    // Set the download attribute to define the filename
    link.download = "amazon-transactions.csv"; // You can change the file name here
    // Append the link to the document
    document.body.appendChild(link);
    // Programmatically click the link to trigger the download
    link.click();
    // Remove the link after download
    document.body.removeChild(link);
  });
})();

