Alias: $UCUM = http://unitsofmeasure.org
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
RuleSet: QuestionnaireItemUnit(code, display)
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * valueCoding
    * system = $UCUM
    * code = {code}
    * display = {display}
RuleSet: QuestionnaireEnableWhenEqualsCoding(question, coding)
* enableWhen[+]
  * question = {question}
  * operator = #=
  * answerCoding = {coding}
RuleSet: QuestionnaireUnitOption(code, display)
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unitOption"
  * valueCoding
    * system = $UCUM
    * code = {code}
    * display = {display}
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

Instance: NucalaQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* title = "Nucala (mepolizumab) Request Form"
* status = #draft
* date = "2024-02-29"
* publisher = "Smile Digital Health"

// Request and Patient Information
* item[+]
  * insert QuestionnaireItemInitialExpression("Date of Request")
  * insert QuestionnaireItem(#date, "date-of-request", "Date of Request")
* item[+]
  * insert QuestionnaireItemInitialExpression("Patient Name")
  * insert QuestionnaireItem(#string, "patient-name", "Patient Name")
* item[+]
  * insert QuestionnaireItemInitialExpression("Date of Birth")
  * insert QuestionnaireItem(#date, "patient-dob", "Date of Birth")
* item[+]
  * insert QuestionnaireItemInitialExpression("ProviderOne Client ID")
  * insert QuestionnaireItem(#string, "providerone-client-id", "ProviderOne Client ID")

// Prescriber Information
* item[+]
  * insert QuestionnaireItemInitialExpression("Prescriber Name")
  * insert QuestionnaireItem(#string, "prescriber-name", "Prescriber Name")
* item[+]
  * insert QuestionnaireItemInitialExpression("Billing Provider NPI Number")
  * insert QuestionnaireItem(#integer, "billing-provider-npi", "Billing Provider NPI Number")
* item[+]
  * insert QuestionnaireItemInitialExpression("Telephone Number")
  * insert QuestionnaireItem(#string, "prescriber-phone", "Telephone Number")
* item[+]
  * insert QuestionnaireItemInitialExpression("Fax Number")
  * insert QuestionnaireItem(#string, "prescriber-fax", "Fax Number")

// Medication Details
* item[+]
  * insert QuestionnaireItemInitialExpression("Medication Details")
  * insert QuestionnaireItem(#string, "medication-details", "Drug/Strength/Dose/Frequency")

// Diagnosis and Treatment Criteria
* item[+]
  * insert QuestionnaireItemInitialExpression("Diagnosed with Severe Asthma")
  * insert QuestionnaireItem(#choice, "diagnosed-with-severe-asthma", "Is patient diagnosed with severe asthma?")
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"

* item[+]
  * insert QuestionnaireItemInitialExpression("Eosinophilic Phenotype")
  * insert QuestionnaireItem(#choice, "eosinophilic-phenotype", "If yes\, is the asthma diagnosis the eosinophilic phenotype?")
  * insert QuestionnaireEnableWhenEqualsCoding("diagnosed-with-severe-asthma", #yes)
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"

* item[+]
  * insert QuestionnaireItemInitialExpression("Other Diagnosis")
  * insert QuestionnaireItem(#string, "other-diagnosis", "If no\, what is patient’s diagnosis?")
  * insert QuestionnaireEnableWhenEqualsCoding("diagnosed-with-severe-asthma", #no)

// Eosinophil Count Criteria
* item[+]
  * insert QuestionnaireItemInitialExpression("Eosinophil Count ≥ 150")
  * insert QuestionnaireItem(#choice, "eosinophil-count-150", "Blood eosinophil count ≥ 150 cells/μL in the past 6 weeks?")
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"

* item[+]
  * insert QuestionnaireItemInitialExpression("Eosinophil Count ≥ 300")
  * insert QuestionnaireItem(#choice, "eosinophil-count-300", "Blood eosinophil count ≥ 300 cells/μL in the past 12 months?")
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"

// Corticosteroid and Controller Use
* item[+]
  * insert QuestionnaireItemInitialExpression("High-Dose Corticosteroid Use")
  * insert QuestionnaireItem(#choice, "high-dose-corticosteroid-use", "Is patient using a high-dose inhaled corticosteroid and additional controllers?")
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"
* item[+]
  * insert QuestionnaireItemInitialExpression("Inhaled Corticosteroid Strength")
  * insert QuestionnaireItem(#string, "inhaled-corticosteroid-strength", "Which inhaled corticosteroid and strength was used?")
  * insert QuestionnaireEnableWhenEqualsCoding("high-dose-corticosteroid-use", #yes)
* item[+]
  * insert QuestionnaireItemInitialExpression("Symptomatic after Regular Inhaled Corticosteroid Use")
  * insert QuestionnaireItem(#choice, "symptomatic-after-regular-use", "Did patient remain symptomatic after 2-6 weeks of regular use?")
  * insert QuestionnaireEnableWhenEqualsCoding("high-dose-corticosteroid-use", #yes)
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"
* item[+]
  * insert QuestionnaireItemInitialExpression("2 or more exacerbations in past 12 months despite regular inhaled Corticosteroid use")
  * insert QuestionnaireItem(#choice, "exacerbations-in-past-year", "Has patient had 2 or more exacerbations in past 12 months despite regular use?")
  * insert QuestionnaireEnableWhenEqualsCoding("high-dose-corticosteroid-use", #yes)
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"


// Additional Medication Questions
* item[+]
  * insert QuestionnaireItem(#choice, "vaccinated-against-varicella", "Has patient been vaccinated against varicella zoster virus - shingles?")
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"
* item[+]
  * insert QuestionnaireItemInitialExpression("Reason for no vaccination")
  * insert QuestionnaireItem(#string, "reason-for-no-vaccination", "If no\, please provide a reason:")
  * insert QuestionnaireEnableWhenEqualsCoding("vaccinated-against-varicella", #no)

* item[+]
  * insert QuestionnaireItemInitialExpression("Taking Xolair or Cinqair concurrently with Nucala")
  * insert QuestionnaireItem(#choice, "taking-xolair-or-cinqair", "Will patient be taking Xolair - omalizumab - or Cinqair - reslizumab - concurrently with Nucala - mepolizumab?")
  * answerOption[+]
    * valueCoding.code = #yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #no
    * valueCoding.display = "No"

// Patient Response to Nucala
* item[+]
  * insert QuestionnaireItem(#group, "already-taking-nucala", "For patients who have already been taking Nucala - mepolizumab:")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Decreased Use of Rescue Medications")
    * insert QuestionnaireItem(#choice, "already-taking-nucala|improvement-with-nucala-rescue-medications", "Decreased use of rescue medications?")
    * answerOption[+]
      * valueCoding.code = #yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #no
      * valueCoding.display = "No"
  * item[+]
    * insert QuestionnaireItemInitialExpression("Decreased Frequency of Exacerbations")
    * insert QuestionnaireItem(#choice, "already-taking-nucala|improvement-with-nucala-exacerbations", "Decreased frequency of exacerbations?")
    * answerOption[+]
      * valueCoding.code = #yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #no
      * valueCoding.display = "No"
  * item[+]
    * insert QuestionnaireItemInitialExpression("Increased FEV1%")
    * insert QuestionnaireItem(#choice, "already-taking-nucala|improvement-with-nucala-fev1", "Increased FEV1% to at least 70% predicted FEV1%?")
    * answerOption[+]
      * valueCoding.code = #yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #no
      * valueCoding.display = "No"
  * item[+]
    * insert QuestionnaireItemInitialExpression("Signs of Anaphylaxis")
    * insert QuestionnaireItem(#choice, "already-taking-nucala|anaphylaxis-during-treatment", "Did patient show any signs of anaphylaxis during treatment?")
    * answerOption[+]
      * valueCoding.code = #yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #no
      * valueCoding.display = "No"


// Prescriber's Signature
* item[+]
  * insert QuestionnaireItem(#group, "chart-notes", "Chart Notes")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Prescriber's Signature")
    * insert QuestionnaireItem(#attachment, "chart-notes|prescriber-signature", "Prescriber's Signature")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Prescriber's Specialty")
    * insert QuestionnaireItem(#string, "chart-notes|prescriber-specialty", "Prescriber's Specialty")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Signature Date")
    * insert QuestionnaireItem(#date, "chart-notes|signature-date", "Date")



