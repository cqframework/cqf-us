#### Steps for Adding New Questionnaires

Adding new content to this IG involves several steps. There are multiple ways to complete many of these steps, and this guide highlights one path for adding a new Questionnaire:

1. Select a questionnaire form (e.g. a prior authorization form), which typically is in a non-computable format such as the PDF form [Medical Necessity For Authorization Of Catheters](https://www.hca.wa.gov/assets/billers-and-providers/13-760.pdf)
2. Manually translate or train LLM to translate the PDF content into a FHIR Questionnaire (this can optionally be done first in FSH format but ultimately must be present as an XML or JSON FHIR resource located at the path `input/resources/questionnaire`). An example for the form in #1 can be found [here](https://github.com/cqframework/cqf-us/blob/master/input/resources/questionnaire/MNACQuestionnaire.json).
3. Add the extension `http://hl7.org/fhir/StructureDefinition/cqf-library` to the Questionnaire with the canonical value of the related CQL library.
4. Setup a launch context extension `sdc-questionnaire-launchContext` for the Patient and any parameters the CQL Library has.
5. For each Questionnaire item that should ultimately have an *initial* value assigned, add the extension `http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-initialExpression` with an expression title that will later be used as a link to the related CQL definitions that are responsible for determining the content of the initial value for this item.
6. Create a CQL file located at `input/cql` and remember to name it the same as the end of the canonical URL defined in step #3. An example for the MNAC form can be found [here](https://github.com/cqframework/cqf-us/blob/master/input/cql/MNACInitialExpressions.cql).
7. For each unique initial expression present in the FHIR Questionnaire file, create a definition with the same title in the CQL file created in step #5, and fill those expressions with CQL content.
8. The [CQL VS Code extension](https://marketplace.visualstudio.com/items?itemName=cqframework.cql) allows for right-clicking `Execute CQL`. To successfully investigate if a certain definition results in the desired output, some test resources need to be provided and located in a folder at the following path: `input/tests/library/YOUR-CQL-LIBRARY-NAME`. Sub-folders can define multiple patients filled with multiple resource files. The MNAC test folder with resources of a Patient called *example* can be found [here](https://github.com/cqframework/cqf-us/tree/master/input/tests/library/MNACInitialExpressions/example). 
9. Execute the `_refresh` script (`.sh` or `.bat` as appropriate), and watch multiple things happening automatically:
    * In `bundles/questionnaires`, a new folder with the Questionnaire name is create, which includes a bundle containing the FHIR Library with the CQL content and the related dependency libraries. 
    * In the Library's test folder, a test bundle appears that contains all test resources in one file.
10. Start a local instance of the [Clinical Reasoning enabled HAPI JPA Server Starter](https://github.com/hapifhir/hapi-fhir-jpaserver-starter?tab=readme-ov-file#enabling-clinical-reasoning) (e.g. by using Docker) or use a publicly available FHIR server that supports CQL processing and the [SDC `$populate` operation](https://hl7.org/fhir/uv/sdc/OperationDefinition-Questionnaire-populate.html).
11. Use a REST tool such as Postman to POST the two bundles described in step #9.
12. Test and see if the operation `$populate` for your questionnaire results in the expected initial values for each item. A complete sample Postman collection for a different Questionnaire can be found [here](./postman/USCoreGMTPQuestionnaire.postman_collection.json). This collection also contains automated tests to highlight what to look for. 

#### Frequent Errors

* When refreshing the IG (by executing `sh _refresh.sh`), sometimes errors in the Questionnaire or CQL cause the new content to be ignored and no output bundle being created. A frequent error is that a wrong or non-existent library name is defined within the Questionnaire.json element *cql-library* extension.
* Special Characters in CQL expression titles: The engine will not be able to resolve special characters within CQL expression titles. E.g. `define "Practitioner's phone"` will fail and must be renamed to `define "Practitioner phone"`.
