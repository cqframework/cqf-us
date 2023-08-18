library OfficialName version '0.1.0'

using USCore version '3.1.1'
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' 

context Patient

define "Usual Name":
  First(
    Patient.name name
      where name.use ~ 'usual'
  )

define "Official Name":
  First(
    Patient.name name
      where name.use ~ 'official'
  )

define "First Occurrence of Non-Official, Non-Usual Name":
  First(
    Patient.name name
      where not(name.use ~ 'official') and not(name.use ~ 'usual')
  )

define "Name":
  Coalesce("Official Name", "Usual Name", "First Occurrence of Non-Official, Non-Usual Name")

// TODO: Correct this once USCore.HumanName.given works as expected
// define "First Name":
//   "Name".given[0]

// TODO: Correct this once USCore.HumanName.given works as expected
// define "Middle Names":
//   Combine(Skip("Name".given, 1), ' ')

define "Last Name":
  "Name".family

// TODO: Correct this once USCore.HumanName.given works as expected
define "Name - First Middle(s) Last":
  //Combine("Name".given, ' ') + ' ' + "Name".family
  "Name".family

// TODO: Correct this once USCore.HumanName.given works as expected
define "Name - Last, First Middle(s)":
  //"Name".family + ', ' + Combine("Name".given, ' ')
  "Name".family