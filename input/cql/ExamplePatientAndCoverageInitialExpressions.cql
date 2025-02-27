library ExamplePatientAndCoverageInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.0'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'

code "Member Number": 'MB' from "Identifier Type"
code "Subscriber Number": 'SN' from "Identifier Type"

parameter "Coverage" FHIR.Coverage
parameter "ServiceRequest" FHIR.ServiceRequest

context Patient

// Patient

define "Patient Name":
  UCE."Name - First Middle(s) Last"

define "Date of Birth":
  Patient.birthDate

define "Birth Sex":
  Patient.birthsex

define "Medical Record Number":
  UCE."Medical Record Number"

define "Phone Number":
  UC.Mobile(Patient.telecom).value

define "Email Address":
  UC.Email(Patient.telecom).value

define "Address":
  (singleton from Patient.address).line

define "City":
  Patient.address.city

define "State":
  Patient.address.state

define "Postal Code":
  Patient.address.postalCode

// Coverage
// define "Coverage":
//   First(clinical C where C is FHIR.Coverage)

// TODO: is there a need to check for coverage period and order? also, do we need to check that the payor organization is the same as the source of the prior auth form?
define "Member ID":
  UCE.MemberID(Coverage)

// TODO: is there a need to check for coverage period and order? also, do we need to check that the payor organization is the same as the source of the prior auth form?
define "Policy Number":
  UCE.PolicyNumber(Coverage)

define "Most Recent ServiceRequest":
  ServiceRequest

define "Requesting Provider":
  UCE.RequestingProvider("Most Recent ServiceRequest")

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

define "Servicing Provider":
  UCE.ServicingProvider("Most Recent ServiceRequest")

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