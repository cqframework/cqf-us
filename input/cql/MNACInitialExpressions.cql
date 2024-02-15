library MNACInitialExpressions version '0.1.0'

//https://www.hca.wa.gov/assets/billers-and-providers/13-760.pdf

using FHIR version '4.0.1'
using USCore version '3.1.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
codesystem "ICD10": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "SNOMED CT": 'http://snomed.info/sct'

code "Member Number": 'MB' from "Identifier Type"
code "UTI": 'T83.5' from "ICD10"
code "Abnormal Urine Finding": '102866000' from "SNOMED CT"

context Patient

define "Date of Request":
UCE."Most Recent Medication Request".authoredOn

//assuming that client id is the coverage member id
define "Client ID":
  singleton from
    (
      (
        (
          ([FHIR.Coverage] C 
              where EndsWith(C.beneficiary.reference, Patient.id))
          .identifier) I
        return {value: I.value.value, type: I.type.coding.code}
      ) valuesByTypes
    where "Member Number".code in valuesByTypes.type
    return valuesByTypes.value
    )

define "Patient Name":
  UCE."Name - First Middle(s) Last"

define "Diagnosis":
First("SR Related Condition".code).text.value

define "Item Requested":
null
//Service Request?

define "UTI in Last Year":
Exists("UTI Diagnostic Reports Last Year")

define "Lab Reports UTIs":
"UTI Diagnostic Reports Last Year".presentedForm

define "Dates of UTIs":
"UTI Diagnostic Reports Last Year".effective.value

define "Antibiotics Used":
[FHIR.MedicationStatement] MS
//TODO
//where MS.reasonReference in "UTI Diagnostic Reports Last Year"
//MedicationStatement with reasonReference DiagnosticReport

define "Check Symptoms":
null

define "Fever Temperature":
null

define "Catheterization Frequency":
null

define "Additional Comment":
null

define "Physician’s Name":
null

define "Physician’s Telephone":
null

define "Physician’s Fax":
null

define "Referring Physician’s Telephone":
null

define "Date":
null

//helper definitions
define "All ServiceRequests":
  [FHIR.ServiceRequest]

define "Most Recent ServiceRequest":
  UC.MostRecentSR("All ServiceRequests")

define "SR Related Condition":
  [FHIR.Condition] C
  where EndsWith(First("Most Recent ServiceRequest".reasonReference.reference.value), C.id)
  
define "SR Condition Coding":
"UTI" in "SR Related Condition".code.coding

define "UTI by Catheterization Past 12 Months":
 "UTI" in "SR Related Condition".code.coding

define "UTI Diagnostic Reports Last Year":
  [FHIR.DiagnosticReport] C
  where "Abnormal Urine Finding".code in C.conclusionCode.coding.code
  and C.effective	> (Today() - 1 year)