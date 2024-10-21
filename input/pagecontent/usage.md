To use these libraries in your implementation guide, include a reference to this implementation guide as an implementation guide dependency:

```xml
<dependsOn id="cqf-us">
  <uri value="http://fhir.org/guides/cqf/us/common/ImplementationGuide/fhir.cqf.us.common"/>
  <packageId value="fhir.cqf.us.common"/>
  <version value="0.1.0"/>
</dependsOn>
```

#### USCore ModelInfo

Clinical Quality Language (<a href="http://cql.hl7.org">CQL</a>) is a high-level, domain-specific language focused on clinical quality, and it is targeted at measure and decision support artifact authors. Additionally, the CQL specification provides a machine-readable canonical representation called Expression Logical Model (<a href="https://cql.hl7.org/04-logicalspecification.html">ELM</a>), which is targeted at implementations, and designed to enable automated sharing of clinical knowledge.

To use CQL with USCore, <a href="https://cql.hl7.org/07-physicalrepresentation.html#data-model-references">model information</a> must be provided to the implementation environment. The <a href="Library-USCore-ModelInfo.html">USCore-ModelInfo</a> library provides this information for US Core. To use USCore, include a <a href="https://cql.hl7.org/02-authorsguide.html#data-models">using declaration</a> as shown in the example below:

```cql
using USCore version '3.1.1'
```

Although not required by CQL, current best practice is to include the version of USCore.
