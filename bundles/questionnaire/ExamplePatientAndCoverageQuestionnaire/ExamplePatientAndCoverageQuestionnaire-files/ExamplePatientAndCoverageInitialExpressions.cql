library ExamplePatientAndCoverageInitialExpressions version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.1.0'
include USCoreCommon version '0.1.0' called UC
include USCoreElements version '0.1.0' called UCE

codesystem "Identifier Type": 'http://terminology.hl7.org/CodeSystem/v2-0203'

code "Member Number": 'MB' from "Identifier Type"
code "Subscriber Number": 'SN' from "Identifier Type"

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

// TODO: Error: Could not resolve data provider for package 'java.util'.
// define "Address":
//   (singleton from Patient.address).line
define "Address":
  { 'TODO: remove hard-coded address' }

define "City":
  Patient.address.city

define "State":
  Patient.address.state

define "Postal Code":
  Patient.address.postalCode

// Coverage

// TODO DM 20240921: Why doesn't this populate in test results when executing CQL? Member ID=null
// TODO: is there a need to check for coverage period and order? also, do we need to check that the payor organization is the same as the source of the prior auth form?
define "Member ID":
  UCE."Member ID"

// TODO DM 20240921: Why doesn't this populate in test results when executing CQL? Policy Number=null
// TODO: is there a need to check for coverage period and order? also, do we need to check that the payor organization is the same as the source of the prior auth form?
define "Policy Number":
  UCE."Policy Number"