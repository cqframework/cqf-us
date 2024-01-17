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



Instance: MDOENQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* title = "Metabolic Disorders-Oral Enteral Nutrition Prior Authorization"
* status = #active
* date = "2024-01-17T00:00:00+00:00"
* publisher = "Smile Digital Health"
* description = "A questionnaire for expedited prior authorization of metabolic formula for clients 20 years of age and younger."

* item[+]
  * insert QuestionnaireItem(#group, "client-info", "Client Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Client Name")
    * insert QuestionnaireItem(#string, "client-info|name", "Client name")
  * item[+]  
    * insert QuestionnaireItemInitialExpression("Client ID")
    * insert QuestionnaireItem(#string, "client-info|id", "Client ID")

* item[+]
  * insert QuestionnaireItem(#group, "vendor-info", "Vendor Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Vendor Name")
    * insert QuestionnaireItem(#string, "vendor-info|name", "Vendor name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Vendor NPI")
    * insert QuestionnaireItem(#string, "vendor-info|npi", "Provider NPI")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Vendor Phone")
    * insert QuestionnaireItem(#string, "vendor-info|phone", "Vendor telephone number")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Vendor Fax")
    * insert QuestionnaireItem(#string, "vendor-info|fax", "Fax number")

* item[+]
  * insert QuestionnaireItem(#group, "service-request-info", "Service Request Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Requested Metabolic Product")
    * insert QuestionnaireItem(#string, "service-request-info|product", "Metabolic product requested")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Quantity of Metabolic Product")    
    * insert QuestionnaireItem(#decimal, "service-request-info|quantity", "Quantity in HCPCS units per day")
  * item[+]    
    * insert QuestionnaireItemInitialExpression("HCPCS code")
    * insert QuestionnaireItem(#string, "service-request-info|hcpcs-code", "HCPCS code")
  * item[+]    
    * insert QuestionnaireItemInitialExpression("Diagnosis")
    * insert QuestionnaireItem(#string, "service-request-info|diagnosis", "Medical diagnosis")
  * item[+]    
    * insert QuestionnaireItemInitialExpression("Diagnosis ICD-10 Code")
    * insert QuestionnaireItem(#string, "service-request-info|icd-code", "ICD 10 code")

* item[+]
  * insert QuestionnaireItem(#group, "prescriber-info", "Prescribing Provider Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Prescribing Provider Name")
    * insert QuestionnaireItem(#string, "prescriber-info|name", "Prescribing provider name")
  * item[+]  
    * insert QuestionnaireItemInitialExpression("Prescribing Provider Phone")
    * insert QuestionnaireItem(#string, "prescriber-info|phone", "Telephone number")
  * item[+]    
    * insert QuestionnaireItemInitialExpression("Prescribing Provider NPI")
    * insert QuestionnaireItem(#string, "prescriber-info|npi", "Provider NPI")