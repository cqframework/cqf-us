
library MDOENInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
code "Client Number": 'CN' from "Identifier Type"

context Patient


define "Client Name":
    UCE."Name - First Middle(s) Last"

define "Client ID":
  singleton from
    (
      (
        (
          ([FHIR.Coverage] C 
              where EndsWith(C.beneficiary.reference, Patient.id))
          .identifier) I
        return {value: I.value.value, type: I.type.coding.code}
      ) valuesByTypes
    where "Client Number".code in valuesByTypes.type
    return valuesByTypes.value
    )


/*define "Vendor":

/*define "Vendor Name":
    "Vendor".name.family

define "Vendor NPI":
    "Vendor".identifier I 
    where I.system = 'http://hl7.org/fhir/sid/us-npi'
    return I.value


define "Vendor Phone":
    UC.Mobile("Vendor".telecom).value


define "Vendor Fax":
    "Vendor".telecom T
    where T.system = 'fax'
    return T.value
*/

define "All ServiceRequests":
  [FHIR.ServiceRequest]

define "Most Recent ServiceRequest":
  UC.MostRecentSR("All ServiceRequests")

define "Requested Metabolic Product":
  "Most Recent ServiceRequest" SR
  return SR.code


//define "Quantity of Metabolic Product":


//define "HCPCS code":

define "Test Related Condition":
  [FHIR.Condition] C
  where EndsWith(First("Most Recent ServiceRequest".reasonReference.reference.value), C.id)
  //.reasonReference changed to .reason in FHIR R5


define "Diagnosis":
    "Test Related Condition".code.coding.display.value


define "Diagnosis ICD-10 Code":
    "Test Related Condition".code.coding C
  where C.system.value =  'http://hl7.org/fhir/sid/icd-10-cm'
  return C

define "Prescribing Provider Practitioner"://assuming the requester is a practitioner
  [PractitionerProfile] P
    where EndsWith("Most Recent ServiceRequest".requester.reference.value, P.id)

define "Prescribing Provider":
    "Prescribing Provider Practitioner"

define "Prescribing Provider Name":
    "Prescribing Provider Practitioner".name.family 

define "Prescribing Provider Phone":
      UC.Mobile("Prescribing Provider".telecom).value

define "Prescribing Provider NPI":
"Prescribing Provider".identifier I 
  where I.system = 'http://hl7.org/fhir/sid/us-npi'
  return I.value

