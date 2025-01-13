


### Medication

US Core defines [US Core MedicationRequest](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-medicationrequest.html) to record a patient's medication prescription or order, as well as self-reported medications.

MedicationRequest can either use a code which will be RXNORM plus an optional NDC (https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1010.4/expansion), or use a reference to a more detailed Medication resource (which also uses RXNORM plus optional NDC).

#### Active Medications ####

> NOTE: In the prior auth use case (https://build.fhir.org/ig/cqframework/cqf-us/use-case-pa.html), the workflow is generally being conducted in the context of 1 or more order, so you'll want to start by working off that context before searching the FHIR server for service requests.

> TODO: in UCE we want a few wrappers for common things people would want from a MedicationRequest (procedure code, who/where requested it, who/where is performing it), however these are currently built on ```UCE."Most Recent MedicationRequest"``` which could be pulling the wrong data. We need our functions structured to support working on the data in context during DTR.

To get all medications, ```UCE."All Medication Requests"``` can be used. To filter it down to active medications, ```UCE."Active Medication Orders"``` can be used.

> TODO: QICore mades dealing with medication as a code vs as a reference easy by having a medication element that handles being either. We still need to add an equivalent to US Core.

> NOTE: Content for this page was adapted from the [QICore Authoring Patterns - Medications](https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Authoring-Patterns-QICore-v6.0.0#medications) topic.