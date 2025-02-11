### Introduction

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
