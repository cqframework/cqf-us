library UPPARFInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
codesystem "Verification Status": 'http://terminology.hl7.org/CodeSystem/condition-ver-status'
codesystem "ICD10": 'http://hl7.org/fhir/sid/icd-10-cm'
code "Member Number": 'MB' from "Identifier Type"
code "Subscriber Number": 'SN' from "Identifier Type"
code "Confirmed": 'confirmed' from "Verification Status"

context Patient

//TODO: find out if community prefers taking existing questionnaires literally or changing them slightly to e.g. a boolean type question in this example of the urgency quesiton.
define "Urgency":
"Most Recent Medication Request".priority P
  return (
    //suggestion: only routine would resolve to Non-Urgent, all other codes resolve in Urgent (i.e. stat, asap and urgent)
    if P != 'routine' then 'Urgent'
    else  'Not Urgent'
  )
  
define "Medication Name":
  "Medication Requested" M
    return M.code.display

define "Is Opioid Treatment":
true //TBD

//TODO: can we assume that with a previous prior authentication there also has been a prior prescription?
define "Is First Prior Authentication":
IsNull("Prior Prescription")

//TODO: does the initial request date mean the exact same medication was requested before?
define "Initial Request Date":
if not "Is First Prior Authentication" then
    singleton from (
    UCE."All Medication Requests" M
      where EndsWith(("Most Recent Medication Request".priorPrescription as USCore.Reference).reference, M.id)
      return M.authoredOn
    )
  else 
    null

define "Is First Request > 12 Months":
if IsNull("Initial Request Date") then null else 
(months between "Initial Request Date" and Now() > 12)

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
singleton from (
[USCore.PractitionerProfile] P
              where EndsWith("Most Recent Medication Request".requester.reference, P.id))

define "RequesterRole":
singleton from (
[USCore.PractitionerRoleProfile] R
              where EndsWith(R.practitioner.reference, "Requester".id))


define "Prescriber Name":
   "Practitioner First Name Occurance".family
   //TODO: prefix, suffix and given do not work as expected.
   //Combine("Practitioner First Name Occurance".prefix) + Combine("Practitioner First Name Occurance".given) + "Practitioner First Name Occurance".family

define "Practitioner First Name Occurance":
  First(Requester.name)

define "Prescriber Fax":
  Fax(Requester.telecom).value

define "Prescriber Phone":
  UC.Mobile(Requester.telecom).value

define "Prescriber Pager":
  Pager(Requester.telecom).value

define "Prescriber Address":
'TODO: remove hard coded address'

define "Prescriber Contact":
'TODO: remove hard coded contact'
//TBD: would this be a work phone or more something like an address?

define "Prescriber NPI":
First (
  "Requester".identifier I
  where I.system = 'http://hl7.org.fhir/sid/us-npi'
  ).value

define "Prescriber Tax ID":
First (
  "Requester".identifier I
  where I.system = 'urn:oid:2.16.840.1.113883.4.4'
  ).value

define "Prescriber Specialty":
First(RequesterRole.specialty.codes).display

define "Prescriber Email Address":
Email(Requester.telecom).value

define "Request Type":
//TODO: is this logic correct?
if "Is First Prior Authentication" then
'New Request' else 'Reauthorization'

define "All Patients Confirmed Diagnosis":
[USCore.Condition] C
  where EndsWith(C.subject.reference, Patient.id)
  and "Confirmed" in C.verificationStatus.codes

define "ICD-10 Code":
 "All Patients Confirmed Diagnosis".code.codes C
 where C.system = "ICD10".id
 return C.code

//TODO: why does "display" use  CodeableConcept.text instead of  CodeableConcept.coding.display? Could System.Concept use coding.display to fill its display element?
define "Diagnosis Descriptions":
 "All Patients Confirmed Diagnosis".code.display

//helper definitions
define "Medication Requested":
singleton from (
  UCE."All Medications" M
    where EndsWith(("Most Recent Medication Request".medication as USCore.Reference).reference, M.id))

define "Most Recent Medication Request":
  UCE."Most Recent Medication Request"

define "Prior Prescription":
  "Most Recent Medication Request".priorPrescription

//TBD: is this better as part of us common?
define function Email(contactPoints List<USCore.ContactPoint>):
  singleton from (contactPoints P where P.system = 'email')

  //TBD: is this better as part of us common?
define function Fax(contactPoints List<USCore.ContactPoint>):
  singleton from (contactPoints P where P.system = 'fax')

    //TBD: is this better as part of us common?
define function Pager(contactPoints List<USCore.ContactPoint>):
  singleton from (contactPoints P where P.system = 'pager')