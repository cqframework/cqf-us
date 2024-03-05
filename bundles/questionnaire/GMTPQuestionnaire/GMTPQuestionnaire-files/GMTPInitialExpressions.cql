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

define "Humana ID": // Similar to Member ID from MBODA Initial expressions?
  UCE."Humana ID"

define "Patient Name":
  UCE."Name - First Middle(s) Last"

define "Date of Birth":
  Patient.birthDate

define "Phone Number":
  UC.Mobile(Patient.telecom).value

// TODO: Error: Could not resolve data provider for package 'java.util'.
/*
define "Address":
   (singleton from Patient.address).line
*/

define "Address":
  { 'TODO: remove hard-coded address' }
  

define "Requesting Provider Practitioner"://assuming the requester is a practitioner
  UCE."Requesting Provider Practitioner"

/*//if the requester is an Organization:
define "Requesting Provider Organization":
  UCE."Requesting Provider Organization"
 */
   
define "Requesting Provider":
   "Requesting Provider Practitioner"
  
  
define "Requesting Provider Name":
  "Requesting Provider".name.family 

define "Requesting Provider Phone":
  UC.Mobile("Requesting Provider".telecom).value
  //This definition looks for #mobile, but wouldn't a practitioner be #work?
/*
define "Requesting Provider Address":
  (singleton from "Requesting Provider".address).line
*/
define "Requesting Provider Address":
  { 'TODO: remove hard-coded address' }

define "Requesting Provider NPI":
  "Requesting Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Requesting Provider Fax":
  "Requesting Provider".telecom T
  where T.system = 'fax'
  return T.value


define "Servicing Provider"://assuming the servicing provider is a lab - (molecular/genetic testing)
  UCE."Servicing Provider"

define "Servicing Provider Name":
    "Servicing Provider".name

define "Servicing Provider Phone":
  UC.Mobile("Servicing Provider".telecom).value

// TODO: Error: Could not resolve data provider for package 'java.util'.
/*
define "Servicing Provider Address":
  (singleton from "Servicing Provider".address).line
*/
define "Servicing Provider Address":
  { 'TODO: remove hard-coded address' }

define "Servicing Provider NPI":
  "Servicing Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Servicing Provider Fax":
  "Servicing Provider".telecom T
  where T.system = 'fax'
  return T.value

define "Test Coverage":
  UCE."Test Coverage"


define "Billing Provider":
  UCE."Billing Provider"

define "Billing Provider Name":
  "Billing Provider".name

define "Billing Provider Phone":
  UC.Mobile("Billing Provider".telecom).value

// TODO: Error: Could not resolve data provider for package 'java.util'.
/*
define "Billing Provider Address":
  (singleton from "Billing Provider".address).line
*/
define "Billing Provider Address":
  { 'TODO: remove hard-coded address' }

define "Billing Provider NPI":
  "Billing Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Billing Provider Fax":
  "Billing Provider".telecom T
  where T.system = 'fax'
  return T.value

define "All ServiceRequests":
  UCE."All ServiceRequests"

define "Most Recent ServiceRequest":
  UCE."Most Recent ServiceRequest"

define "Date of Service":
  "Most Recent ServiceRequest".occurrence.value

define "Requested Test":
  "Most Recent ServiceRequest" SR
  return SR.code

define "Test ID":
  Combine("Requested Test".coding.code.value, ', ')

define "Test name":
   Combine("Requested Test".coding.display.value, ', ')

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
  UCE."Test Related Condition"
  //.reasonReference changed to .reason in FHIR R5

define "Diagnosis Descriptions":
  "Test Related Condition".code.coding.display.value

define "Billing Provider different from Servicing Provider":
  if "Billing Provider".id != "Servicing Provider".id then
  'Yes'
  else 
  'No'

define "Clinical Trial Organization":
  First(UCE."Clinical Trial Organization" O 
    with "Clinical Trial"  T such that EndsWith(T.sponsor.reference, O.id))  
 //in FHIR R5 T.associatedParty instead of T.sponsor 

define "BillingProvider is Clinical Trial Organisation":
  "Billing Provider" = "Clinical Trial Organization"

//TODO does not get populated properly
define "Part of clinical trial":
 if "Is Research Subject" and "BillingProvider is Clinical Trial Organisation" then
 'Yes'
 else
 'No'

define "Is Research Subject":
  exists("Research Subject")

define "Research Subject":
  UCE."Research Subject"
     //ResearchSubject.individual is from FHIR version v4.0.1 and has been replaced by R.subject in FHIR R5

define "All clinical Trials":
  UCE."All Clinical Trials" 

define "Clinical Trial":
  //[FHIR.ResearchStudy] R
  UCE."All Clinical Trials" R 
    with "Research Subject" S such that EndsWith(S.study.reference, R.id)
    with  "Test Related Condition" C such that C.code in R.condition
  //UCE."Clinical Trial" does not work, but using UCE."All Clinical Trials" instead of [FHIR.ResearchStudy] works

define "Clinical Trial ID":
  "Clinical Trial".identifier C
  where C.system = 'https://clinicaltrials.gov'
  return C.value.value

//function "GetServiceRequestReasonCondition" moved to UCE


define "Previous genetic testing for condition":
   from "All ServiceRequests" S,
   "Most Recent ServiceRequest" SR 
   where S.occurrence before SR.occurrence
   and S.id != SR.id
   and S.reasonReference = SR.reasonReference
  return S.id.value
         

//define "Family history of genetic testing"
//too general to prefill?

//define "Patient history"
//too general to prefill?


