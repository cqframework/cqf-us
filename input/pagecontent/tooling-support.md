This topic provides a set of requirements based on community engagement and stakeholder feedback to understand the level of effort required to achieve the end goal of:
* Supporting a user with deep clinical knowledge but limited technical knowledge being able to build and maintain CQL-based questionnaires
* Potentially prototype the inclusion of CQL authoring capability in a questionnaire authoring environment such as the LHC forms builder

### Requirements

#### Questionnaire Authoring

This topic describes questionnaire-related authoring capabilities that would be needed to support creation of prior-authorization questionnaires:

* Create and maintain questionnaires
    * Edit basic (shareable) metadata including title, url, status and version
    * Edit advanced (publishable) metadata including description, purpose, approvalDate, lastReviewDate, **useContext**
* Create single-item questions
    * Edit basic question information including
        * Question text
        * data type
        * code
        * initial value (as a literal)
        * cardinality
        * required
        * read only
    * Edit advanced question information including
        * Display conditions
        * Terminology server reference
        * Population and extraction capability
* Create groups of questions
    * Arbitrary nesting of groups

The [LHC Forms Builder](https://lhcformbuilder.nlm.nih.gov/) is an open-source questionnaire authoring environment that supports most of this capability (items in bold are not currently supported)

#### CQL Support

In addition to questionnaire authoring capability, the following are areas within that environment that would need to be able to support CQL usage:

* For single-item questions:
    * Initial value expressions
    * Calculated value expressions
    * Enable-when expressions
* For group questions:
    * Population expressions
    * Extraction expressions
    * Enable-when expressions
* Consider the ability to map the code of an question to an existing expression
    * Similar to the way that LHC supports inclusion of a question "based on" a particular LOINC code
    * Consider providing the expression associated with that code automatically
* Consider the ability to map questions or groups of questions to an existing expression
    * Importing a question based on the result of an expression, e.g. Patient history

This support would generally fall into two categories:

* Discovery and Reference: The ability for the environment to search for and provide a reference to an existing expression within a CQL library that could be used as is
* Expression and Element Authoring: The ability for the environment to support authoring new elements and expressions of CQL directly.

##### Discovery/Reference

* Support searching for relevant libraries:
    * Libraries that reference a particular implementation guide
    * Libraries with a particular topic
* Support including a found library in the references for a questionnaire
* Support searching for relevant expressions:
    * Expressions that reference a particular data type/profile
    * Expressions that reference a particular code system or value set
    * Expressions that reference particular codes (either directly or indirectly through value set references)
* Support including a reference to a found expression in the expression for a given questionnaire item

Existing mechanisms that could be used (and potentially enhanced) to support this aspect include:

* NPM Packages - The existing NPM packaging mechanisms for FHIR IGs support distribution of Library resources. The existing NPMPackageManager interface in the Java-based tooling could be used to provide these search capabilities
* CRMI Artifact Repository - The Artifact Repository capability statement defined by the Canonical Resource Management Infrastructure implementation guide provides a basis for the searching capability required here, enhanced search parameters would need to be defined for:
    * Libraries that reference an IG
    * Libraries with expressions that reference a particular data type/profile
    * Libraries with expressions that reference particular codes (either directly or indirectly through value set references)

##### Expression and Element Authoring

* Support creation of a library
    * Inline expressions (the entire expression created is inline in the questionnaire element)
    * Constructed expressions (the expression in the questionnaire element is a reference to an expression in a Library)
* Support construction of element expressions
    * Support relevant element types
        * e.g. Allergy/Intolerance, Condition, Procedure, MedicationRequest, etc.
    * Support terminology selection
        * ValueSet
        * Code
    * Support filter expressions
        * Logical groupings (`and`/`or`)
        * Presence/absence
        * Terminology (`in`/`~`)
        * Comparison
        * Temporality
        * Relationships to other elements (including contextualization)
    * Support reuse of existing elements
* Support construction of inclusion expressions
    * Boolean-valued expressions that can reference elements (existing or in-line)
    * Filtering expressions

The [CDS Connect Authoring](https://cds.ahrq.gov/cdsconnect/authoring) is an open source CQL authoring environment that supports much of this functionality
