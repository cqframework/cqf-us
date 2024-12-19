


### Condition

USCore defines [USCore Condition Encounter Diagnosis](https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-condition-encounter-diagnosis.html) and [USCore Condition Problems and Health Concerns](https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-condition-problems-health-concerns.html).

Many clinical systems make a distinction between the active conditions for a patient (i.e. the problem list or health concerns) and the diagnoses associated with an encounter. Problem list items and health concerns are typically documented with additional information about the condition such as prevalence period and clinical status, while encounter diagnoses typically have less information, usually only the diagnosis code as part of the encounter information. Within FHIR, both these types of data are represented using the Condition resource. The category element is used to indicate which kind of data the Condition represents, a problem list item, a health concern, or an encounter diagnosis.

Typical code systems for Condition.code include ICD-10, SNOMED, and LOINC. For historical conditions there will also be ICD-9.

#### Associated Condition ####
Often the most relevant condition/diagnosis is available in the context of the workflow (such as ServiceRequest.reason or Encounter.reason). For prior auth the condition/diagnosis associated with the orders getting prior auth should already be known to the payer during CRD or PAS prior to returning the questionnaire, so it's best practice not to ask for it again in the questionnaire.


#### Active Conditions ####

In USCore 3.1.1, ```UCE."All Conditions"``` can retrieve everything. Example to check for diabetes:
```cql
define "Active Diabetes Conditions":
  [UCE."All Conditions": "Diabetes"] Condition
    where Condition.isActive()
```

>TODO this following section won't work unless we have a profile similar to https://hl7.org/fhir/us/qicore/STU5/StructureDefinition-qicore-condition-problems-health-concerns.html. Is that what we want (would the new profiles come from importing a 6.1.0 US Core model?), or is there some other way to write the CQL?

In USCore 6.1.0, the ConditionProblemsHealthConcerns limits the scope of the conditions searched to exclude encounters.
```cql
define "Active Diabetes Conditions":
  [ConditionProblemsHealthConcerns: "Diabetes"] Condition
    where Condition.isActive()
```

#### Historical Conditions ####

To answer questions like "Have you ever been diagnosed with diabetes" use ```UCE."All Conditions"```.

>TODO same US Core 6.1.0 profile question

And in US Core 6.1.0 use a union of ConditionProblemsHealthConcerns and ConditionEncounterDiagnosis.
```cql
define "History of Diabetes":
  [ConditionProblemsHealthConcerns: "Diabetes"]
    union [ConditionEncounterDiagnosis: "Diabetes"]
```

If you have more filters such as excluding things that were refuted you can include those:
```cql
define "History of Diabetes":
  ([ConditionProblemsHealthConcerns: "Diabetes"] Condition
    where Condition.verificationStatus is not null implies Condition.verificationStatus !~ "refuted"
  ) union (
    [ConditionEncounterDiagnosis: "Diabetes"] 
  )
```

To answer questions like "Have you had COVID in the past 3 months", use ```prevalenceInterval```:
>TODO figure out how to write this example
```cql
```


> Some of this content is adapted from https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Authoring-Patterns-QICore-v6.0.0#conditions



> TODO we had talked about calling out limitations around how there are useful search parameters (like Condition.code) that are only optional in US Core, so CQL engines should consider checking capability statements to have efficient queries- but this doesn't seem like an authoring pattern. where should that info go?



#### non-guide loose notes below, remove this before commit ####
Encounter diagnosis https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-condition-encounter-diagnosis.html

pattern to get main condition code
status(only care about active, filter out resolved)
  medical policy may ask for "history of something", and some interpretation comes in on that
  time frame and status requirements could vary by condition and payer interpretation
  and might not be spelled out in policy
date(payers care about time frame, make sure that's included)
  can we search by time frame?
    make sure we have something in common library that encapsulates:
    *There is no single element in Condition that represents the date of diagnosis. It may be the assertedDate Extension, Condition.onsetDateTime, or Condition.recordedDate.
    Although all three are marked as Must Support, the server is not required to support all.
    A server SHALL support Condition.recordedDate.
    A server SHALL support at least one of assertedDate Extension and Condition.onsetDateTime. A server may support both, which means they support all three dates.
    The client application SHALL support all three elements.

    look at prevalenceInterval to simplify dates problem

what type of UM timeframe questions come up related to conditions?
  "have you ever been diagnosed with X"
  "have you had X in the past 3 months" (ex: covid)

  there are some related discussion/patterns around dates in quality space- start looking there

codes: SNOMED CT, ICD-10. for historical, also has ICD-9

search capabilities
mandatory: 
  patient
  category (problem list / health concern / encounter diagnosis)
optional: 
  code (people will want this almost all the time)
  clinical-status (common to only want active)
  onset-date / asserted-date / recorded-date / abatement-date / _lastUpdated (probably used a lot)
  encounter (some payers will care about which encounter. its more rare in prior auth)
for dealing with optional search params, do we encapsulate that in CQL logic in common library?
  often also a list of codes, characterized as a value set
  how to communicate set of codes to server
    and that doesn't line up with current pattern: GET [base]/Condition?patient=1032702&code=[http://snomed.info/sct|442311008]

    can have valueset expanded by the engine, and have it inlined in URL (has its own problems, split queries)
      heuristics for if its worth it, complex


problems and health concerns https://build.fhir.org/ig/HL7/US-Core/StructureDefinition-us-core-condition-problems-health-concerns.html

ways it differs from encounter-diagnosis:
category code “problem-list-item” or “health-concern”
timestamp of last changed matters (as opposed to date of associated encounter). it spans encounters
verification might matter more here to know if it is still relevant
also has social determinants of health (how relevant that is to prior auth?). if it is relevant, look at screening assessments

clinical status should be set for problem list, but might not for encounter dx

looking at QI Core, we pulled in the main description of encounter vs health problem

Functions we have in the library that may be worth calling out:
"All Conditions"
"Active Confirmed Problem List Items"
"All Encounter Diagnoses"
"All Health Concerns"

Do payers need to know the encounter where a diagnosis happened? If so, document something like
define "Encounters with a Diabetes Condition":`
  `"Completed Encounters During the Measurement Period" CompletedEncounter`
    `where exists (`
      `(CompletedEncounter.encounterDiagnosis()) EncounterDiagnosis `
        `where EncounterDiagnosis.code in "Diabetes"`
    `)
and point to encounter patterns


history of condition
make us core version of:
define "History of Diabetes":`
  `([ConditionProblemsHealthConcerns: Diabetes] Condition`
    `where Condition.verificationStatus is not null implies Condition.verificationStatus !~ "refuted"`
  `) union (`
    `[ConditionEncounterDiagnosis: Diabetes] Condition`
      `where Condition.getEncounter().status = 'finished'`
  `)



CQL functions that QICore has that we don't
CompletedEncounter
ConditionProblemsHealthConcerns
ConditionEncounterDiagnosis
refer to https://github.com/HL7/fhir-qi-core/blob/master/input/cql/QICoreCommon.cql, maybe we want to copy over
condtion searches (code is most important, but its optional. how do we deal with that?)
talk to bryn
  the current USCoreElements contents are based on US Core content- probably some outstanding work to
  copy of QI Core patterns that weren't in the scope

US Core differences:
in 3.1.1, encounter dx and problem / health concern are a single profile
though it still has the category
encounter-dx is presumed active, but problem list need to check clinical-status


