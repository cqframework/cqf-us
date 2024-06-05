Alias: $UCUM = http://unitsofmeasure.org
Alias: $v2-0532 = https://terminology.hl7.org/CodeSystem-v2-0532
Alias: $providerRole = http://terminology.hl7.org/CodeSystem/v2-0443
Alias: $clm-fac-type-cd = https://bluebutton.cms.gov/assets/ig/CodeSystem-clm-fac-type-cd
Alias: $SCT = http://snomed.info/sct
Alias: $RequestPriority = http://hl7.org/fhir/request-priority

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
RuleSet: QuestionnaireItemUnit(code)
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * valueCoding = $UCUM#{code}
RuleSet: QuestionnaireEnableWhenEqualsCoding(question, coding)
* enableWhen[+]
  * question = {question}
  * operator = #=
  * answerCoding = {coding}
RuleSet: QuestionnaireUnitOption(code)
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unitOption"
  * valueCoding = $UCUM#{code}
RuleSet: QuestionnaireItemSignatureRequired(code, display)
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-signatureRequired"
  * valueCodeableConcept
    * coding
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