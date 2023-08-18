library MBODAInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' 
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE
include OfficialName version '0.1.0' called OfficialName

//CumulativeMedicationDuration was created as part of the US ECQM and CDC Opioid Guideline development 
//http://fhir.org/guides/cdc/opioid-mme-r4
include CumulativeMedicationDuration version '3.1.000' called CMD

codesystem "LOINC": 'http://loinc.org'
code "Body surface area": '8277-6' from "LOINC" display 'Intensive care unit'

context Patient

define "Member ID":
  [FHIR.Coverage] C
  where C.subscriber.reference = Patient.id
  return C.subscriberId

define "Patient Name":
  OfficialName."Name - First Middle(s) Last"


define "Last Name":
  Patient.name.family

// TODO: Error: Could not resolve data provider for package 'java.util'.
// define "First Name":
//   Patient.name.given.first()
  
define "Date of Birth":
  Patient.birthDate

define "Medical Record Number":
  Patient.identifier[1].value

define "Phone Number":
  UC.Mobile(Patient.telecom) 

define "Allergies":
  UCE."Active Confirmed Allergies and Intolerances" A
    return A.code

// TODO: Error: Could not resolve data provider for package 'java.util'.
// define "Address":
//   Patient.address.line

define "City":
  Patient.address.city

define "State":
  Patient.address.state

define "Zip":
  Patient.address.postalCode

define "Height":
  convert(
    UC.MostRecent(
      UCE."All Body Height Measurements".resulted()
    ).value 
  ) to '[in_i]'


define "Weight":
  convert(
    UC.MostRecent(
      UCE."All Body Weight Measurements".resulted()
    ).value 
  ) to '[lb_av]'


// TODO: Move this to USCoreCommon.cql
// TODO: Resolve error in USCoreCommon.cql when adding "using FHIR version '4.0.1'"
define function MostRecent(observations List<Observation>):
  Last(
    observations O
      sort by issued
  )

define "Most Recent BSA":
  convert( 
    MostRecent(
      ([FHIR.Observation: "Body surface area"] observation
        where observation.status ~ UC."observation-final".code
          or observation.status ~ UC."observation-amended".code
          or observation.status ~ UC."observation-corrected".code
      )
    ).value 
  ) to 'm2'

define "BSA":
  Coalesce("Most Recent BSA", "Calculated BSA")

define "Calculated BSA":
  ((("Weight"*"Height")/3131).value)^0.5

define "Birth Sex":
 Patient.birthsex 

define "Diagnosis Codes":
  UCE."All Conditions" C
    return C.code

define "Diagnosis Descriptions":
  UCE."All Conditions" C
    return C.code.display

// TODO: Error: Could not resolve call to operator 'ToValue(org.hl7.fhir.r4.model.CodeableConcept)' in library 'FHIRHelpers'.
// define "Medication Name":
//   UCE."All Medications" M
//   where M.id = UC.MostRecent(UCE."All Medication Requests").medication.reference
//     return M.code.display
  
  
define "Medication Dose":
  UC.MostRecent(UCE."All Medication Requests").dosageInstruction.doseAndRate.dose

define "Medication Route":
  UC.MostRecent(UCE."All Medication Requests").dosageInstruction.route

define "Medication Frequency":
  UC.MostRecent(UCE."All Medication Requests").dosageInstruction.doseAndRate.rate

define "Quantity or Number of requested Visits":
  UC.MostRecent(UCE."All Medication Requests").dispenseRequest.quantity

define "New therapy":
  (UC.MostRecent(UCE."All Medication Requests").priorPrescription) is not null

//Initial date of therapy does not return correct result if there have been more than 1 prior Prescriptions - logic needs to be adapted to that case
define "Initial date of therapy":
  if not "New therapy" then
    UCE."All Medication Requests" M
    where M.id = UC.MostRecent(UCE."All Medication Requests").priorPrescription.reference
    return M.authoredOn
  else 
    null

define "Medication Request Period":
  CMD."MedicationRequestPeriod"(UC.MostRecent(UCE."All Medication Requests"))

// define "Expected Therapy Length":
//   convert(
//     CMD.Quantity(days between start of "Medication Request Period" and end of "Medication Request Period", 'days')
//   ) to 'days'
  
// define "Anticipated/actual date of service":
//   start of "Medication Request Period"

// TODO: Error: Could not resolve call to operator 'ToValue(org.hl7.fhir.r4.model.CodeableConcept)' in library 'FHIRHelpers'.
// define "Code of Requested Drug":
//   UCE."All Medications" M
//     where M.id = UC.MostRecent(UCE."All Medication Requests").medication.reference
//       return M.code

/*
//related Procedures - Procedure is not linked to medication request - not possible to find the related procedures

*/