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


Instance: OpdivoQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* title = "Opdivo (nivolumab) Request Form"
* status = #draft
* date = "2024-02-22"
* publisher = "Smile Digital Health"

* item[+]
  * insert QuestionnaireItemInitialExpression("Date of Request")
  * insert QuestionnaireItem(#dateTime, "date-of-request", "Date of Request")
* item[+]
  * insert QuestionnaireItemInitialExpression("Patient Name")
  * insert QuestionnaireItem(#string, "patient-name", "Patient Name")
* item[+]
  * insert QuestionnaireItemInitialExpression("Patient Date of Birth")
  * insert QuestionnaireItem(#date, "patient-dob", "Patient Date of Birth")
* item[+]
  * insert QuestionnaireItemInitialExpression("ProviderOne Client ID")
  * insert QuestionnaireItem(#string, "providerone-client-id", "ProviderOne Client ID")

* item[+]
  * insert QuestionnaireItemInitialExpression("Prescriber Name")
  * insert QuestionnaireItem(#string, "prescriber-name", "Prescriber Name")
* item[+]
  * insert QuestionnaireItemInitialExpression("Billing Provider NPI Number")
  * insert QuestionnaireItem(#integer, "billing-provider-npi", "Billing Provider NPI Number")
* item[+]
  * insert QuestionnaireItemInitialExpression("Telephone Number")
  * insert QuestionnaireItem(#string, "telephone-number", "Telephone Number")
* item[+]
  * insert QuestionnaireItemInitialExpression("Fax Number")
  * insert QuestionnaireItem(#string, "fax-number", "Fax Number")

* item[+]
  * insert QuestionnaireItemInitialExpression("Drug/Strength/Dose/Frequency")
  * insert QuestionnaireItem(#string, "drug-strength-dose-frequency", "Drug/Strength/Dose/Frequency")

* item[+]
  * insert QuestionnaireItemInitialExpression("Patient’s diagnosis")
  * insert QuestionnaireItem(#choice, "patient-diagnosis", "What is patient’s diagnosis?")
  * answerOption[+]
    * valueCoding.code = #MetasticMelanoma
    * valueCoding.display = "Metastic Melanoma"
  * answerOption[+]
    * valueCoding.code = #MetasticNSCLC
    * valueCoding.display = "Metastic non-small cell lung cancer (NSCLC)"
  * answerOption[+]
    * valueCoding.code = #OtherDiagnosis
    * valueCoding.display = "Other"


* item[+]
  * insert QuestionnaireItemInitialExpression("EGFR or ALK positive if NSCLC")
  * insert QuestionnaireItem(#choice, "nsclc-egfr-alk-positive", "If diagnosis is NSCLC\, is patient EGFR or ALK positive?")
  * insert QuestionnaireEnableWhenEqualsCoding("patient-diagnosis", #MetasticNSCLC)
  * answerOption[+]
    * valueCoding.code = #Yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #No
    * valueCoding.display = "No"


* item[+]
  * insert QuestionnaireItemInitialExpression("Other treatments tried")
  * insert QuestionnaireItem(#string, "other-treatments-tried", "What other treatments have been tried?")

* item[+]
  * insert QuestionnaireItemInitialExpression("Prescribed for monotherapy")
  * insert QuestionnaireItem(#choice, "prescribed-for-monotherapy", "Is this prescribed for monotherapy use?")
  * answerOption[+]
    * valueCoding.code = #Yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #No
    * valueCoding.display = "No"
* item[+]
  * insert QuestionnaireItemInitialExpression("Other anti-cancer drugs with Opdivo")
  * insert QuestionnaireItem(#string, "other-anticancer-drugs", "If no\, what other anti-cancer drugs will be prescribed with Opdivo?")
  * insert QuestionnaireEnableWhenEqualsCoding("prescribed-for-monotherapy", #No)

* item[+]
  * insert QuestionnaireItemInitialExpression("Opdivo disease progression")
  * insert QuestionnaireItem(#choice, "opdivo-disease-progression", "For patients already taking Opdivo\, has the patient had disease progression?")
  * answerOption[+]
    * valueCoding.code = #Yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #No
    * valueCoding.display = "No"

* item[+]
  * insert QuestionnaireItemInitialExpression("Opdivo unacceptable toxicity")
  * insert QuestionnaireItem(#choice, "opdivo-unacceptable-toxicity", "For patients already taking Opdivo\, has the patient had unacceptable toxicity?")
  * answerOption[+]
    * valueCoding.code = #Yes
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #No
    * valueCoding.display = "No"

* item[+]
  * insert QuestionnaireItemInitialExpression("Prescriber's Signature")
  * insert QuestionnaireItem(#attachment, "prescriber-signature", "Prescriber's Signature")
* item[+]
  * insert QuestionnaireItemInitialExpression("Prescriber's Specialty")
  * insert QuestionnaireItem(#string, "prescriber-specialty", "Prescriber's Specialty")
* item[+]
  * insert QuestionnaireItemInitialExpression("Signature Date")
  * insert QuestionnaireItem(#date, "signature-date", "Date")