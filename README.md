# CQF US Common

  

This implementation guide contains common FHIR assets for use in US-based CQFramework content IGs, including the USCore-ModelInfo and USCommon libraries.

  

The continuous integration build of this implementation guide is available here:

  

http://build.fhir.org/ig/cqframework/cqf-us

  

Commits to this repository will automatically update the above site.

## Steps for Adding New Questionnaires
Adding new content to this IG involves several steps. There is multiple ways for many of the steps, this small guide should highlight one path for adding a new Questionnaire:
1. Select a Questionnaire form (e.g. prior auth form), which typically is in a non-computable format such as the PDF form [Medical Necessity For Authorization Of Catheters](https://www.hca.wa.gov/assets/billers-and-providers/13-760.pdf)
2. Manually translate or train LLM to translate the PDF content into a FHIR Questionnaire (this can optionally be done first in FSH format but ultimately must be present as an XML or JSON FHIR resource located at the path `input/resources/questionnaire`). An example for the form in #1 can be found at [here](./input/resources/questionnaire/MNACQuestionnaire.json)
3. Add the extension `http://hl7.org/fhir/StructureDefinition/cqf-library` to the Questionnaire with the canonical value of the related CQL library as 
4. For each Questionnaire item that should ultimately have an *initial* value assigned, add the extension `http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-initialExpression` with an expression title that will later be used as a link to the related CQL definitions that is responsible for determining the content of the initial value for this item
5. Create a CQL file located at `input/cql` and remember to name it the same as the end of the canonical URL defined in step #3. An example for the MNAC form can be found [here](./input/cql/MNACInitialExpressions.cql).
6. For each unique initial expression present in the FHIR Questionnaire file, create a definition with the same title in the CQL file created in step #5 and fill those expressions with CQL content.
7. The VS Code extension allows for right-clicking `Execute CQL`. To successfully investigate if a certain definition results in the desired output, some test resources need to be provided and located in a folder at the following path: `input/tests/library/YOUR-CQL-LIBRARY-NAME`. Sub-folders can define multiple patients filled with multiple resource files. The MNAC test folder with resources of a Patient called *example* can be found [here](./input/tests/library/MNACInitialExpressions/example). 
8. Execute `sh _refresh.sh` and watch multiple things happening automatically:
	* In `input/bundles/questionnaires`, a new folder with the Questionnaire name shows up and is filled with a bundle containing the FHIR Library with the CQL content and the related dependency libraries. 
	* In the Library's test folder, a test bundle appears that contains all test resources in one file
9. Start a local instance of the [CQF-Ruler](https://github.com/cqframework/cqf-ruler)  e.g. by using Docker, or use a publicly available FHIR server that supports CQL processing and the operation `$populate`
10. Use a REST tool such as Postman to POST the two bundles described in step #8.
11. Test and see if the operation `$populate` for your questionnaire results in the expected initial values for each item. A complete sample Postman collection for a different Questionnaire can be found [here](./postman/UPPARFPopulate.postman_collection.json). This collection also contains automated tests to highlight what to look for. 

## Notes
The folder _fsh is not used for IG generation, instead, it is there to store the fsh files that were the basis for manual translation (e.g. by using [FSHOnline](https://fshschool.org/FSHOnline/#/)) into the JSON Questionnaires that should subsequently be automatically populated by CQL initial expressions. For instance, the content of the FSH file "input/_fsh/MBODAQuestionnaire.fsh" is copied to the FSHOnline tool and the resulting JSON File is manually stored into "input/resources/questionnaire/MBODAQuestionnaire.json". 

## Frequent Errors
* When refreshing the IG (by executing `sh _refresh.sh`), sometimes errors in the Questionnaire or CQL cause the new content to be ignored and no output bundle being created. A frequent error is, that within the Questionnaire.json element *cql-library* extension, a wrong or non-existent library name is defined. 
* Special Characters in CQL expression titles: The engine will not be able to resolve special characters within CQL expression titles. E.g. `define "Practitioner's phone"` will fail and must be renamed to `define "Practitioner phone"`.

