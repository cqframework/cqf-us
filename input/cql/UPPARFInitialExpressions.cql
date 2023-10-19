library MBODAInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

//TBD: codes

context Patient

define "Urgency":
true //TBD
//TODO: determine MedicationRequest.priority by initial expression https://build.fhir.org/valueset-request-priority.html
  //suggestion: only routine would resolve to Non-Urgent, all other codes resolve in Urgent (i.e. stat, asap and urgent)
  //question: is there even time when having stat or asap requests to proceed with prior auth?
  
define "Medication Name":
  "Medication Requested" M
    return M.code.display

define "Is Opioid Treatment":
true //TBD

define "Is First Prior Authentication":
//TODO: can I assume that there has been a prescription before prior authentication?
IsNull("Prior Prescription")

define "Initial Request Date":
if not "Is First Prior Authentication" then
    UCE."All Medication Requests" M
      where EndsWith(("Most Recent Medication Request".priorPrescription as USCore.Reference).reference, M.id)
      return M.authoredOn
  else 
    null

define "Medication Name":
true //TBD

define "Is First Request > 12 Months":
true //TBD

define "Patient Name":
  UCE."Name - First Middle(s) Last"

define "Member ID":
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

define "Policy Number":
true //TBD

define "Date of Birth":
  Patient.birthDate

define "Address":
true //TBD

define "Phone Number":
  UC.Mobile(Patient.telecom).value

define "Email Address":
true //TBD

define "Prescription Date":
true //TBD

define "Prescriber Name":
true //TBD

define "Prescriber Fax":
true //TBD

define "Prescriber Phone":
true //TBD

define "Prescriber Pager":
true //TBD

define "Prescriber Address":
true //TBD

define "Prescriber Contact":
true //TBD

define "Prescriber NPI":
true //TBD

define "Prescriber Tax ID":
true //TBD

define "Prescriber Specialty":
true //TBD

define "Prescriber Email Address":
true //TBD

define "Request Type":
true //TBD

define "Diagnosis Codes":
true //TBD

define "Diagnosis Descriptions":
true //TBD

//helper definitions
define "Medication Requested":
  UCE."All Medications" M
    where EndsWith(("Most Recent Medication Request".medication as USCore.Reference).reference, M.id)

define "Most Recent Medication Request":
  UCE."Most Recent Medication Request"

define "Prior Prescription":
  "Most Recent Medication Request".priorPrescription
