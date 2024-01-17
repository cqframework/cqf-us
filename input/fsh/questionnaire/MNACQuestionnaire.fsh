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

Instance: MNACQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/cqf-library"
  * valueCanonical = "http://fhir.org/guides/cqf/us/common/Library/MNACQuestionnaire"
* url = "http://fhir.org/guides/cqf/us/common/Questionnaire/MNACQuestionnaire"
* version = "0.1.0"
* name = "MNACQuestionnaire"
* title = "Medical Necessity For Authorization Of Catheters"
* status = #active
* experimental = true
* date = "2024-01-17T00:00:00+00:00"
* publisher = "Smile Digital Health"
* description = "The Health Care Authority requires this form for all clients requesting sterile closed catheter."
* item[+]
  * insert QuestionnaireItem(#group, "request-info", "Request Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Date of Request")
    * insert QuestionnaireItem(#date, "request-info|date-of-request", "DATE OF REQUEST")
  * item[+]  
    * insert QuestionnaireItemInitialExpression("Client ID")
    * insert QuestionnaireItem(#string, "request-info|client-id", "CLIENT ID")

* item[+]
  * insert QuestionnaireItem(#group, "patient-info", "Patient Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Patient Name")
    * insert QuestionnaireItem(#string, "patient-info|name", "PATIENT NAME")

* item[+]
  * insert QuestionnaireItem(#group, "diagnosis-info", "Diagnosis Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Diagnosis")
    * insert QuestionnaireItem(#string, "diagnosis-info|diagnosis", "Diagnosis")

* item[+]
  * insert QuestionnaireItem(#group, "item-requested", "Item Requested")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Item Requested")
    * insert QuestionnaireItem(#string, "item-requested|item", "Item requested")

* item[+]
  * insert QuestionnaireItem(#group, "uti-history", "UTI History")
  * item[+]
    * insert QuestionnaireItemInitialExpression("UTI in Last Year")
    * insert QuestionnaireItem(#choice, "uti-history|uti-last-year", "The patient has|had documented recurrent urinary tract infections while on a program of clean cathing\, twice within a 12 month period prior to beginning sterile cathing")
    * answerOption[+]
      * valueCoding.code = #Yes
      * valueCoding.display = "Yes"
    * answerOption[+]
      * valueCoding.code = #No
      * valueCoding.display = "No"
    
  * item[+]
    * insert QuestionnaireItemInitialExpression("Dates of UTIs")
    * insert QuestionnaireEnableWhenEqualsCoding("uti-history|uti-last-year", #true)
    * insert QuestionnaireItem(#string, "uti-history|uti-dates", "Dates of UTIs in the last year")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Antibiotics Used")
    * insert QuestionnaireEnableWhenEqualsCoding("uti-history|uti-last-year", #true)
    * insert QuestionnaireItem(#string, "uti-history|antibiotics-used", "Antibiotics used for UTIs in the last year")

* item[+]
  * insert QuestionnaireItem(#group, "symptoms-info", "Symptoms Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Check Symptoms")
    * insert QuestionnaireItemRepeats(#choice, "symptoms-info|symptoms", "Check those that apply to your patient")
    * answerOption[+]
      * valueCoding.code = #Fever
      * valueCoding.display = "Fever; state temperature in degree"
    * answerOption[+]
      * valueCoding.code = #UrinaryUrgencyFrequency
      * valueCoding.display = "Change in urinary urgency, frequency, or incontinence"
    * answerOption[+]
      * valueCoding.code = #AutonomicDysreflexia
      * valueCoding.display = "Appearance of new or increase in autonomic dysreflexia"
    * answerOption[+]
      * valueCoding.code = #PhysicalSignsProstatitis
      * valueCoding.display = "Physical signs of prostatitis, epididymitis, orchitis"
    * answerOption[+]
      * valueCoding.code = #Immunosuppressed
      * valueCoding.display = "The patient is immunosuppressed"
    * answerOption[+]
      * valueCoding.code = #Pyuria
      * valueCoding.display = "Pyuria"
    * answerOption[+]
      * valueCoding.code = #SystemicLeukocytosis
      * valueCoding.display = "Systemic leukocytosis"
  * item[+]
    * insert QuestionnaireItemInitialExpression("Fever Temperature")
    * insert QuestionnaireEnableWhenEqualsCoding("symptoms-info|symptoms", #Fever)
    * insert QuestionnaireItem(#decimal, "symptoms-info|fever-temperature", "If fever\, state temperature in degrees")
    * insert QuestionnaireItemUnit(#[deg], "deg")
* item[+]
  * insert QuestionnaireItem(#group, "catheterization-frequency", "Catheterization Frequency")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Catheterization Frequency")
    * insert QuestionnaireItem(#choice, "catheterization-frequency|frequency", "How many times per day does the patient catheterize?")
    * answerOption[+]
      * valueCoding.code = #2-4Times
      * valueCoding.display = "2-4 times"
    * answerOption[+]
      * valueCoding.code = #4-6Times
      * valueCoding.display = "4-6 times"
    * answerOption[+]
      * valueCoding.code = #6-8Times
      * valueCoding.display = "6-8 times"
    * answerOption[+]
      * valueCoding.code = #8TimesOrMore
      * valueCoding.display = "8 times or more"

* item[+]
  * insert QuestionnaireItem(#group, "additional-comments", "Additional Comments")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Additional Comment")
    * insert QuestionnaireItem(#string, "additional-comments|comments", "Additional Comment")

* item[+]
  * insert QuestionnaireItem(#group, "physician-info", "Physician Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Physician's Name")
    * insert QuestionnaireItem(#string, "physician-info|name", "Physician’s Name")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Physician's Telephone")
    * insert QuestionnaireItem(#string, "physician-info|phone", "Telephone")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Physician's Fax")
    * insert QuestionnaireItem(#string, "physician-info|fax", "FAX")
  * item[+]
    * insert QuestionnaireItem(#attachment, "physician-info|signature", "Physician’s Signature")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Referring Physician's Telephone")
    * insert QuestionnaireItem(#string, "physician-info|phone", "Referring Physician Telephone")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Date")
    * insert QuestionnaireItem(#string, "physician-info|date", "Date")

