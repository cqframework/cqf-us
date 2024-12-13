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

| Outstanding Area | Status | Target Call |
|----|----|----|
| Architectural Guidance | To Do | 11/18 |
| Tooling Support | In Review | 11/4 |
| Query Management Considerations | To Do | 11/18 |
| Example Details | To Do | 11/18 |
| Patient and Family History | In Progress | 12/2 |
| Laboratory Testing Patterns | To Do | 12/2 |
| MedicationRequest Patterns | To Do | 12/2 |
| AllergyIntolerance Patterns | To Do | 12/2 |
| ServiceRequest Patterns | To Do | 12/2 |
| Feedback Review | To Do | 12/18 |
