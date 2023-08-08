library MBODAinitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' 
include USCoreCommon version '0.1.0' called UC

//CumulativeMedicationDuration was created as part of the US ECQM and CDC Opioid Guideline development 
//http://fhir.org/guides/cdc/opioid-mme-r4
include CumulativeMedicationDuration version '3.1.000' called CMD

codesystem "LOINC": 'http://loinc.org'
code "Body surface area": '8277-6' from "LOINC" display 'Intensive care unit'

context USCore.Patient

define "Member ID":
  [FHIR.Coverage] C
  where C.subscriber.reference = Patient.id
  return C.subscriberId

define "First Name":
  Patient.name.given.first()

define "Last Name":
  Patient.name.family

define "Date of Birth":
  Patient.birthDate

define "Medical Record Number":
  Patient.identifier[1].value

define "Phone Number":
  UC.Mobile(Patient.telecom) 

define "Allergies":
   [USCore.AllergyIntolerance] A 
   where A.isActive()
   and A.isConfirmed()
   return A.code

define "Address":
  Patient.address.line

define "City":
  Patient.address.city

define "State":
  Patient.address.state

define "Zip":
  Patient.address.postalCode

define "Height":
  convert(
    UC.MostRecent(
      [USCore."observation-bodyheight"] BH
        where BH.status in { 'final', 'amended', 'corrected' }
    ).value 
  ) to '[in_i]'


define "Weight":
  convert(
    UC.MostRecent(
      [USCore."observation-bodyweight"] W
        where W.status in { 'final', 'amended', 'corrected' }
    ).value 
  ) to '[lb_av]'

define "Most Recent BSA":
  convert( Last(
    [Observation: "Body surface area"] O
    sort by issued
  ).value ) to 'm2'

define "BSA":
  Coalesce("Most Recent BSA", "Calculated BSA")

define "Calculated BSA":
  ((("Weight"*"Height")/3131).value)^0.5

define "Birth Sex":
 Patient.birthsex 

define "Diagnosis Codes":
  [USCore.Condition] C
    return C.code

define "Diagnosis Descriptions":
  [USCore.Condition] C
    return C.code.display

define "Medication Name":
  [USCore.MedicationProfile] M
  where M.id = UC.MostRecent([USCore.MedicationRequestProfile]).medication.reference
    return M.code.display
  
  
define "Medication Dose":
  UC.MostRecent([USCore.MedicationRequestProfile]).dosageInstruction.doseAndRate.dose

define "Medication Route":
   UC.MostRecent([USCore.MedicationRequestProfile]).dosageInstruction.route

define "Medication Frequency":
   UC.MostRecent([USCore.MedicationRequestProfile]).dosageInstruction.doseAndRate.rate


define "Expected Therapy Length":
  convert(
    FHIRHelpers.ToQuantity(CMD."MedicationRequestPeriod"(UC.MostRecent([USCore.MedicationRequestProfile])))
  ) to 'days'

define "Quantity or Number of requested Visits":
   UC.MostRecent([USCore.MedicationRequestProfile]).dispenseRequest.quantity

define "Anticipated/actual date of service":
  start of CMD."MedicationRequestPeriod"(UC.MostRecent([USCore.MedicationRequestProfile]))

define "New therapy":
  (UC.MostRecent([USCore.MedicationRequestProfile]).priorPrescription) is not null

//Initial date of therapy does not return correct result if there have been more than 1 prior Prescriptions - logic needs to be adapted to that case
define "Initial date of therapy":
  if not "New therapy" then
    [USCore.MedicationRequestProfile] M
    where M.id = UC.MostRecent([USCore.MedicationRequestProfile]).priorPrescription.reference
    return M.authoredOn
  else 
    null

define "Code of Requested Drug":
  [MedicationProfile] M
  where M.id = UC.MostRecent([USCore.MedicationRequestProfile]).medication.reference
    return M.code

//related Procedures - Procedure is not linked to medication request - not possible to find the related procedures