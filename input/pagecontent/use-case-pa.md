### Prior Authorization Questionnaire Use Case

Links to resources for current prior authorization scenarios:

* [Prior Authorization and Pre-Claim Review Program Stats (cms.gov)](https://www.cms.gov/files/document/prior-authorization-and-pre-claim-review-program-statistics.pdf)
* [Prior Authorization for Certain Hospital Outpatient Department (OPD) Services \| CMS](https://www.cms.gov/data-research/monitoring-programs/medicare-fee-service-compliance-programs/prior-authorization-and-pre-claim-review-initiatives/prior-authorization-certain-hospital-outpatient-department-opd-services)
* [Preauthorization and Notification Lists for Healthcare Providers - Humana](https://provider.humana.com/coverage-claims/prior-authorizations/prior-authorization-lists)

### Data Flow

The questionnaire examples and associated libraries for population expressions in this IG are expected to be used in the following data flow:

<div>
<img src="dtr-data-flow.svg"/>
</div>

1. DTR Launch: [Retrieving Launch Context Information](https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#retrieving-launch-context-information)
2. $questionnaire-package: [Retrieving Questionnaire Packages](https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#retrieving-questionnaire-packages)
3. Questionnaire Package Bundle(s): [DTRQuestionnairePackageBundle](https://build.fhir.org/ig/HL7/davinci-dtr/StructureDefinition-DTR-QPackageBundle.html)
4. Questionnaire Pre-Population: [Pre-Populating Questionnaire Responses](https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#pre-populating-questionnaireresponses)
5. FHIR API Calls (resulting from questionnaire pre-population): [Retrieval of FHIR Resources](https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#retrieval-of-patient-fhir-resources-to-supply-to-cql-execution-engine)

As described in the DTR implementation guide, the DTR process can be used for a broad range of use cases, including launching from a <a href="https://build.fhir.org/ig/HL7/davinci-dtr/usecases.html#relation-to-coverage-requirements-discovery-crd">Coverage Requirements Discovery</a> response, as well as requesting documents as described in the <a href="https://build.fhir.org/ig/HL7/davinci-dtr/usecases.html#relation-to-clinical-data-exchange-cdex">Relationship to Clinical Data Exchange</a> topic.

This diagram is a simplification of the overall DTR <a href="https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#overview">Overview Sequence Diagram</a>. This diagram is focusing on the interactions from the perspective of CQL authoring and evaluation.

SDC documents the use of several extensions for supporting CQL-based calculation and form behavior within a Questionnaire in the <a href="https://hl7.org/fhir/uv/sdc/STU3/behavior.html#calculations">Form Behavior and Calculation</a> topic.

In addition, the DTR specification provides additional guidance and conformance requirements on the use of CQL within DTR Questionnaires in the <a href="https://build.fhir.org/ig/HL7/davinci-dtr/specification.html#use-of-cql">Use of CQL</a> topic.

The content and questionnaires in this IG are expected to already have resolved the question of coverage determination, and are focused on a particular individual represented as a Patient. If prior authorization is not required than the DTR process will not occur.

The Coverage resource includes a subscriberId element; however, this is expected to be the Subscriber ID associated with the already established Member ID (individual). That is to say Subscriber ID is the plan-level identifier for an individual that has the plan, whereas Member ID is specific to the individual beneficiaries of the plan.

Following the above data flow, there are two key contexts in which CQL expressions may be used to populate questionnaire responses:

1. On the provider side, during the population step of questionnaire processing in the DTR application.
2. On the provider side, as part of form behavior (e.g. enableWhen processing) while the form is being filled out (including the possibility that answers to questions change the available context and form behavior).
  
Note: Implementations of $questionnaire-package may pre-populate elements of the QuestionnaireResponse; however, how that pre-population occurs payer-side is out of scope from both the CRD and DTR perspectives.

#### CQL Processing to Pre-Populate the QuestionnaireResponse

As part of the process of filling out a DTR questionnaire, the DTR application may use CQL expressions specified in the Questionnaire to access the provider's FHIR server to determine the initial value for items in the QuestionnaireResponse.

CQL used in this operation:

* Will have a Patient context specified as the id of the patient in the DTR launch context and referenced by the QuestionnaireResponse. This is declared as a parameter through the SDC <a href="https://hl7.org/fhir/uv/sdc/StructureDefinition-sdc-questionnaire-launchContext.html">Launch Context</a> extension.
    * For example, a Patient context specified in the DTR launch context will be correlated with an sdc-questionnaire-launchContext extension with a name of <code>patient</code> and a type of <code>Patient</code>, and thereby established as the <a href="https://cql.hl7.org/02-authorsguide.html#context">Patient context</a> for the CQL expressions specified in the Questionnaire. It would be the responsibility of the DTR application to reconcile such launch contexts.
* May declare additional parameters through the SDC Launch Context extension.
    * For example, an Encounter context specified in the DTR launch context may be correlated with an sdc-questionnaire-launchContext extension with a name of <code>encounter</code> and a type of <code>Encounter</code>, and thereby passed as a named parameter to CQL expressions specified in the Questionnaire.
* May declare additional parameters through the SDC <a href="https://hl7.org/fhir/uv/sdc/StructureDefinition-sdc-questionnaire-itemPopulationContext.html">Item Population Context</a> extension.
    * For example, an sdc-questionnaire-itemPopulationContext extension can be used to provide context to a group of related questions by querying for a record or records (e.g. Observations), and this provides a named parameter for use in specified CQL expressions for that group.

Generally, the SDC <a href="https://hl7.org/fhir/uv/sdc/StructureDefinition-sdc-questionnaire-initialExpression.html">Initial Expression</a> extension will be used to pre-populate a given item in the QuestionnaireResponse. This is how CQL expressions are specified in the Questionnaire.

#### CQL Processing to Determine Form Behavior

While a user is filling out the answers to a questionnaire, the DTR application may use CQL expressions specified in the questionnaire to control form behavior (such as enableWhen logic or calculation logic).

