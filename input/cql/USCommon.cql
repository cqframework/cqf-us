/*
@author: Bryn Rhodes
@description: Common terminologies and functions used in US-based FHIR-based CQL artifacts
*/
library USCommon version '4.0.1'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

context Patient

/*
@description: Returns any US Core extensions defined on the given resource with the specified id.
@comment: NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the CQL model info.
*/
define function USExtensions(domainResource DomainResource, id String):
  domainResource.extension E
	  where E.url = ('http://hl7.org/fhir/us/core/StructureDefinition/' + id)
		return E

/*
@description: Returns the single US Core extension (if present) on the given resource with the specified id.
@comment: This function uses singleton from to ensure that a run-time exception is thrown if there
is more than one extension on the given resource with the specified url.
*/
define function USExtension(domainResource DomainResource, id String):
  singleton from USExtensions(domainResource, id)

/*
@description: Returns any US Core extensions defined on the given element with the specified id.
@comment: NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the CQL model info.
*/
define function USExtensions(element Element, id String):
  element.extension E
	  where E.url = ('http://hl7.org/fhir/us/core/StructureDefinition/' + id)
		return E

/*
@description: Returns the single US Core extension (if present) on the given element with the specified id.
@comment: This function uses singleton from to ensure that a run-time exception is thrown if there
is more than one extension on the given resource with the specified url.
*/
define function USExtension(element Element, id String):
  singleton from USExtensions(element, id)

/*
@description: Returns any US Core modifier extensions defined on the given resource with the specified id.
@comment: NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the CQL model info.
*/
define function USModifierExtensions(domainResource DomainResource, id String):
  domainResource.modifierExtension E
	  where E.url = ('http://hl7.org/fhir/us/core/StructureDefinition/' + id)
		return E

/*
@description: Returns the single US Core modifier extension (if present) on the given resource with the specified id.
@comment: This function uses singleton from to ensure that a run-time exception is thrown if there
is more than one extension on the given resource with the specified url.
*/
define function USModifierExtension(domainResource DomainResource, id String):
  singleton from USModifierExtensions(domainResource, id)

/*
@description: Returns any US Core modifier extensions defined on the given element with the specified id.
@comment: NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the CQL model info.
*/
define function USModifierExtensions(element BackboneElement, id String):
  element.modifierExtension E
	  where E.url = ('http://hl7.org/fhir/us/core/StructureDefinition/' + id)
		return E

/*
@description: Returns the single US Core modifier extension (if present) on the given element with the specified id.
@comment: This function uses singleton from to ensure that a run-time exception is thrown if there
is more than one extension on the given resource with the specified url.
*/
define function USModifierExtension(element BackboneElement, id String):
  singleton from USModifierExtensions(element, id)
