library MBODAInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "LOINC": 'http://loinc.org'
codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
codesystem "ICD": 'http://hl7.org/fhir/sid/icd-10'
codesystem "CPT": 'http://www.ama-assn.org/go/cpt'
code "Member Number": 'MB' from "Identifier Type"


context Patient

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

define "Patient Name":
  UCE."Name - First Middle(s) Last"

define "Date of Birth":
  Patient.birthDate

define "Phone Number":
  UC.Mobile(Patient.telecom).value

define "Address":
   (singleton from Patient.address).line

define "Requesting Provider":
  First([PractitionerProfile: id in (Split(("Most Recent ServiceRequest".requester as FHIR.Reference).reference, '/'))]) P
  First([OrganizationProfile: id in (Split(("Most Recent ServiceRequest".requester as FHIR.Reference).reference, '/'))]) O
   return Coalece(P,O)
  
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
  where T.system = 'fax'
  return T.value

define "Servicing Provider":
   First([PractitionerProfile: id in (Split((First("Most Recent ServiceRequest".performer) as FHIR.Reference).reference, '/'))]) P
   First([OrganizationProfile: id in (Split((First("Most Recent ServiceRequest".performer) as FHIR.Reference).reference, '/'))]) O
   return Coalece(P,O)

define "Servicing Provider Name":
  "Servicing Provider".name

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
  where T.system = 'fax'
  return T.value

define "Test Coverage":
[FHIR.Coverage] C
with  "Most Recent ServiceRequest" SR such that  EndsWith(First(SR.insurance.reference), C.id)

define "Billing Provider" :
 First([OrganizationProfile] O
 with "Test Coverage" C such that EndsWith(First(C.payor.reference), O.id))

define "Billing Provider Name":
  "Billing Provider".name

define "Billing Provider Phone":
  UC.Mobile("Billing Provider".telecom).value

define "Billing Provider Address":
  (singleton from "Billing Provider".address).line

define "Billing Provider NPI":
  "Billing Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

define "Billing Provider Fax":
  "Billing Provider".telecom T
  where T.system = 'fax'
  return T.value

define "All ServiceRequests":
  [ServiceRequest]

define "Most Recent ServiceRequest":
  UC.MostRecentSR("All ServiceRequests")

define "Date of Service":
  "Most Recent ServiceRequest".occurrence

define "Test ID":
  "Most Recent ServiceRequest" SR
  return SR.code.coding.code.value 

define "Test name":
"Most Recent ServiceRequest" SR
  return SR.code.coding.display 

define "Test Related Condition":
//option 1 for related Condition
  "Most Recent ServiceRequest" SR
  return SR.reasonCode //this is just the code of the condition but not the entire condition resource
  //option 2 for related Condition -this option uses the entire condition resource
  //return [Condition: id in (Split((First("Most Recent ServiceRequest".reasonReference) as FHIR.Reference).reference, '/'))]

define "ALL ICD and CPT Diagnosis Codes":
  return "Diagnosis ICD Codes" union "Diagnosis CPT Codes" as List<FHIR.Coding>

define "Diagnosis ICD Codes":
  "Test Related Condition".coding C
  where C.system.value =  'http://hl7.org/fhir/sid/icd-10'
  return C
  
define "Diagnosis CPT Codes":
  "Test Related Condition".coding C
  where C.system.value =  'http://hl7.org/fhir/sid/icd-10'
  return C

define "Diagnosis Descriptions":
  "ALL ICD and CPT Diagnosis Codes" ConceptItem
    return Combine( {FHIRHelpers.ToString((ConceptItem C return C.display)) , '|'})    

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

define "Clinical Trial":
  [FHIR.ResearchStudy] R 
  with "Research Subject" S such that EndsWith(S.study.reference, R.id)
  with  "Most Recent ServiceRequest" SR such that R.condition = SR.reasonCode

define "Clinical Trial ID":
  "Clinical Trial".identifier C
  where FHIRHelpers.ToString(C.system) = 'https://clinicaltrials.gov'
  return C.value

define "Previous genetic testing for condition":
        "All ServiceRequests" S
        where S.code = "Most Recent ServiceRequest".code
        and S.id != "Most Recent ServiceRequest".id
  
   
//define "Family history of genetic testing"
//too general to prefill?

//define "Patient history"
//too general to prefill?


