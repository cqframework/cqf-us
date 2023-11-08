library MBODAInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE



codesystem "LOINC": 'http://loinc.org'
codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
code "Member Number": 'MB' from "Identifier Type"


context Patient

define "Humana ID number": //TODO Similar to Member ID from MBODA Initial expressions?
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

define "Date of Birth":
  Patient.birthDate

define "Phone Number":
  UC.Mobile(Patient.telecom).value

define "Address":
   (singleton from Patient.address).line


define "Requesting Provider is Practitioner":
  "Most Recent ServiceRequest" SR
  return SR.requester.type = Practitioner//TODO check 

//assuming the requesting provider is a practitioner
define "Requesting Provider": //TODO check if correct way to get practitioner from reference
  "Most Recent ServiceRequest" SR
  where "Requesting Provider is Practitioner" 
  return SR.requester.reference

define "Requesting Provider Name":
    "Requesting Provider".name

define "Requesting Provider Phone":
  UC.Mobile("Requesting Provider".telecom).value

define "Requesting Provider Address":
  (singleton from "Requesting Provider".address).line

define "Requesting Provider NPI":
  "Requesting Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Requesting Provider Fax":
  "Requesting Provider".telecom T
  where T.system = 'fax'//TODO check
  return T.value

define "Servicing Provider is Practitioner":
  "Most Recent ServiceRequest" SR
  return SR.requester.type = Practitioner//TODO check

define "Servicing Provider":
//assuming it is another practitioner based on the required NPI - would a lab (where the test is analyzed) fit better here?
//TODO check if correct way to get practitioner from reference
  "Most Recent ServiceRequest" SR
     where "Servicing Provider is Practitioner" 
  return SR.performer.reference


define "Servicing Provider Name":
  "Requesting Provider".name

define "Servicing Provider Phone":
  UC.Mobile("Servicing Provider".telecom).value

define "Servicing Provider Address":
  (singleton from "Servicing Provider".address).line

define "Servicing Provider NPI":
  "Servicing Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Servicing Provider Fax":
  "Servicing Provider".telecom T
  where T.system = 'fax'//TODO check
  return T.value

//TODO
//Billing Provider / Referring Lab

define "All Service Requests":
  [ServiceRequest]

define "Most Recent ServiceRequest":
  UC.MostRecentSR("All Service Requests")

define "Test Related Condition":
  "Most Recent ServiceRequest".reason 

define "Date of Service":
  "Most Recent ServiceRequest".occurrence

define "Test name":
"Most Recent Service Request" SR
  return SR.code.coding.display //TODO check

define "Test ID":
  "Most Recent Service Request" SR
  return SR.code.coding.code //TODO check

define "Diagnosis Codes":
  "Test Related Condition" C
    return C.code

define "Diagnosis ICD Codes":
  "Diagnosis Codes" D
  where D.code.system = "http://hl7.org/fhir/sid/icd-10"

define "Diagnosis CPT Codes":
  "Diagnosis Codes" D
  where D.code.system = "http://www.ama-assn.org/go/cpt"

define "Diagnosis Descriptions":
  "ICD codes" and "CPT codes" ConceptItem
    return Combine(((ConceptItem.codes) C return C.display), '|')


//define "Previous genetic testing for condition":
//TODO

//Once TODOs below are resolved add the expressions below to fsh file 
//define "Part of clinical trial"
//TODO

//define "Family history of genetic testing"
//TODO
//should this be prefilled?

//define "Patient history"
//TODO
//too general?


