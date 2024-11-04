This topic provides best-practices and patterns for authoring CQL expressions for each type of data accessed in CQL-based questionnaires:

### Methodology

US Core is the baseline for expected interoperability; this implementation guide builds CQL authoring patterns on top of US Core. To establishe a new set of patterns, the following methodology is used:

1. Choose a US Core profile (https://build.fhir.org/ig/HL7/US-Core/index.html#us-core-profiles) to start with.
2. Review the narrative, elements, and search parameters, building a list of what would commonly be used and benefit from having an authoring pattern defined.
3. Compare those patterns with QI Core (https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Authoring-Patterns-QICore-v6.0.0) to see if we can align.
4. Evaluate if our libraries (https://build.fhir.org/ig/cqframework/cqf-us/artifacts.html#knowledge-artifacts-libraries) already support the pattern or if more functions need to be added.
5. Add the patterns to a local copy of https://build.fhir.org/ig/cqframework/cqf-us/, with pages split out by US Core profile. For each include a CQL example (ex: https://build.fhir.org/ig/cqframework/cqf-us/patterns-patient.html).
6. Evaluate if there are any differences with older versions of US Core that should be called out (at time of writing, most systems are on 3.1.1, working on moving to 6.1.0 by Jan 1st 2026, and planning for 7.0.0 by Jan 1st, 2028).
7. Review the proposed patterns and underlying profile on a community call to solicit feedback on if they will help, if there are any additional considerations to call out (ex: maybe something is inconsistently populated in EHRs and the pattern needs to be more robust), if more patterns are needed, etc.
8. Once reviewed, publish the patterns.

Note that things like community calls, GitHub issues, and trying to support example questionnaires can also feed into adding more patterns outside of this methodology.

The following table lists the patterns page for each profile:

|US Core Profile|Patterns|Status|
|----|----|----|
|[USCore AllergyIntolerance]({{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-allergyintolerance.html)|[AllergyIntolerance Patterns](patterns-condition.html)|in-progress|
|[USCore Condition]({{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-condition.html)|[Condition Patterns](patterns-condition.html)|in-progress|
|[USCore Coverage]({{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-coverage.html)|[Coverage Patterns](patterns-coverage.html)|todo|
|[USCore Patient]({{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-patient.html)|[Patient Patterns](patterns-patient.html)|draft|


Elements from current example questionnaires:

* DiagnosticReport - Query for and attach to response, but not necessarily drive any particular questions out of the contents
* Laboratory Results
* Clinical Tests
* Family History - including age at diagnosis, availability for testing (e.g., family member deceased, refused testing or patient not in contact with affected family member) and any genetic testing performed on family member (attach pedigree, if available)
* Patient History
* Is Test Part of a Clinical Trial
* ServiceRequest
* MedicationRequest
* Associated Procedures for a Request (given a particular prior auth there will sometimes be additional associated prior authorizations required)
    * for example, given an allergy appointment, you're probably gonna have additional testing
