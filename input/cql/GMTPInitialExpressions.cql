library GMTPInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "LOINC": 'http://loinc.org'
codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
code "Member Number": 'MB' from "Identifier Type"


context Patient
/*
define "Humana ID": // Similar to Member ID from MBODA Initial expressions?
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
*/
define "Patient Name":
  UCE."Name - First Middle(s) Last"

define "Date of Birth":
  Patient.birthDate

define "Phone Number":
  UC.Mobile(Patient.telecom).value

/*
define "Address":
   (singleton from Patient.address).line
*/

define "Requesting Provider Practitioner"://assuming the requester is always a practitioner
  [PractitionerProfile] P
    where EndsWith("Most Recent ServiceRequest".requester.reference.value, P.id)
/*  
define "Requesting Provider Organization":
  [OrganizationProfile] O
    where EndsWith("Most Recent ServiceRequest".requester.reference.value, O.id)
 */
   
define "Requesting Provider":
  /*if exists("Requesting Provider Organization") then
    "Requesting Provider Organization"
  else*/
   "Requesting Provider Practitioner"
  
  
define "Requesting Provider Name":
  "Requesting Provider".name.family 

define "Requesting Provider Phone":
  UC.Mobile("Requesting Provider".telecom).value
/*
define "Requesting Provider Address":
  (singleton from "Requesting Provider".address).line
*/
define "Requesting Provider NPI":
  "Requesting Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Requesting Provider Fax":
  "Requesting Provider".telecom T
  where T.system = 'fax'
  return T.value


define "Servicing Provider"://assuming the servicing provider is a lab - (molecular/genetic testing)
   singleton from ([OrganizationProfile] O
  where EndsWith(First("Most Recent ServiceRequest".performer.reference.value), O.id))

define "Servicing Provider Name":
    "Servicing Provider".name

define "Servicing Provider Phone":
  UC.Mobile("Servicing Provider".telecom).value

/*
define "Servicing Provider Address":
  (singleton from "Servicing Provider".address).line
*/
define "Servicing Provider NPI":
  "Servicing Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Servicing Provider Fax":
  "Servicing Provider".telecom T
  where T.system = 'fax'
  return T.value

define "Test Coverage":
[FHIR.Coverage] C
with  "Most Recent ServiceRequest" SR such that  EndsWith(First(SR.insurance.reference), C.id)

define "Test Coverage Payor (For testing)":
  "Test Coverage".payor.reference.value

define "Organization (For testing)":
  [OrganizationProfile]

define "FHIR Organization (For testing)":
  [FHIR.Organization]

define "Billing Provider":
 singleton from([OrganizationProfile] O
  where EndsWith(First("Test Coverage".payor.reference.value), O.id))

define "Billing Provider Name":
  "Billing Provider".name

define "Billing Provider Phone":
  UC.Mobile("Billing Provider".telecom).value
/*
define "Billing Provider Address":
  (singleton from "Billing Provider".address).line
*/
define "Billing Provider NPI":
  "Billing Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Billing Provider Fax":
  "Billing Provider".telecom T
  where T.system = 'fax'
  return T.value

define "All ServiceRequests":
  [FHIR.ServiceRequest]

define "Most Recent ServiceRequest":
  UC.MostRecentSR("All ServiceRequests")

define "Date of Service":
  "Most Recent ServiceRequest".occurrence.value

define "Requested Test":
  "Most Recent ServiceRequest" SR
  return SR.code

define "Test ID":
  "Requested Test".coding.code.value 

define "Test name":
"Most Recent ServiceRequest" SR
  return "Requested Test".coding.display.value 

define "ALL ICD and CPT Test Codes":
   "Test ICD Codes" union "Test CPT Codes" as List<FHIR.Coding>

define "Test ICD Codes":
 "Requested Test".coding C
  where C.system.value =  'http://hl7.org/fhir/sid/icd-10-cm'
  return C
  
define "Test CPT Codes":
  "Requested Test".coding C
  where C.system.value =  'http://www.ama-assn.org/go/cpt'
  return C

define "Test Related Condition":
  [FHIR.Condition] C
  where EndsWith(First("Most Recent ServiceRequest".reasonReference.reference.value), C.id)
  //.reasonReference changed to .reason in FHIR R5

define "Diagnosis Descriptions":
  "Test Related Condition".code.coding.display.value

define "Billing Provider different from Servicing Provider":
  "Billing Provider".id != "Servicing Provider".id

define "Clinical Trial Organization":
  First([OrganizationProfile] O
 with "Clinical Trial"  T such that EndsWith(T.sponsor.reference, O.id))  //in FHIR R5 T.associatedParty instead of T.sponsor 

define "BillingProvider is Clinical Trial Organisation":
  "Billing Provider" = "Clinical Trial Organization"

define "Part of clinical trial":
 "Is Research Subject" and "BillingProvider is Clinical Trial Organisation"

define "Is Research Subject":
  exists("Research Subject")

define "Research Subject":
     [FHIR.ResearchSubject] R
     where  EndsWith(R.individual.reference, Patient.id)//ResearchSubject.individual is from FHIR version v4.0.1 and has been replaced by R.subject in FHIR R5

define "All clinical Trials":
[FHIR.ResearchStudy] R 

define "Clinical Trial":
  [FHIR.ResearchStudy] R 
  with "Research Subject" S such that EndsWith(S.study.reference, R.id)
  with  "Most Recent ServiceRequest" SR such that R.condition = "Test Related Condition".code

define "Clinical Trial ID":
  "Clinical Trial".identifier C
  where C.system = 'https://clinicaltrials.gov'
  return C.value.value

//TODO
define "Previous genetic testing for condition":
        "All ServiceRequests" S
        where S.code = "Most Recent ServiceRequest".code
        and S.id != "Most Recent ServiceRequest".id
  
   
//define "Family history of genetic testing"
//too general to prefill?

//define "Patient history"
//too general to prefill?


