library UPPARFInitialExpressions version '0.1.0'

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
  return (
    if P != 'routine' then 'Urgent'
    else  'Not Urgent'
  )
  //suggestion: only routine would resolve to Non-Urgent, all other codes resolve in Urgent (i.e. stat, asap and urgent)
  //question: is there even time when having stat or asap requests to proceed with prior auth?
  
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
   //TODO: prefix and given do not work as expected.
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
null //is the tax id even stored in fhir?

define "Prescriber Specialty":
First(RequesterRole.specialty.codes).display

define "Prescriber Email Address":
Email(Requester.telecom).value

define "Request Type":
//TODO: is this logic correct?
if "Is First Prior Authentication" then
'New Request' else 'Reauthorization'

define "Diagnosis Codes":
First("All Patients Diagnosis").code

define "All Patients Diagnosis":
[USCore.Condition] C
  where EndsWith(C.subject.reference, Patient.id)

define "Codes of Condition":
 ("All Patients Diagnosis")
  
   //as List<FHIR.Coding>

define "ICD-10 Code":
null
//return Fist("All Patients Diagnosis").
/*Combine ("All Patients Diagnosis".Codes)
  let D.code DC where DC.system = 'http://hl7.org/fhir/sid/icd-10-cm'
  return DC.code*/

//confirmed us core condition codes?
//codes from http://hl7.org/fhir/sid/icd-10-cm Condition.code
 //TBD

define "Diagnosis Descriptions":
true //TBD

//helper definitions
define "Medication Requested":
singleton from (
  UCE."All Medications" M
    where EndsWith(("Most Recent Medication Request".medication as USCore.Reference).reference, M.id))

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


