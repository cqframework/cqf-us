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


Instance: GeneralInformationQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* url = "http://example.org/fhir/Questionnaire/GeneralInformationQuestionnaire"
* name = "GeneralInformationQuestionnaire"
* title = "General Information for Authorization"
* status = #draft
* date = "2024-02-15"
* publisher = "Smile Digital Health"
* description = "A questionnaire representing a general information prior authorization form."

* item[+]
  * insert QuestionnaireItem(#group, "general-info", "General Information for Authorization")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Organization")
    * insert QuestionnaireItem(#string, "general-info|org", "Org")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Service Type")
    * insert QuestionnaireItem(#string, "general-info|service-type", "Service Type")
* item[+]
  * insert QuestionnaireItem(#group, "client-info", "Client Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Client Name")
    * insert QuestionnaireItem(#string, "client-info|name", "Name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Client ID")
    * insert QuestionnaireItem(#string, "client-info|client-id", "Client ID")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Living Arrangements")
    * insert QuestionnaireItem(#string, "client-info|living-arrangements", "Living Arrangements")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Reference Authorization Number")
    * insert QuestionnaireItem(#integer, "client-info|reference-auth", "Reference Auth #")
* item[+]
  * insert QuestionnaireItem(#group, "provider-info", "Provider Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Requesting NPI")
    * insert QuestionnaireItem(#integer, "provider-info|requesting-npi", "Requesting NPI #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Billing NPI")
    * insert QuestionnaireItem(#integer, "provider-info|billing-npi", "Billing NPI #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Referring NPI")
    * insert QuestionnaireItem(#string, "provider-info|referring-npi", "Referring NPI #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Requesting Fax Number")
    * insert QuestionnaireItem(#string, "provider-info|requesting-fax", "Requesting Fax #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Provider Name")
    * insert QuestionnaireItem(#string, "provider-info|name", "Name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Referring Fax Number")
    * insert QuestionnaireItem(#string, "provider-info|referring-fax", "Referring Fax #")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Service Start Date")
    * insert QuestionnaireItem(#date, "provider-info|service-start-date", "Service Start Date")
* item[+]
  * insert QuestionnaireItem(#group, "service-request-info", "Service Request Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Description of Service")
    * insert QuestionnaireItem(#string, "service-request-info|description-of-service", "Description of service being requested")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Serial Number or MEA Number")
    * insert QuestionnaireItem(#integer, "service-request-info|serial-mea-number", "Serial/NEA or MEA #")
* item[+]
  * insert QuestionnaireItemRepeats(#group, "service-request-info-repeat", "Service Request Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Code Qualifier")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|code-qualifier", "Code Qualifier")
  * item[+]
    * insert QuestionnaireItemInitialExpression("National Code")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|national-code", "National Code")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Modifier")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|mod", "Mod")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Units or Days Requested")
    * insert QuestionnaireItem(#integer, "service-request-info-repeat|units-days-requested", "# Units/Days Requested")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Dollar Amount Requested")
    * insert QuestionnaireItem(#decimal, "service-request-info-repeat|amount-requested", "$ Amount Requested")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Part Number")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|part-number", "Part # - DME Only")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Tooth or Quadrant Number")
    * insert QuestionnaireItem(#string, "service-request-info-repeat|tooth-quad-number", "Tooth or Quad #")
* item[+]
  * insert QuestionnaireItem(#group, "medical-info", "Medical Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis Code")
    * insert QuestionnaireItem(#string, "medical-info|diagnosis-code", "Diagnosis Code")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis Name")
    * insert QuestionnaireItem(#string, "medical-info|diagnosis-name", "Diagnosis name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Place of Service Code")
    * insert QuestionnaireItem(#string, "medical-info|place-of-service-code", "Place of Service Code")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Comments")
    * insert QuestionnaireItem(#text, "medical-info|comments", "Comments:")
