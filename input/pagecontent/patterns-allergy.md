


### Allergy Intolerance

US Core defines [US Core Allergy Intolerance](https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-allergyintolerance.html).

This captures allergies / adverse reactions associated with a patient.

The codes come from a set of common substances for allergy documentation in SNOMED and RXNORM (US Core 3.1.1: https://hl7.org/fhir/us/core/STU3.1.1/ValueSet-us-core-allergy-substance.html, US Core 6.1.0: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1186.8/expansion).

#### Current allergies ####

To get all confirmed active allergies, ```UCE."Active Confirmed Allergies and Intolerances"``` can be used. 

>TODO Is there a realistic example for a specific allergy a payer would want to know about for a prior auth that we could include here? I'm not thinking of one.

```cql
define "AllergicToDrugX":
  UCE."Active Confirmed Allergies and Intolerances" A
    where A.code ~ "DrugX"
```

#### No known allergies ####

To check if a patient has confirmed they have no known allergies, use ```UCE."No Known Allergies (Confirmed)"```. This will check for SNOMED 716186003 (No known allergy (situation)) as advised in US Core.


> NOTE: Content for this page was adapted from the [QICore Authoring Patterns - Allergies](https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Authoring-Patterns-QICore-v6.0.0#allergies) topic.