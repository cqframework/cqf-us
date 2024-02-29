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

Instance: CornealCrossLinkingQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* url = "http://example.org/fhir/Questionnaire/CornealCrossLinkingQuestionnaire"
* name = "CornealCrossLinkingQuestionnaire"
* title = "Corneal Cross-linking Prior Authorization Form"
* status = #active
* experimental = true
* date = "2024-02-29"
* publisher = "Smile Digital Health"

* item[+]
  * insert QuestionnaireItem(#group, "clinician-info", "To be completed by clinician")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Contact name")
    * insert QuestionnaireItem(#string, "clinician-info|contact-name", "Contact name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Phone number")
    * insert QuestionnaireItem(#string, "clinician-info|phone-number", "Phone number xxx-xxx-xxxx")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Fax number")
    * insert QuestionnaireItem(#string, "clinician-info|fax-number", "Fax number xxx-xxx-xxxx")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Provider name")
    * insert QuestionnaireItem(#string, "clinician-info|provider-name", "Provider name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Provider NPI number")
    * insert QuestionnaireItem(#string, "clinician-info|provider-npi", "Provider NPI number")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Clinician contact")
    * insert QuestionnaireItem(#string, "clinician-info|contact", "Clinician contact")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Clinician phone number")
    * insert QuestionnaireItem(#string, "clinician-info|phone", "Clinician phone number xxx-xxx-xxxx")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Clinician fax number")
    * insert QuestionnaireItem(#string, "clinician-info|fax", "Clinician fax number xxx-xxx-xxxx") 
  * item[+]
    * insert QuestionnaireItemInitialExpression("Client name")
    * insert QuestionnaireItem(#string, "clinician-info|client-name", "Client name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Client ID")
    * insert QuestionnaireItem(#string, "clinician-info|client-id", "Client ID")

* item[+]
  * insert QuestionnaireItem(#group, "corneal-info", "Corneal Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Is the patient pregnant?")
    * insert QuestionnaireItem(#choice, "corneal-info|patient-pregnant", "Is the patient pregnant?")
    * answerOption[+]
      * valueCoding.code = #yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #no
      * valueCoding.display = "No"
    * answerOption[+]
      * valueCoding.code = #na
      * valueCoding.display = "N/A"
  * item[+]
    * insert QuestionnaireItemInitialExpression("Corneal thickness")
    * insert QuestionnaireItem(#decimal, "corneal-info|corneal-thickness", "Corneal thickness at thinnest point - microns")
  * item[+]
    * insert QuestionnaireItem(#decimal, "corneal-info|visual-acuity-os", "Best corrected visual acuity OS")
    * insert QuestionnaireItemInitialExpression("Best corrected visual acuity OS in LogMAR")
  * item[+]
    * insert QuestionnaireItem(#decimal, "corneal-info|visual-acuity-od", "Best corrected visual acuity OD")
    * insert QuestionnaireItemInitialExpression("Best corrected visual acuity OD in LogMAR")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Keratometry increase in last 12 months")
    * insert QuestionnaireItem(#choice, "corneal-info|keratometry-increase", "In the last 12 mo has the patient had an increase of 1 diopter or more in the steepest keratometry measurement?")
    * answerOption[+]
      * valueCoding.code = #yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #no
      * valueCoding.display = "No"    
    * item[+]
      * insert QuestionnaireEnableWhenEqualsCoding("corneal-info|keratometry-increase", #yes)
      * insert QuestionnaireItemRepeats(#group, "corneal-info|keratometry-increases", "Keratometry Increases")
      * item[+]
        * insert QuestionnaireItemInitialExpression("Date of keratometry increase")
        * insert QuestionnaireItem(#date, "corneal-info|keratometry-increases|date", "Date of increase")
      * item[+]
        * insert QuestionnaireItemInitialExpression("Diopter measurement of keratometry increase")
        * insert QuestionnaireItem(#decimal, "corneal-info|keratometry-increases|diopter", "Diopter measurement")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Astigmatism increase in last 12 months")
    * insert QuestionnaireItem(#choice, "corneal-info|astigmatism-increase", "In last 12 mo has the patient had an increase of 1 diopter or more in astigmatism?")
    * answerOption[+]
        * valueCoding.code = #yes
        * valueCoding.display = "Yes"
    * answerOption[+]
        * valueCoding.code = #no
        * valueCoding.display = "No"
  * item[+]
    * insert QuestionnaireEnableWhenEqualsCoding("corneal-info|astigmatism-increase", #yes)
    * insert QuestionnaireItemRepeats(#group, "corneal-info|astigmatism-increases", "Astigmatism Increases")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Date of astigmatism increase")
      * insert QuestionnaireItem(#date, "corneal-info|astigmatism-increases|date", "Date of increase")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Diopter measurement of astigmatism increase")
      * insert QuestionnaireItem(#decimal, "corneal-info|astigmatism-increases|diopter", "Diopter measurement")

  * item[+]
    * insert QuestionnaireItemInitialExpression("Myopic shift in last 12 months")
    * insert QuestionnaireItem(#choice, "corneal-info|myopic-shift", "In last 12 mo has the patient had a myopic shift of 0.5 diopter on subjective manifest refraction?")
    * answerOption[+]
        * valueCoding.code = #yes
        * valueCoding.display = "Yes"
    * answerOption[+]
        * valueCoding.code = #no
        * valueCoding.display = "No"
  * item[+]
    * insert QuestionnaireEnableWhenEqualsCoding("corneal-info|myopic-shift", #yes)
    * insert QuestionnaireItemRepeats(#group, "corneal-info|myopic-shifts", "Myopic Shifts")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Date of myopic shift")
      * insert QuestionnaireItem(#date, "corneal-info|myopic-shifts|date", "Date of shift")
    * item[+]
      * insert QuestionnaireItemInitialExpression("Diopter measurement of myopic shift")
      * insert QuestionnaireItem(#decimal, "corneal-info|myopic-shifts|diopter", "Diopter measurement")
