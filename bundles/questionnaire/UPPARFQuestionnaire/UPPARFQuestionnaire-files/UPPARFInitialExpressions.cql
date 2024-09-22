library UPPARFInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.0'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE
include CumulativeMedicationDuration called CMD 

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'
codesystem "Verification Status": 'http://terminology.hl7.org/CodeSystem/condition-ver-status'
codesystem "Condition Clinical": 'http://terminology.hl7.org/CodeSystem/condition-clinical'
codesystem "ICD10": 'http://hl7.org/fhir/sid/icd-10-cm' 

valueset "ICD10 vs": 'http://hl7.org/fhir/sid/icd-10-cm/ValueSet'

code "ICD10 example code": 'example' from "ICD10"
code "Member Number": 'MB' from "Identifier Type"
code "Subscriber Number": 'SN' from "Identifier Type"
code "Confirmed": 'confirmed' from "Verification Status"
code "Active": 'active' from "Condition Clinical"


context Patient

define "Urgency":
"Most Recent Medication Request".priority P
  return (
    if P != 'routine' then 'Urgent'
    else  'Not Urgent'
  )

//TODO: name could also be retrieved by MedicationRequest as a codeable concept if there is no reference
define "Most Recent Medication Name":
  "Most Recent Medication" M
    return M.code.display

define "Is Opioid Treatment":
null //TBD

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

define "Prescription Date":
"Most Recent Medication Request".authoredOn

define "Prescriber Name":
   First(Requester.name).family
   //TODO: should this be First("Requester".name).family with double quotes?
   //TODO: prefix, suffix and given do not work as expected.

define "Prescriber Fax":
  UC.Fax(Requester.telecom).value

define "Prescriber Phone":
  UC.Mobile(Requester.telecom).value

define "Prescriber Pager":
  UC.Pager(Requester.telecom).value

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

//TODO: what is DEA?
define "Prescriber DEA":
  null

define "Prescriber Tax ID":
First (
  "Requester".identifier I
  where I.system = 'urn:oid:2.16.840.1.113883.4.4'
  ).value

define "Prescriber Specialty":
First(RequesterRole.specialty.codes).display

define "Prescriber Email Address":
  UC.Email(Requester.telecom).value

define "Request Type":
//TODO: is this logic correct?
if "Is First Prior Authentication" then
  'New Request' else 'Reauthorization'

define "ICD 10 Codes":
  UCE."Active Confirmed Problem List Items".code.codes C
  where C.system ~ "ICD10 example code".system //"ICD10".id
  return C.code

define "Diagnosis Descriptions":
  UCE."Active Confirmed Problem List Items".code.display

define "Unit Volume of Named Drugs":
  "Dosage Value as String" + "Dosage Unit"

define "Dose": 
  "Dosage Value as String"

define "Route": 
  First("Most Recent Medication Request".dosageInstruction).route.display

define "Most Recent Dosage Instruction":
  singleton from ("Most Recent Medication Request".dosageInstruction)

define "Frequency": 
  "Most Recent Dosage Instruction" DI
    return ToString(DI.timing.repeat.frequency) + ' times per ' 
      + ToString(DI.timing.repeat.period) 
      + DI.timing.repeat.periodUnit

define "Refills": 
  "Most Recent Medication Request".dispenseRequest.numberOfRepeatsAllowed

define "Today":
  Today()

define "Dosage Value as String":
  ToString(("Most Recent Medication Request".dosageInstruction.doseAndRate[0].dose as System.Quantity).value)

define "Dosage Unit":
  ("Most Recent Medication Request".dosageInstruction.doseAndRate[0].dose as System.Quantity).unit

//helper definitions
//TODO: medications are not necessarily a reference but could also be represented by a codeeable concept
define "Most Recent Medication":
singleton from (
  UCE."All Medications" M
    where EndsWith((UCE."Most Recent Medication Request".medication as USCore.Reference).reference, M.id))
 
define "Most Recent Medication Request":
  UCE."Most Recent Medication Request"

define "Prior Prescription":
  "Most Recent Medication Request".priorPrescription

define "Requester":
  UCE."Requester"

define "RequesterRole":
  UCE."RequesterRole"

//email, pager, and fax functions moved to USCoreCommon.cql

//IMPORTANT NOTE: Missing the entire (or majority) of the "Prior Authorization Request for Drug Benefit" section of the quesstionnaire. Expect errors on Postman regarding the items in this section.
define "Start Date and Length":
  null as System.String