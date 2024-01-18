library MNACInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
codesystem "ICD10": 'http://hl7.org/fhir/sid/icd-10-cm'

code "Member Number": 'MB' from "Identifier Type"
code "Infection and inflammatory reaction due to prosthetic device, implant and graft in urinary system": 'T83.5' from "ICD10"

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

define "UTI in Last Year":
null

define "Dates of UTIs":
null

define "Antibiotics Used":
null

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
  

define "UTI by Catheterization Past 12 Months":
  [FHIR.Condition] C
  return "Infection and inflammatory reaction due to prosthetic device, implant and graft in urinary system" in C.code.coding
  