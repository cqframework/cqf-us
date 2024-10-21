This topic provides query management guidance for implementers to support the use of CQL within FHIR questionnaires, typically from a DTR application:

* Develop a library of reusable CQL expressions and functions that
    * Manage optional server-side parameters
    * Check for modifier elements and extensions
    * Manage optional _include and _revInclude situations
    * Manage _element filtering
    * Manager version differences among servers
    * Provide simpler functions with typical search parameter filters (e.g. including only final and amended observations)
    * Manage extension retrieval for extensions expected to be present (e.g. USCore and CRD extensions)
* Complex element retrieval
    * Establish a core set of complex element functions such as body surface area

* [Authoring](authoring.html)
* [Patterns](patterns.html)
* Libraries
    * [USCoreCommon](Library-USCoreCommon.html)
    * [USCoreElements](Library-USCoreElements.html)
    * [USCoreTests](Library-USCoreTests.html)