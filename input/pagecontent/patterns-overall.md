### Overall

* Document high-level patterns for
  * accessing all data, versus "clean" data (i.e. data without modifiers, or with known modifiers), data with particular statuses
    * no implicitRules that we don't understand
    * no modifiers or modifierExtensions that we don't understand
  * e.g. All Allergies vs All Known Confirmed Allergies

#### Element Considerations

Whether logic in general should make use of the various elements of a resource (or profile of a resource) depends on measure or rule intent. However, there are some general guidelines that should be followed to ensure correct expression and evaluation of CQL.

##### Element Cardinality

To begin with, all elements in FHIR resources and profiles have a cardinality that determines whether and how many values may appear in that element. Cardinality is expressed as a range, typically from `0` or `1` to `1` or `*`. A cardinality of `0..1` means the element is optional. A cardinality of `1..1` means the element is required. A cardinality of `0..*` means the element may appear any number of times, and a cardinality of `1..*` means the element must appear at least once, but may appear multiple times. Although other cardinalities are possible, those described above are the most common.

NOTE: Cardinality determines whether and how many values may appear for a given element, but the fact that an element is specified as required (e.g. 1..1) does not mean that expressions using that profile must use that element.

##### Must Support Elements

In addition, elements in FHIR resources and profiles may be marked _must support_, meaning that implementations are required to provide values for the element if they are present in the system. To ensure expression logic can be evaluated correctly, expressions should only make use of elements that are marked must support (or otherwise have a reasonable expectation of being present). For a complete discussion of this aspect, refer to the [MustSupport Flag](https://hl7.org/fhir/us/core/must-support.html) topic in the US Core Implementation Guide.

##### Modifier Elements

And finally, elements in FHIR resources and profiles may be marked as _modifier_ elements, meaning that the value of the element may change the overall meaning of the resource. For example, the `clinicalStatus` element of a `Condition` is a modifier element because the value determines whether the `Condition` overall represents the presence or absence of a condition. As a result, for each modifier element, authors must carefully consider whether each possible value would impact the intent of the expression.

###### Modifier Extensions

In addition to modifier elements, extensions in FHIR may be modifier extensions, and any FHIR resource that has modifier extensions that are not understood cannot be processed. Applications may consider performing this check as part of the overall environment, or the CQL logic may be used to ensure that either no modifier extensions are specified, or that only expected modifier extensions are present using the [`checkModifiers()`](https://hl7.org/fhir/fhirpath.html#functions) function.

#### ImplicitRules

A key modifier element that must be considered for any FHIR resource is [`implicitRules`](https://hl7.org/fhir/R4/resource-definitions.html#Resource.implicitRules). If this element is specified, it must be respected and understood. Applications may consider performing this check as part of the overall environment, or the CQL logic may be used to ensure that either no implicit rules are specified, or that the implicitRules are expected:

```cql
define fluent function checkImplicitRules(resource Resource, knownImplicitRules String):
  Message(
    resource, 
    resource.imiplicitRules !~ knownImplicitRules, 
    'implicit-rules-check', 
    'Error', 
    'Implicit rules check failed for resource ' + resource.resourceType + '\' + resource.id
  )
```
#### Accessing Data

To summarize, _cardinality_ determines whether data will be present at all, _must support_ determines whether the element can reasonably be expected to be present, and _modifier_ elements must always be considered to determine the impact of possible values of the element on the result of the expression.

With these element considerations in mind, there are some general patterns for accessing data within CQL using the [Retrieve](https://cql.hl7.org/02-authorsguide.html#retrieve) expression:

```cql
define "All Allergies and Intolerances":
  [USCore."AllergyIntolerance"]
```

This retrieve expression consists only of the name of the profiled resource being requested, and will result in all AllergyIntolerance resources that conform to the profile being retrieved.

Because the `clinicalStatus` and `verificationStatus` elements of the AllergyIntolerance resource are modifier elements, they should be considered whenever accessing and using these types of resources.

The `USCoreCommon` library provides fluent functions for checking these status elements:

```cql
define "Active Confirmed Allergies and Intolerances":
  "All Allergies and Intolerances".allergyActive().allergyConfirmed()
```

