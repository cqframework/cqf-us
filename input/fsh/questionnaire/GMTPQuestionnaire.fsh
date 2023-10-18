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

Instance: GMTPQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/cqf-library"
  * valueCanonical = "http://fhir.org/guides/cqf/us/common/Library/GMTPInitialExpressions"
* url = "http://fhir.org/guides/cqf/us/common/Questionnaire/GMTPQuestionnaire"
* version = "0.1.0"
* name = "GMTPQuestionnaire"
* title = "Genetic/Molecular testing preauthorization request"
* status = #active
* experimental = true
* date = "2023-10-12T00:00:00+00:00"
* publisher = "Smile Digital Health"
* description = "TODO"

* item[+]
  * insert QuestionnaireItem(#group, "patient-info", "Patient Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Patient Name")
    * insert QuestionnaireItem(#string, "patient-info|name", "Patient name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Date of Birth")
    * insert QuestionnaireItem(#date, "patient-info|dob", "DOB")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Humana ID")
    * insert QuestionnaireItem(#string, "patient-info|humana-id", "Humana ID #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Phone Number")
    * insert QuestionnaireItem(#string, "patient-info|phone-number", "Member phone #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Address")
    * insert QuestionnaireItem(#string, "patient-info|address", "Address")
* item[+]
  * insert QuestionnaireItem(#group, "provider-info", "Requesting Provider Information")
  * item[+]
    * insert QuestionnaireItem(#string, "provider-info|name", "Requesting provider name")
  * item[+]
    * insert QuestionnaireItem(#string, "provider-info|phone-number", "Phone")
  * item[+]
    * insert QuestionnaireItem(#string, "provider-info|address", "Ordering provider address")
  * item[+]
    * insert QuestionnaireItem(#string, "provider-info|npi", "Ordering provider Tax ID/NPI #")
  * item[+]
    * insert QuestionnaireItem(#string, "provider-info|fax", "Fax")
* item[+]
  * insert QuestionnaireItem(#group, "servicing-provider-laboratory-info", "Laboratory performing testing/Servicing Provider")
  * item[+]
    * insert QuestionnaireItem(#string, "servicing-provider-laboratory-info|name", "Requesting provider name")
  * item[+]
    * insert QuestionnaireItem(#string, "servicing-provider-laboratory-info|phone-number", "Phone")
  * item[+]
    * insert QuestionnaireItem(#string, "servicing-provider-laboratory-info|address", "Ordering provider address")
  * item[+]
    * insert QuestionnaireItem(#string, "servicing-provider-laboratory-info|npi", "Ordering provider Tax ID/NPI #")
  * item[+]
    * insert QuestionnaireItem(#string, "servicing-provider-laboratory-info|fax", "Fax")
* item[+]
  * insert QuestionnaireItem(#choice, "billing-provider-question", "Is the billing provider/referring lab different from servicing provider?")
  * answerOption[+]
    * valueCoding.code = #Y
    * valueCoding.display = "Yes"
  * answerOption[+]
    * valueCoding.code = #N
    * valueCoding.display = "No"
  * item[+]
    * insert QuestionnaireEnableWhenEqualsCoding("billing-provider-question", #Y)
    * insert QuestionnaireItem(#group, "billing-provider-info", "Billing provider/referring lab information")
    * item[+]
      * insert QuestionnaireItem(#string, "billing-provider-info|name", "Requesting provider name")
    * item[+]
      * insert QuestionnaireItem(#string, "billing-provider-info|phone-number", "Phone")
    * item[+]
      * insert QuestionnaireItem(#string, "billing-provider-info|address", "Ordering provider address")
    * item[+]
      * insert QuestionnaireItem(#string, "billing-provider-info|npi", "Ordering provider Tax ID/NPI #")
    * item[+]
      * insert QuestionnaireItem(#string, "billing-provider-info|fax", "Fax") 
* item[+]
  * insert QuestionnaireItem(#group, "test-requested", "Test requested")
  * item[+]
    * insert QuestionnaireItem(#date, "test-requested|service-date", "Date of service")
  * item[+]
    * insert QuestionnaireItem(#string, "test-requested|test-id", "Test ID")   
  * item[+]
    * insert QuestionnaireItem(#string, "test-requested|test-name", "Test name")     
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis Description")
    * insert QuestionnaireItem(#string, "test-requested|diagnosis-description", "Diagnosis description")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis ICD Codes")
    * insert QuestionnaireItemRepeats(#string, "test-requested|diagnosis-icd-code", "ICD-10 code(s\)")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis CPT Codes")
    * insert QuestionnaireItemRepeats(#string, "test-requested|diagnosis-cpt-code", "CPT code(s\)")
* item[+]
  * insert QuestionnaireItem(#group, "clinical-trial", "Clinical Trial Information")
  * item[+]
    * insert QuestionnaireItem(#choice, "clinical-trial-question", "Is the requested test part of a clinical trial?")
    * answerOption[+]
      * valueCoding.code = #Y
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #N
      * valueCoding.display = "No"
    * item[+]
      * insert QuestionnaireEnableWhenEqualsCoding("clinical-trial-question", #Y)
      * insert QuestionnaireItem(#string, "clinical-trial|yes-clinial-trial", "If Yes\, provide the registration or ID number for the specific trial in which this test is being studied.")
* item[+]
  * insert QuestionnaireItem(#group, "history", "Patient history and related findings")
  * item[+]
    * insert QuestionnaireItem(#string, "history|patient-history", "Patient history including age at diagnosis")
  * item[+]
    * insert QuestionnaireItem(#string, "history|family-history", "Family history\, including age at diagnosis\, availability for testing e.g.\, family member deceased\, refused testing or patient not in contact with affected family member and any genetic testing performed on family member - attach pedigree\, if available")
  * item[+]
    * insert QuestionnaireItem(#string, "history|other-findings", "Other findings/testing completed - previous genetic testing for condition")
  * item[+]
    * insert QuestionnaireItem(#string, "history|treatment-relation", "How will testing be used in relation to treatment or management of the patient?")
* item[+]
  * insert QuestionnaireItem(#group, "person-filling-out-form", "Person filling out form")
  * item[+]
    * insert QuestionnaireItem(#string, "person-filling-out-form|name", "Name")   
  * item[+]
    * insert QuestionnaireItem(#string, "person-filling-out-form|phone-number", "Phone number")
  * item[+]
    * insert QuestionnaireItem(#string, "person-filling-out-form|facility", "Phone number")  