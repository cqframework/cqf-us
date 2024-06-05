Instance: MNACQuestionnaire
InstanceOf: Questionnaire
Usage: #example
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/cqf-library"
  * valueCanonical = "http://fhir.org/guides/cqf/us/common/Library/MNACInitialExpressions"
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
      * valueCoding
        * system = $v2-0532
        * code = #Y
        * display = "Yes"
    * answerOption[+]
      * valueCoding
        * system = $v2-0532
        * code = #N
        * display = "No"
  * item[+]
    * insert QuestionnaireItemInitialExpression("Lab Reports UTIs")
    * insert QuestionnaireEnableWhenEqualsCoding("uti-history|uti-last-year", $v2-0532#Y)
    * insert QuestionnaireItemRepeats(#string, "uti-history|uti-reports", "Lab reports of UTIs in the last year")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Dates of UTIs")
    * insert QuestionnaireEnableWhenEqualsCoding("uti-history|uti-last-year", $v2-0532#Y)
    * insert QuestionnaireItemRepeats(#string, "uti-history|uti-dates", "Dates of UTIs in the last year")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Antibiotics Used")
    * insert QuestionnaireEnableWhenEqualsCoding("uti-history|uti-last-year", $v2-0532#Y)
    * insert QuestionnaireItemRepeats(#string, "uti-history|antibiotics-used", "Antibiotics used for UTIs in the last year")

* item[+]
  * insert QuestionnaireItem(#group, "symptoms-info", "Symptoms Information")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Check Symptoms")
    * insert QuestionnaireItemRepeats(#choice, "symptoms-info|symptoms", "Check those that apply to your patient")
    * answerOption[+]
      * valueCoding = $SCT#386661006
    * answerOption[+]
      * valueCoding = MNAC#UrinaryUrgencyFrequency
    * answerOption[+]
      * valueCoding = MNAC#AutonomicDysreflexia
    * answerOption[+]
      * valueCoding = MNAC#PhysicalSignsProstatitis
    * answerOption[+]
      * valueCoding = MNAC#Immunosuppressed
    * answerOption[+]
      * valueCoding = MNAC#Pyuria
    * answerOption[+]
      * valueCoding = MNAC#SystemicLeukocytosis
  * item[+]
    * insert QuestionnaireItemInitialExpression("Fever Temperature")
    * insert QuestionnaireEnableWhenEqualsCoding("symptoms-info|symptoms", $SCT#386661006)
    * insert QuestionnaireItem(#decimal, "symptoms-info|fever-temperature", "If fever\, state temperature in degrees Fahrenheit")
    * insert QuestionnaireItemUnit([degF])
* item[+]
  * insert QuestionnaireItem(#group, "catheterization-frequency", "Catheterization Frequency")
  * item[+]
    * insert QuestionnaireItemInitialExpression("Catheterization Frequency")
    * insert QuestionnaireItem(#choice, "catheterization-frequency|frequency", "How many times per day does the patient catheterize?")
    * answerOption[+]
      * valueCoding = MNAC#2-4Times
    * answerOption[+]
      * valueCoding = MNAC#4-6Times
    * answerOption[+]
      * valueCoding = MNAC#6-8Times
    * answerOption[+]
      * valueCoding = MNAC#8TimesOrMore

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

