The following approaches can be used to test CQL-based Questionnaires:

### Unit Testing

As with all CQL-based artifact development, CQL libraries used in CQL-based Questionnaires should be tested with focused test cases that ensure expected behavior. These are effectively "unit tests" for the CQL library, and can be authored and validated with the VSCode CQL Plugin:

https://github.com/cqframework/vscode-cql/wiki/User-Guide#adding-test-data

Each of the libraries in this implementation guide have associated test cases defined in the input/tests directory.

### Integration Testing

Based on the DTR sequence diagram, the following 3 integration test scenarios are identified:

![Integration Test Scenarios](images/integration-test-scenarios.png)

1. Questionnaire Package Response
2. EHR FHIR Queries
3. Questionnaire Populate

#### Questionnaire Package Response

The [DTR Inferno Test Kit](https://inferno.healthit.gov/test-kits/davinci-dtr/) supports verifying the result of the $questionnaire-package operation:

#### EHR FHIR Queries

The [DTR SMART on FHIR App](https://github.com/HL7-DaVinci/dtr) has facilities for end-to-end testing of the DaVinci DTR questionnaire use case, including questionnaire population and EHR FHIR queries.

#### Questionnaire Populate

The Questionnaire populate aspect can be tested with a REST client (such as Postman) and a FHIR server that implements the Questionnaire/$populate operation.

The source repository for this implementation guide contains Postman collections that test this operation for each of the included example questionnaires:

[Postman Collections](https://github.com/cqframework/cqf-us/tree/master/postman)

