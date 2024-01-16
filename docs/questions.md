# Questions that relate to multiple Prior-Auth Questionnaires

## Urgency
### Description
Almost all prior auth forms contain a question about the urgency of the request. Different forms have different ways of expressing the same logic. E.g., the [Humana Uniform Pharmacy Prior Authorization Request Form](https://docushare-web.apps.external.pioneer.humana.com/Marketing/docushare-app?file=2567656) uses check boxes with the strings "Urgent" and "Non-Urgent". The form [Geisinger Medical Benefit Outpatient Drug Authorization Form](https://www.geisinger.org/-/media/OneGeisinger/Files/PDFs/Provider/NaviNet/Forms/medical-benefit-outpatient-drug-authorization-form-050819.pdf?sc_lang=en&hash=6EDE27E13FCCB5731E081FC49B85359D) contains a categorization as "Urgent" more in a boolean logic with a required rationale if the request is labelled as "Urgent". 

Potentially, urgency can be determined by specific FHIR elements such as the MedicationRequest.priority element. In the current implementations, only `routine` codes are determined non-urgent, all other codes (such as `stat`, `asap`, `urgent`).

### Question
When authoring the request forms into FHIR Questionnaires, should we also slightly harmonize common questions? E.g., by making "Urgency" a type boolean question as oppose to pre-defined string answers?