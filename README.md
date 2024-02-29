# CQF US Common

This implementation guide contains common FHIR assets for use in US-based CQFramework content IGs, including the USCore-ModelInfo and USCommon libraries.

The continuous integration build of this implementation guide is available here:

http://build.fhir.org/ig/cqframework/cqf-us

Commits to this repository will automatically update the above site.

The folder _fsh is not used for IG generation, instead, it is there to store the fsh files that were the basis for manual tranlation (e.g. by using [FSHOnline](https://fshschool.org/FSHOnline/#/)) into the JSON Questionnaires that should subsequently be automatically populated by CQL initial expressions. For instance, the content of the FSH file "input/_fsh/MBODAQuestionnaire.fsh" is copied to the FSHOnline tool and the resulting JSON File is manually stored into "input/resources/questionnaire/MBODAQuestionnaire.json". In addition to the JSON file, a related CQL file is created in "input/cql/MBODAInitialExpressions.cql" to contain all initial expressions for prefilling the questionnaire when calling the operation $populate. When generating the IG, automatically a bundle with all required resources (e.g. Libraries) is created. An example of using this bundle and testing the operation $populat can be found in the folder "postman".