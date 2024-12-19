


### Services

US Core defines [US Core ServiceRequest](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-servicerequest.html) to track the proposal / planning / ordering of a service, and [US Core Procedure](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-procedure.html) to track performing a service.

Typical procedure codes include SNOMED-CT, CPT, HCPCS II, ICD-10-PCS, CDT, and LOINC.

#### Performed Procedures ####

To get procedures that have been performed, use ```UCE."All Performed Procedures"```. This will return all Procedure resources with a status of 'completed'.

#### Requested Services ####

> NOTE: In the prior auth use case (https://build.fhir.org/ig/cqframework/cqf-us/use-case-pa.html), the workflow is generally being conducted in the context of 1 or more order, so you'll want to start by working off that context before searching the FHIR server for service requests.

> TODO: in UCE we want a few wrappers for common things people would want from a ServiceRequest (procedure code, who/where requested it, who/where is performing it), however these are currently built on ```UCE."Most Recent ServiceRequest"``` which could be pulling the wrong data. We need our functions structured to support working on the data in context during DTR.

If you need to search for requested services, this is made available with ```UCE."All ServiceRequests"```.

> TODO: in US Core 3.1.1 there isn't a profile for ServiceRequest, so the code is backed by ```define "All ServiceRequests": [FHIR.ServiceRequest]```. In US Core 6.1.0 there is a profile, so it would end up being based on pulling in ```"ServiceRequestProfile"``` instead. We'll need to plan for how to handle multi version differences here.

> NOTE: Content for this page was adapted from the [QICore Authoring Patterns - Procedures](https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Authoring-Patterns-QICore-v6.0.0#procedures) topic.