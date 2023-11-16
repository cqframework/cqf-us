library MBODAInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
code "Member Number": 'MB' from "Identifier Type"
code "Subscriber Number": 'SN' from "Identifier Type"

context Patient

define "Urgency":
"Most Recent Medication Request".priority P
  if (P.code != 'routine')
    return 'Not Urgent'
  else 
    return 'Urgent'
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
singleton from
    (
      (
        (
          ([FHIR.Coverage] C 
              where EndsWith(C.beneficiary.reference, Patient.id))
          .identifier) I
        return {value: I.value.value, type: I.type.coding.code}
      ) valuesByTypes
    where "Subscriber Number".code in valuesByTypes.type
    return valuesByTypes.value
    )

define "Date of Birth":
  Patient.birthDate

define "Address":
  { 'TODO: remove hard-coded address' }

define "Phone Number":
  UC.Mobile(Patient.telecom).value

define "Email Address":
  Email(Patient.telecom).value

define "Prescription Date":
"Most Recent Medication Request".authoredOn

define "Requester":
singleton(
[USCore.PractitionerProfile] P
              where EndsWith("Most Recent Medication Request".requester.reference, P.id))

define "RequesterRole":
singleton(
[USCore.PractitionerRoleProfile] R
              where EndsWith(R.practitioner.reference, "Requester".id))

define "Prescriber Name":
  Requester.name

define "Prescriber Fax":
  Fax(Requester.telecom).value

define "Prescriber Phone":
  UC.Mobile(Requester.telecom).value

define "Prescriber Pager":
  Pager(Requester.telecom).value

define "Prescriber Address":
true //TBD

define "Prescriber Contact":
true //TBD

define "Prescriber NPI":
  (Requester.identifier I
    where I.system = 'http://hl7.org/fhir/sid/us-npi').value

define "Prescriber Tax ID":
true //TBD

define "Prescriber Specialty":
RequesterRole.specialty.display

define "Prescriber Email Address":
Email(Requester.telecom)

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

//TBD: is this better as part of UC?
define function Email(contactPoints List<USCore.ContactPoint>):
  singleton from (contactPoints P where P.system = 'email')

  //TBD: is this better as part of UC?
define function Fax(contactPoints List<USCore.ContactPoint>):
  singleton from (contactPoints P where P.system = 'fax')

    //TBD: is this better as part of UC?
define function Pager(contactPoints List<USCore.ContactPoint>):
  singleton from (contactPoints P where P.system = 'pager')


