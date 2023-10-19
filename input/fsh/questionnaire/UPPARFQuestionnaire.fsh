RuleSet: QuestionnaireItem(type, linkId, text)
* linkId = {linkId}
* text = {text}
* type = {type}
RuleSet: QuestionnaireItemRepeats(type, linkId, text)
* linkId = {linkId}
* text = {text}
* type = {type}
* repeats = true
RuleSet: QuestionnaireItemInitialExpression(expression)
* extension[+]
  * url = "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-initialExpression"
  * valueExpression
    * language = #text/cql-identifier
    * expression = {expression}
RuleSet: QuestionnaireItemSignatureRequired(code, display)
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-signatureRequired"
  * valueCoding
    * system = "urn:iso-astm:E1762-95:2013"
    * code = {code}
    * display = {display}
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-usageMode"
  * valueCode = #capture
RuleSet: QuestionnaireEnableWhenBoolean(question, boolean)
* enableWhen[+]
  * question = {question}
  * operator = #=
  * answerBoolean = {boolean}

Instance: UPPARFQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/cqf-library"
  //TODO: change to UPPARF initial expressions
  * valueCanonical = "http://fhir.org/guides/cqf/us/common/Library/MBODAInitialExpressions"
* url = "http://fhir.org/guides/cqf/us/common/Questionnaire/UPPARFQuestionnaire"
* version = "0.1.0"
* name = "UPPARFQuestionnaire"
* title = "Humana Uniform Pharmacy Prior Authorization Request Form"
* status = #active
* experimental = true
* date = "2023-10-19T00:00:00+00:00"
* publisher = "Smile Digital Health"
* description = "Humana Uniform Pharmacy Prior Authorization Request Form"
* item[+]
  //TODO: determine MedicationRequest.priority by initial expression https://build.fhir.org/valueset-request-priority.html
  //suggestion: only routine would resolve to Non-Urgent, all other codes resolve in Urgent (i.e. stat, asap and urgent)
  //question: is there even time when having stat or asap requests to proceed with prior auth?
  * insert QuestionnaireItemInitialExpression("Urgency")
  * insert QuestionnaireItem(#choice, "urgency", "Urgency")
  * answerOption[+]
    * valueCoding.code = #urgent
    * valueCoding.display = "Urgent"
  * answerOption[+]
    * valueCoding.code = #routine
    * valueCoding.display = "Non-Urgent"
* item[+]
  * insert QuestionnaireItem(#group, "drug-info", "Drug Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Medication Name")
    * insert QuestionnaireItem(#string, "drug-info|drug-name", "Requested Drug Name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Is Opioid Treatment")
    * insert QuestionnaireItem(#boolean, "drug-info|drug-intention-opioid", "Is this drug intended to treat opioid dependence?")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Is First Prior Authentication")
      * insert QuestionnaireItem(#boolean, "drug-info|drug-intention-opioid|first-prior-authentication", "Is this a first request for prior authorization for this drug?")
      * insert QuestionnaireEnableWhenBoolean("drug-info|drug-intention-opioid", true)
    * item[+]
      * insert QuestionnaireItemInitialExpression("Initial Request Date")
      * insert QuestionnaireItem(#date, "drug-info|drug-intention-opioid|date-first-request", "What was the date of the first request?")
      * insert QuestionnaireEnableWhenBoolean("drug-info|drug-intention-opioid|first-prior-authentication", false)
    * item[+]
      * insert QuestionnaireItemInitialExpression("Is First Request > 12 Months")
      * insert QuestionnaireItem(#boolean, "drug-info|drug-intention-opioid|twelve-months-since-request", "Has the date of the first request been greater than twelve months ago?")
      * insert QuestionnaireEnableWhenBoolean("drug-info|drug-intention-opioid|first-prior-authentication", false)
* item[+]
  * insert QuestionnaireItem(#group, "completing-form", "Prior authentication is required and this form needs to be completed")   
    * enableBehavior = #any
  * insert QuestionnaireEnableWhenBoolean("drug-info|drug-intention-opioid", false)
  * insert QuestionnaireEnableWhenBoolean("drug-info|drug-intention-opioid|twelve-months-since-request", false)
  * item[+]
    * insert QuestionnaireItem(#group, "completing-form|patient-info", "Patient Info")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Patient Name")
      * insert QuestionnaireItem(#string, "completing-form|patient-info|patient-name", "Patient Name")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Member ID")
      * insert QuestionnaireItem(#string, "completing-form|patient-info|member-number", "Member/Subscriber Number")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Policy Number")
      * insert QuestionnaireItem(#string, "completing-form|patient-info|policy-number", "Policy/Group Number")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Date of Birth")
      * insert QuestionnaireItem(#date, "completing-form|patient-info|dob", "Patient Date of Birth")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Address")
      * insert QuestionnaireItem(#string, "completing-form|patient-info|address", "Patient Address")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Phone Number")
      * insert QuestionnaireItem(#string, "completing-form|patient-info|phone", "Patient Phone")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Email Address")
      * insert QuestionnaireItem(#string, "completing-form|patient-info|email", "Patient Email Address")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescription Date")
      * insert QuestionnaireItem(#string, "completing-form|patient-info|prescription-date", "Prescription Date")
  * item[+]
    * insert QuestionnaireItem(#group, "completing-form|prescriber-info", "Prescriber Info")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Name")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-name", "Prescriber Name")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Fax")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-fax", "Prescriber Fax")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Phone")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-phone", "Prescriber Phone")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Pager")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-pager", "Prescriber Pager")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Address")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-address", "Prescriber Address")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Contact")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-contact", "Prescriber Office Contact")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber NPI")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-npi", "Prescriber NPI")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber DEA")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-dea", "Prescriber DEA")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Tax ID")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-tax-id", "Prescriber Tax ID")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Specialty")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-specialty", "Specialty/Facility Name If applicable")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Prescriber Email Address")
      * insert QuestionnaireItem(#string, "completing-form|prescriber-info|prescriber-email", "Email Address")
  * item[+]
    * insert QuestionnaireItem(#group, "completing-form|drug-benefit", "Prior Authorization Request for Drug Benefit")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Request Type")
      * insert QuestionnaireItem(#choice, "completing-form|drug-benefit|request-type", "New Request")
        * answerOption[+]
          * valueString = "New Request"
        * answerOption[+]
          * valueString = "Reauthorization"
    * item[+]
      * insert QuestionnaireItemInitialExpression("Diagnosis Codes")
      * insert QuestionnaireItem(#open-choice, "completing-form|drug-benefit|diagnosis-codes", "Patient ICD Diagnostic Codes")
      * repeats = true
      * answerValueSet = "http://hl7.org/fhir/sid/icd-10"
    * item[+]
      * insert QuestionnaireItemInitialExpression("Diagnosis Descriptions")
      * insert QuestionnaireItem(#string, "completing-form|drug-benefit|diagnosis-descriptions", "Patient Diagnosis")
      * repeats = true