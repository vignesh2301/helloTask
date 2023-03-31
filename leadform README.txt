This Salesforce Lightning Web Component (LWC) allows users to create a new lead record in Salesforce. The component includes fields for the lead's first name, last name, company, email, phone number, and country. When a lead is created with the country "Pakistan", it triggers an approval process, and an email is sent to the manager for approval. If the manager approves the lead, it is processed further.

Functionality:

The user can enter lead information such as first name, last name, company, email, phone, and country.
The user is required to enter certain fields, which are marked with the "validate" class. If the user leaves any of these fields empty or enters an invalid value, an error message is displayed below the field.
The user can select the country from a dropdown menu (Lightning Combobox) that contains a list of countries. The dropdown options are populated using an array of objects containing the country names and their respective ISO codes.
When the user clicks the "Create Lead" button, a function called handleCreateLead() is called. This function validates the form inputs and then calls a method called createLead() to create the lead record in Salesforce.
If the country selected is "Pakistan", an approval process is triggered, and an email is sent to the manager for approval. If the manager approves the lead, it is processed further.
When the lead is created, an email notification is sent to the lead owner.
Acknowledgments:

This component was developed by Trumatics.