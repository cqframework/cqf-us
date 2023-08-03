library MBODAinitialExpressions version '0.1.0'

using USCore version '3.1.1'

include FHIRHelpers version '4.0.1'
include USCoreCommon version '0.1.0' called UC


context Patient

define "First Name":
  Patient.name.given.first()

define "Last Name":
  Patient.name.family

define "Date of Birth":
  Patient.birthDate

//Todo Medical Record Number

define "Phone Number":
  UC.Mobile(Patient.telecom) 

define "Allergies":
   [AllergyIntolerance] A 
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
      ["observation-bodyheight"] BH
        where BH.status in { 'final', 'amended', 'corrected' }
    ).value 
  ) to '[in_i]'


define "Weight":
  convert(
    UC.MostRecent(
      ["observation-bodyweight"] W
        where W.status in { 'final', 'amended', 'corrected' }
    ).value 
  ) to '[lb_av]'

define "Birth Sex":
 Patient.birthsex 

define "Diagnosis Codes":
  [Condition] C
    return C.code

define "Diagnosis Descriptions":
  [Condition] C
    return C.code.display

define "Medication Name":
  [MedicationProfile] M
  where M.id = UC.MostRecent([MedicationRequestProfile]).medication.reference
    return M.code.display
  
  
define "Medication Dose":
  UC.MostRecent([MedicationRequestProfile]).dosageInstruction.doseAndRate.dose

define "Medication Route":
   UC.MostRecent([MedicationRequestProfile]).dosageInstruction.route

define "Medication Frequency":
   UC.MostRecent([MedicationRequestProfile]).dosageInstruction.doseAndRate.rate

//TODO Expected Therapy Length

define "Quantity or Number of requested Visits":
   UC.MostRecent([MedicationRequestProfile]).dispenseRequest.quantity

//TODO Anticipated/actual date of service 

define "New therapy":
  (UC.MostRecent([MedicationRequestProfile]).priorPrescription) is not null

//TODO Initial Date of Therapy

define "Code of Requested Drug":
  [MedicationProfile] M
  where M.id = UC.MostRecent([MedicationRequestProfile]).medication.reference
    return M.code

//TODO related Procedures - Procedure is not linked to medication request - how to find the right procedure?