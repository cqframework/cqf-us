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

// MISSING: needs test data to validate
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
  singleton from 
  (
    (Patient.identifier I
      return {value: I.value, type: I.type.codes.code}
    ) valueByTypes
    // TODO: create code for MR (medical record number)
    where UC."MedicalRecordNumber".code in valueByTypes.type
    return valueByTypes.value
  )

define "Phone Number":
  UC.Mobile(Patient.telecom).value

// MISSING: needs test data to validate
define "Allergies":
  UCE."Active Confirmed Allergies and Intolerances" A
    return A.code

// TODO: Error: Could not resolve data provider for package 'java.util'.
// define "Address":
//   (singleton from Patient.address) //.line
define "Address":
  { 'TODO: remove hard-coded address' }

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

define "Height in [in_i]":
  "Height".value

define "Weight":
  convert(
    UC.MostRecent(
      UCE."All Body Weight Measurements".resulted()
    ).value 
  ) to '[lb_av]'

define "Weight in [lb_av]":
  "Weight".value

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

define "BSA in m2":
  "BSA".value

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
  "Diagnosis Codes" ConceptItem
    return Combine(((ConceptItem.codes) C return C.display), '|')

// TODO: Error: Could not resolve call to operator 'ToValue(org.hl7.fhir.r4.model.Reference)' in library 'FHIRHelpers'.
// define "Medication Name":
//   UCE."All Medications" M
//   //TODO: Error: Could not resolve call to operator 'ToValue(org.hl7.fhir.r4.model.Reference)' in library 'FHIRHelpers'.
//     where M.id = "Most Recent Medication Request".medication.reference
//     return M.code.display

define "Most Recent Medication Request":
  UC.MostRecent(UCE."All Medication Requests")

// TODO: Error: java.lang.NullPointerException: Cannot invoke "java.lang.Class.getName()" because the return value of "org.opencds.cqf.cql.engine.execution.Context.resolveType(Object)" is null
// define "Medication Request References":
//   ("Most Recent Medication Request".medication as USCore.Reference).reference

// MISSING: needs test data to validate
define "Most Recent Medication Request dosageInstruction":
  // TODO: should this really be a singleton?
  singleton from "Most Recent Medication Request".dosageInstruction

// MISSING: needs test data to validate
define "Most Recent Medication Request dosageInstruction.doseAndRate":
  // TODO: should this really be a singleton?
  singleton from "Most Recent Medication Request dosageInstruction".doseAndRate

// TODO: Error: java.lang.NullPointerException: Cannot invoke "java.lang.Class.getName()" because the return value of "org.opencds.cqf.cql.engine.execution.Context.resolveType(Object)" is null
// define "Medication Dose":
//   "Most Recent Medication Request dosageInstruction.doseAndRate".dose

// MISSING: needs test data to validate
define "Medication Route":
  "Most Recent Medication Request dosageInstruction".route

// TODO: Error: java.lang.NullPointerException: Cannot invoke "java.lang.Class.getName()" because the return value of "org.opencds.cqf.cql.engine.execution.Context.resolveType(Object)" is null
// define "Medication Frequency Rate":
//   "Most Recent Medication Request dosageInstruction.doseAndRate".rate

// MISSING: needs test data to validate
define "Medication Frequency value":
  "Most Recent Medication Request dosageInstruction".timing.repeat.frequency

// MISSING: needs test data to validate
define "Medication Frequency Period":
  System.Quantity {
    value: "Most Recent Medication Request dosageInstruction".timing.repeat.period,
    unit: "Most Recent Medication Request dosageInstruction".timing.repeat.periodUnit
  }

// MISSING: needs test data to validate
define "Medication Frequency String": // '1x per 1d', '3x per 2wk', '1x per 1mo'
  ToString("Medication Frequency value") + 'x' +
  ' per ' + ToString("Medication Frequency Period".value) + 
  ' ' + "Medication Frequency Period".unit

define "Quantity or Number of requested Visits":
  "Most Recent Medication Request".dispenseRequest.quantity

// MISSING: needs test data to validate
define "New therapy":
  ("Most Recent Medication Request".priorPrescription) is not null

define "New therapy code":
  if ("New therapy") then
    System.Code { code: 'NewMedication', display: 'New Medication' }
  else
    System.Code { code: 'ContinuedTherapy', display: 'Continuation of therapy' }

// MISSING: needs test data to validate
//Initial date of therapy does not return correct result if there have been more than 1 prior Prescriptions - logic needs to be adapted to that case
define "Initial date of therapy":
  if not "New therapy" then
    UCE."All Medication Requests" M
    where M.id = "Most Recent Medication Request".priorPrescription.reference
    return M.authoredOn
  else 
    null

// TODO: Use this function to narrow down error for "Medication Request Period"
// define "Test":
//   CMD."TestFunction"("Most Recent Medication Request")

// TODO: Error: java.lang.NullPointerException: Cannot invoke "java.lang.Class.getName()" because the return value of "org.opencds.cqf.cql.engine.execution.Context.resolveType(Object)" is null
// define "Medication Request Period":
//   CMD."MedicationRequestPeriod"("Most Recent Medication Request")

// TODO: Need to resolve "Medication Request Period" error
// define "Expected Therapy Length":
//   convert(
//     CMD.Quantity(days between start of "Medication Request Period" and end of "Medication Request Period", 'days')
//   ) to 'days'

// TODO: Need to resolve "Medication Request Period" error
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