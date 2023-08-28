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

define "Most Recent BSA":
  convert( 
    UC.MostRecent(
      ([FHIR.Observation: "Body surface area"] observation
        where observation.status ~ UC."observation-final".code
          or observation.status ~ UC."observation-amended".code
          or observation.status ~ UC."observation-corrected".code
      )
    ).value 
  ) to 'm2'

define "BSA":
  Coalesce("Most Recent BSA", "Calculated BSA - Mosteller")

// Mosteller formula using lbs and inches
define "Calculated BSA - Mosteller":
  CalculateBSA('Mosteller', "Height", "Weight")
  //((("Weight"*"Height")/3131).value)^0.5

define "Height in cm":
  convert("Height") to 'cm'

define "Weight in kg":
  convert("Weight") to 'kg'

define "Calculated BSA - DuBois and DuBois":
  CalculateBSA('DuBois and DuBois', "Height", "Weight")

define function CalculateBSA(alg System.String, height System.Quantity, weight System.Quantity):
  System.Quantity { value: 
    // Mosteller formula using lbs and inches
    if (alg = 'Mosteller') then
      ((((convert(height) to '[in_i]') * (convert(weight) to '[lb_av]'))/3131).value)^0.5
    
    // DuBois and DuBois formula using cm and kg
    // NOTE: never to be used for newborn calculation
    else if (alg = 'DuBois and DuBois') then
      0.007184 * ((convert(height) to 'cm').value^0.725) * ((convert(weight) to 'kg').value^0.425)
    
    // No matching algorithm found
    else null,
    unit: 'm2'
  }

define "Birth Sex":
 Patient.birthsex

define "Diagnosis Codes":
  UCE."All Conditions" C
    return C.code

define "Diagnosis Descriptions":
  UCE."All Conditions" C
    return C.code.display

// TODO: Error: Could not resolve call to operator 'ToValue(org.hl7.fhir.r4.model.CodeableConcept)' in library 'FHIRHelpers'.
define "Medication Name":
  UCE."All Medications" M
    return M.id
    //where M.id = "Most Recent Medication Request".medication.reference
    //return M.code.display

define "Medication Request References":
  ("Most Recent Medication Request".medication) // as USCore.Reference).reference
  
define "Most Recent Medication Request":
  UC.MostRecent(UCE."All Medication Requests")
  
define "Medication Dose":
  "Most Recent Medication Request".dosageInstruction.doseAndRate.dose

define "Medication Route":
  "Most Recent Medication Request".dosageInstruction.route

define "Medication Frequency":
  "Most Recent Medication Request".dosageInstruction.doseAndRate.rate

define "Quantity or Number of requested Visits":
  "Most Recent Medication Request".dispenseRequest.quantity

define "New therapy":
  ("Most Recent Medication Request".priorPrescription) is not null

//Initial date of therapy does not return correct result if there have been more than 1 prior Prescriptions - logic needs to be adapted to that case
define "Initial date of therapy":
  if not "New therapy" then
    UCE."All Medication Requests" M
    where M.id = "Most Recent Medication Request".priorPrescription.reference
    return M.authoredOn
  else 
    null

// define "Test":
//   CMD."TestFunction"("Most Recent Medication Request")

/*
define "Medication Request Period":
  CMD."MedicationRequestPeriod"("Most Recent Medication Request")

// define "Expected Therapy Length":
//   convert(
//     CMD.Quantity(days between start of "Medication Request Period" and end of "Medication Request Period", 'days')
//   ) to 'days'
  
// define "Anticipated/actual date of service":
//   start of "Medication Request Period"

// TODO: Error: Could not resolve call to operator 'ToValue(org.hl7.fhir.r4.model.CodeableConcept)' in library 'FHIRHelpers'.
// define "Code of Requested Drug":
//   UCE."All Medications" M
//     where M.id = "Most Recent Medication Request".medication.reference
//       return M.code

/*
//related Procedures - Procedure is not linked to medication request - not possible to find the related procedures

*/