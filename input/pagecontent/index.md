### Introduction

> NOTE: This implementation guide has been moved to the [HL7 Common CQL Assets for FHIR - US implementation guide](https://build.fhir.org/ig/HL7/us-cql-ig). See the [HL7 Davinci CQL Questionnaire Project Page](https://confluence.hl7.org/spaces/CDS/pages/256516986/DaVinci+CQL+Questionnaire+Support) for more information

This implementation guide contains architectural guidance and re-usable libraries that facilitate the use of CQL with FHIR in the US Realm, with an initial use case of Prior Authorization Support Questionnaires as described in the [DaVinci Documentation Templates and Rules (DTR)](https://hl7.org/fhir/us/davinci-dtr/) implementation guide.

### Scope of Use

The intent of this guide is to support the use of CQL with FHIR in the US Realm with a focus on:

* Providing architectural guidance for the evaluation of CQL expressions in the context of artifacts such as Questionnaires
* Providing re-usable libraries of CQL expressions to retrieve data for common use cases in the US Realm
* Providing guidance for managing CQL expressions that may involve retrieval of data from multiple versions of US Core
* Gathering requirements for tooling to simplify the authoring of questionnaires that use CQL

#### Out of Scope

This implementation guide does not:

* Define or mandate the use of any particular subsets of CQL
* Define functions for the retrieval of simple elements from already retrieved FHIR resources (e.g. Patient.gender)
* Define expectations for certification that require the use of any of the helper libraries provided in this implementation guide

### Contents

* [Background](background.html)
* [Use Cases](use-cases.html)
* [Architectural Guidance](architectural-guidance.html)
* [Query Management](query-management.html)
* [Examples](examples.html)
* [Tooling Support](tooling-support.html)
* [Testing](testing.html)
* [Artifacts](artifacts.html)
* [Changes](changes.html)
* [Downloads](downloads.html)

### Roadmap

Ballot Schedule:

FHIR IG Proposal to FMG: February 2nd
THO Content Freeze: February 16
NIB Deadline: February 23
Connectathon Proposals: March 11
Consensus Group Signup: March 3
FHIR Core Ballot Freeze: March 18
WG IG Approval: March 18 - April 3
Final Content Deadline: March 30
FHIR Connectathon: May 10
May WGM: May 12

Call Schedule:

* 2/10
  * Roadmap/Ballot Planning Review
  * Versioning Approach Discussion
* 2/24
  * Testing Resources and Patterns
  * Versioning Libraries and Documentation
* 3/10
  * Architectural Guidance Review
  * Authoring Documentation Review
  * Patterns Review
* 3/24
  * Final Feedback/QA Review Prior to Ballot

TODO:

* Move to HL7 repository
* Testing
  * Test Cases Parameters Resources (https://build.fhir.org/ig/HL7/cql-ig/conformance.html#fhir-type-mapping)
  * Test Case Inputs expressed as Parameters in each test case (Parameters-input.json)
  * Unit Tests for Common Calculations (USCoreElementsTests.cql - BSA testing)
  * Remove Practitioner/Organization/Provider-related questions from example questionnaires (move to ExamplePatientAndCoverage)
  * Document mapping from Questionnaire/$populate to Library/$evaluate parameters
  * Document test case structure (w/ inputParameters and expectedResults)
* Architectural Guidance
  * Versioning
    * Multi-version approach
  * Data Requirements Transformation
  * Search Parameters Usage
* Patterns
  * Document high-level patterns for
    * accessing all data, versus "clean" data (i.e. data without modifiers, or with known modifiers), data with particular statuses
      * no implicitRules that we don't understand
      * no modifiers or modifierExtensions that we don't understand
    * e.g. All Allergies vs All Known Confirmed Allergies
  * Patient and Family History
  * Laboratory Testing
  * MedicationRequest
  * AllergyIntolerance
  * ServiceRequest
* Authoring Documentation
  * Workflow diagram illustrating tooling and pattern touchpoints

### In Progress Questions:

#### Context Questions
For each questionnaire specifically, which questions are expected to be answerable from prior authorization context and how?

#### Billing/Servicing Provider

Should these types of questions be part of DTR forms?

Possibilities:
1. Known ahead of time (and part of the ServiceRequest, so doesn't make sense to ask)
2. Not known, but will be specified by a separate process (such as order dispatch)
3. Servicing isn't part of the process

* Directed order - provider has to be on the order
* Undirected order - provider may or may not be on the order, requesting organization may need to specify at some point, but may not care. If provider doesn't care and payer does, having it in the questionnaire potentially gives the payer an opportunity for the in/out of network check to be performed, as well as for the payer to participate in the decision of who the servicing/billing provider is?

Should the question(s) be framed as "Pick one of these in network providers near you?"
Definitely need examples of "Pick an organization from this list", "Pick a practitioner from this list"?
Note that the paper equivalent is "provider name, address, and phone number", whereas the FHIR Questionnaire approach is based on lists

#### Questions related to the Service being Authorized

Authorization for lab tests is sometimes determined based on category (e.g. preventative, treatment, elective). Is this categorization something that would typically be expected to be present in the ServiceRequest (likely not), and if not, how would that be represented, or is it only something that is captured as part of the Prior Authorization process?

Could potentially put it in a "reason", but that may not necessarily be coded in a way that is useful for the payer

#### Urgency
Almost all prior auth forms contain a question about the urgency of the request. Different forms have different ways of expressing the same logic. E.g., the [Humana Uniform Pharmacy Prior Authorization Request Form](https://docushare-web.apps.external.pioneer.humana.com/Marketing/docushare-app?file=2567656) uses check boxes with the strings "Urgent" and "Non-Urgent". The form [Geisinger Medical Benefit Outpatient Drug Authorization Form](https://www.geisinger.org/-/media/OneGeisinger/Files/PDFs/Provider/NaviNet/Forms/medical-benefit-outpatient-drug-authorization-form-050819.pdf?sc_lang=en&hash=6EDE27E13FCCB5731E081FC49B85359D) contains a categorization as "Urgent" more in a boolean logic with a required rationale if the request is labelled as "Urgent". 

Potentially, urgency can be determined by specific FHIR elements such as the MedicationRequest.priority element. In the current implementations, only `routine` codes are determined non-urgent, all other codes (such as `stat`, `asap`, `urgent`).

#### Patterns Questions
* [Allergy](patterns-allergy.md)
* [Condition](patterns-condition.md)
* [Lab](patterns-lab.md)
* [Medication](patterns-medication.md)
* [ServiceRequest](patterns-service.md)
