USCore defines the [USCore Patient]({{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-patient.html)

### Modifier Elements

### Search Parameters

### Cross-Version Considerations

TODO: Determine how to access member ID in a 3.1.1 context (where there isn't a Coverage profile)

### Common Elements and Functions

#### Member ID

The [USCore 6.1 Coverage Profile](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-coverage.html) defines a slice on identifier called `memberid` that can be used to access the patient's member id

```cql
define "Covered Member ID":
  Coverage.memberId()
```

#### Subscriber ID

#### Patient age
_Updated 2024-07-28_

Patient information includes the birth date, and CQL provides a built-in function to calculate the age of a patient, either current age (i.e. as of now), or _as of_ a particular date. In quality improvement artifacts, age is typically calculated _as of_ a particular date. In the context of a Questionnaire, this is typically just today's date, and can be accessed using the `ageInYears()` function:

```cql
define "Patient Age Between 50 and 75":
  Patient.ageInYears() between 50 and 75
```

> NOTE: The [AgeInYearsAt](https://cql.hl7.org/09-b-cqlreference.html#ageat) function in CQL uses the data model (QICore in this case) to understand how to access the patient's birth date information.

> NOTE: CQL supports age calculation functions using both `Date` and `DateTime` values. In both cases the function is shorthand for a date/datetime duration calculation. If the `DateTime` overloads are used, note that the timezone offset is considered and there may be edge cases that result in unexpected results, depending on how large the timezone offset is from the execution timestamp. To avoid these edge cases, best practice is to use the `date from` extractor as shown in the above pattern to ensure the `Date` calculation is used.

#### Patient gender
_Updated 2024-07-28_

Patient gender in FHIR is represented using codes from the [AdministrativeGender](https://hl7.org/fhir/R4/codesystem-administrative-gender.html) code system:

```cql
define "Patient Is Male":
  Patient.gender = 'male'
```

> NOTE: Terminology-valued elements in FHIR resources are _bound_ to _value sets_. The gender element is an example of a _required_ binding, which means that only the codes in the bound value set are allowed to be used. This allows the logic in this example to compare using the actual string `'male'`. In general, terminology-valued elements should be compared using terminology operators. For more information, see the [Using Terminology](https://hl7.org/fhir/us/cqfmeasures/using-cql.html#use-of-terminologies) topic in the Quality Measure IG.

#### Patient race and ethnicity
_Updated 2024-07-28_

US Core defines extensions for representing the race and ethnicity of a patient using the CDC's race and ethnicity codes. When authoring using USCore, these extensions can be accessed directly on the patient using the "slice name" of the extension:

```cql
define "Patient Race Includes Alaska Native":
  Patient P
    where exists (P.race.ombCategory C where C ~ "American Indian or Alaska Native")
      and exists (P.race.detailed C where C ~ "Alaska Native")
```

> NOTE: CQL uses the data model (USCore in this case) to understand how to access patient information using the `Patient` definition. This definition is available in `Patient` contexts.

#### Patient deceased
_Updated 2024-07-28_

Some elements in USCore profiles allow for values to be represented in different ways. For example, the `deceased` element allows values of `Boolean` and `DateTime`. This means that the value of the `deceased` element for any particular patient may be either a Boolean (`true` or `false`) or a DateTime. In FHIR and CQL, these types of elements are called _choice_ types.

> NOTE: Because the USCore model is using CQL system-defined types (see the [FHIR Type Mapping](https://hl7.org/fhir/us/cqfmeasures/using-cql.html#fhir-type-mapping) topic), the spelling of the types uses the CQL type names (e.g. `Boolean` rather than `boolean`).

When accessing choice types in CQL expressions, authors can typically just treat the element as the type they are interested in accessing. For example:

```cql
define "Patient Is Deceased":
  Patient.deceased is true

define "Patient Deceased During Measurement Period":
  Patient.deceased during day of "Measurement Period"
```

In the first expression, the `deceased` element is treated as a Boolean, whereas in the second expression, the `deceased` element is treated as a DateTime.

> NOTE: No value conversions take place when accessing choice types, when using the "Patient Is Deceased" expression above, for example, if the Patient record has a DateTime value for the deceased element, the result of that expression will be `false`.

> NOTE: Content for this page was adapted from the [QICore Authoring Patterns - Patient](https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Authoring-Patterns---QICore-v4.1.1#patient) topic.

