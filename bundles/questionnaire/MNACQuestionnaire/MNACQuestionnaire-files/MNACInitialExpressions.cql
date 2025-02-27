library MNACInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.0'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
codesystem "ICD10": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "SNOMED CT": 'http://snomed.info/sct'

code "Member Number": 'MB' from "Identifier Type"
code "UTI": 'T83.5' from "ICD10"
code "Abnormal Urine Finding": '102866000' from "SNOMED CT"

parameter "ServiceRequest" FHIR.ServiceRequest

context Patient

define "Date of Request":
  ServiceRequest.authoredOn

//https://www.hca.wa.gov/assets/billers-and-providers/13-760.pdf

define "Diagnosis":
  First("SR Related Condition".code).text.value

define "Item Requested":
  ServiceRequest.code.coding.display.value

define "UTI in Last Year":
  Exists("UTI Diagnostic Reports Last Year")

define "Lab Reports UTIs":
  "UTI Diagnostic Reports Last Year".presentedForm

define "Dates of UTIs":
  "UTI Diagnostic Reports Last Year".effective.value

//TODO: create example MedicationStatement
define "Antibiotics Used":
  [FHIR.MedicationStatement] MS
    where First(MS.reasonReference.reference) in "UTI Diagnostic Reports Last Year".id

define "Check Symptoms":
  'TBD'

define "Fever Temperature":
  'TBD'

define "Catheterization Frequency":
  'TBD'

define "Additional Comment":
  'TBD'

define "Physician Name":
  "Requesting Physician".name.family 

define "Physician Telephone":
  UC.Mobile("Requesting Physician".telecom).value

define "Physician Fax":
  Fax("Requesting Physician".telecom).value

define "Referring Physician Telephone":
  'TBD'

define "Date":
  Today()

//helper definitions
// define "All ServiceRequests":
//   [FHIR.ServiceRequest]

// define "Most Recent ServiceRequest":
//   UC.MostRecent("All ServiceRequests")

define "SR Related Condition":
  [FHIR.Condition] C
  where EndsWith(First(ServiceRequest.reasonReference.reference.value), C.id)

define "UTI Diagnostic Reports Last Year":
  [FHIR.DiagnosticReport] C
  where "Abnormal Urine Finding".code in C.conclusionCode.coding.code
  and C.effective	> (Today() - 1 year)

define "Requesting Physician":
  singleton from (
    [USCore.PractitionerProfile] P
  where EndsWith(ServiceRequest.requester.reference, P.id))

define function Fax(contactPoints List<USCore.ContactPoint>):
  singleton from (contactPoints P where P.system = 'fax')
