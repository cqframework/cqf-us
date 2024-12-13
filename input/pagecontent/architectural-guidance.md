This topic provides architectural guidance for implementers supporting FHIR and CQL-based questionnaires, typically from a DTR-style application.

This discussion assumes the following:

* A Questionnaire resource with any number of `item` elements, nested to any degree
* A Questionnaire may include any number of `initialExpression`, `candidateExpression` and `calculatedExpression` extensions referencing CQL expressions to be evaluated

In addition, this guidance is provided in addition to the conformance expectations and guidance described in [Pre-populating QuestionnaireResponses](https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#pre-populating-questionnaireresponses) in the DTR implementation guide.

### Initial Data Retrieval

#### Data Access Within CQL

All data access within CQL occurs within the [Retrieve](https://cql.hl7.org/02-authorsguide.html#retrieve) expression. When CQL is packaged within a Library resource, these retrieves are surfaced as `dataRequirement` elements, allowing the complete data expectations for the CQL within the library to be communicated. However, this represents the total data requirements for the library, whereas the Questionnaire may only reference some of the expressions in the library, or the initial state of the Questionnaire may be such that only a subset of questions are enabled and therefore need population.

To address this, static analysis of the CQL can be used to determine the set of data requirements for an expression (or set of expressions), as described in the [Artifact Data Requirements](https://cql.hl7.org/05-languagesemantics.html#artifact-data-requirements) section of the CQL specification. The [DataRequirementsProcessor](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/elm-fhir/src/main/java/org/cqframework/cql/elm/requirements/fhir/DataRequirementsProcessor.java) provides an implementation of this capability. This component can accept a list of the expressions that should be analyzed to determine data requirements.

TODO: Intrinsic library with names driven by linkIds that contains all the in-line CQL expressions and this is the library used to do dependency tracing

* Minimzing the number of queries
* Leveraging server-side filters
* Optimizing for initial question display
* Managing query inter-dependencies to maximize performance

TODO: Provide guidance about making the determination between sending libraries up front versus questionnaire specific libraries (https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#adaptive-form-considerations)

### Additional Data Retrieval and Flow Control

* Managing queries that depend on user-entered data
* Managing when queries need to be re-run
* Guidance on adaptive query capabilities

### Terminology Considerations

https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#value-set-and-code-system-guidance

> Can ValueSets that are not included in the Questionnaire package be referenced? The guidance above is not clear on this point.

TODO: Provide best practice that for value sets that do not have expansions, don't include them in the package

Value set references will be encountered in two different ways in CQL used by a Questionnaire:

1. Within `retrieve` expressions, as the terminology filter
2. Outside of retrieves, as part of a value set membership test

In both cases, the required terminology will need to be made available to the CQL engine. Different approaches can be taken by different CQL engines, but in general they follow:

1. Provide pre-expanded value sets to the engine
2. Provide a terminology service interface to the engine, allowing value sets to be expanded on demand

The first approach is somewhat simpler, though may be less performant, especially when the number and/or size of the value sets is large.

In addition, for performance, the second approach will likely be implemented with caching.

As well, depending on the sensitivity of the questions to updates in code systems, the expansion of value sets used may need to be performed with version-specific references to the code systems and value sets involved.

> Do value sets referenced by (but not distributed in) Questionnaire packages need to be able to specify version dependencies?

TODO: Need to discuss version dependencies and indicate that current best practice is to allow latest, if you have a specific need for a particular version, specify that in the ValueSet definition.

When a value set reference appears within a `retrieve`, the corresponding DataRequirement will include the value set reference. For example:

```cql
define "Glucose Tests":
  [Observation: "Glucose Test Codes"]
```

```json
{
    "type": "Observation",
    "codeFilter": [{
        "path": "code",
        "valueSet": "http://example.org/ValueSet/glucose-test-codes"
    }]
}
```

This data requirement can be satisfied with an appropriate FHIR query:

```
[base]/Observation?subject=Patient/123&code:in=http://example.org/ValueSet/glucose-test-codes
```

However, use of this approach requires that the EHR's FHIR server 1) supports the `:in` modifier for code-based searches, 2) either has or can get the Glucose Test Codes value set, and 3) can perform (or ask for) an appropriate expansion of the value set. To address the situtation where the EHR does not or cannot support code-based searching with value sets, the query may be executed by either:

1. Choosing a less-selective filter (such as `category=laboratory` in this case) (or no filter at all) and then filtering the result in the CQL

```
[base]/Observation?subject=Patient/123&category=laboratory
```

2. Performing the expansion and in-lining the codes

```
[base]/Observation?subject=Patient/123&code=12345,23456,34567
```

> Note that when in-lining large value sets, the resulting search may overflow practical URL length restrictions. In these cases, a POST may be used, and/or the query may be split into multiple requests and combined.

### Performant Data Access

When retrieving the set of data required to evaluate a CQL expression, multi-threading requests can reduce the overall time required to retrieve the data.

TODO: Also discuss the use of the ModuleConfiguration library to support customizing queries used to access data

### Readability

### Authoring

### Maintainability

### Versioning Considerations

### Questionnaire Prepopulation

When populating a questionnaire response, if the questionnaire response already has a value for the initial expression, don't populate