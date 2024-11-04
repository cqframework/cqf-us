This topic provides architectural guidance for implementers supporting FHIR and CQL-based questionnaires, typically from a DTR-style application:

* Initial data retrieval to support questionnaire population and initial flow control
    * Minimizing the number of queries
    * Leveraging server-side filters
    * Optimizing for initial question display
    * Managing query inter-dependencies to maximize performance
* Additional data retrieavl and flow control
    * Managing queries that depend on user-entered data
    * Managing when queries need to be re-run
    * Guidance on adaptive query capabilities
* Best practices for
    * Performance data access
    * Readability
    * Accessability (authoring)
    * Maintainability
* Version support best practices

* Questionnaire prepopulation
    * Note that when populating a questionnaire response, if the questionnaire response already has a value for the initial expression, don't populate