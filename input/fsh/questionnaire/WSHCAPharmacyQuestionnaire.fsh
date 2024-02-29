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


Instance: PharmacyPriorAuthQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* url = "http://example.org/fhir/Questionnaire/PharmacyPriorAuth"
* name = "PharmacyQuestionnaire"
* title = "Pharmacy Prior Authorization Form"
* status = #draft
* date = "2024-02-15"
* publisher = "Smile Digital Health"
* description = "A questionnaire representing a pharmacy prior authorization form."

// General Information Section
* item[+]
  * insert QuestionnaireItem(#group, "general-info", "General Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Organization")
    * insert QuestionnaireItem(#string, "general-info|org", "Org")
  * item[+]
    * insert QuestionnaireItemInitialExpression("AuthorizationType")
    * insert QuestionnaireItem(#string, "general-info|auth-type", "Authorization Type")

// Client Information Section
* item[+]
  * insert QuestionnaireItem(#group, "client-info", "Client Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Client Name")
    * insert QuestionnaireItem(#string, "client-info|name", "Name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Client ID")
    * insert QuestionnaireItem(#string, "client-info|client-id", "Client ID")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Reference Authorization Number")
    * insert QuestionnaireItem(#string, "client-info|reference-auth", "Reference Auth #")

// Provider Information Section
* item[+]
  * insert QuestionnaireItem(#group, "provider-info", "Provider Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Pharmacy NPI")
    * insert QuestionnaireItem(#string, "provider-info|pharmacy-npi", "Pharmacy NPI #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Prescriber NPI")
    * insert QuestionnaireItem(#string, "provider-info|prescriber-npi", "Prescriber NPI #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Pharmacy Fax Number")
    * insert QuestionnaireItem(#string, "provider-info|pharmacy-fax", "Pharmacy Fax #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Prescriber Specialty")
    * insert QuestionnaireItem(#string, "provider-info|prescriber-specialty", "Prescriber Specialty")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Prescriber Phone Number")
    * insert QuestionnaireItem(#string, "provider-info|prescriber-phone", "Prescriber Phone #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Prescriber Fax Number")
    * insert QuestionnaireItem(#string, "provider-info|prescriber-fax", "Prescriber Fax #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Date Of Fill")
    * insert QuestionnaireItem(#date, "provider-info|date-of-fill", "Date of Fill:")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Dispense As Written")
    * insert QuestionnaireItem(#choice, "service-request-info|dispense-as-written", "Dispense as Written Yes/No")
    * answerOption[+]
      * valueCoding.code = #Yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #No
      * valueCoding.display = "No"

// Service Request Information Section
* item[+]
  * insert QuestionnaireItem(#group, "service-request-info", "Service Request Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Drug Name Strength And Form")
    * insert QuestionnaireItem(#string, "service-request-info|drug-name-strength-form", "Drug Name\, Strength and Form:")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Actual Per Unit Cost")
    * insert QuestionnaireItem(#decimal, "service-request-info|actual-per-unit-cost", "Actual per unit cost")
  * item[+]
    * insert QuestionnaireItemInitialExpression("AWP Per Unit Cost")
    * insert QuestionnaireItem(#decimal, "service-request-info|awp-per-unit-cost", "AWP per unit cost")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Wholesaler")
    * insert QuestionnaireItem(#string, "service-request-info|wholesaler", "Wholesaler")
  * item[+]  
    * insert QuestionnaireItemInitialExpression("Prescription Number")
    * insert QuestionnaireItem(#string, "service-request-info|rx-number", "RX#")
* item[+]
  * insert QuestionnaireItemRepeats(#group, "service-request-info-repeat", "Service Request Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Code Qualifier")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|code-qualifier", "Code Qualifier")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Product ID")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|product-id", "Product ID")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Quantity")
    * insert QuestionnaireItem(#integer, "service-request-info-repeat|quantity", "Qty")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Days Supply")
    * insert QuestionnaireItem(#integer, "service-request-info-repeat|days-supply", "Days Supply")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Directions For Use")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|directions-for-use", "Directions for Use SIG")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Product Selection Code")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|product-selection-code", "Prod Select Cd")

// Medical Information Section
* item[+]
  * insert QuestionnaireItem(#group, "medical-info", "Medical Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis Code")
    * insert QuestionnaireItem(#string, "medical-info|diagnosis-code", "Diagnosis Code")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis Name")
    * insert QuestionnaireItem(#string, "medical-info|diagnosis-name", "Diagnosis name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Patient Residence")
    * insert QuestionnaireItem(#string, "medical-info|patient-residence", "Patient Residence")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Comments")
    * insert QuestionnaireItem(#text, "medical-info|comments", "Comments:")