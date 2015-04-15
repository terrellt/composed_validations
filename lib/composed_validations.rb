require "composed_validations/version"
require 'delegate'
require 'attr_extras'

module ComposedValidations
  autoload :WithValidatedProperty, "composed_validations/with_validated_property"
  autoload :DecorateProperties, "composed_validations/decorate_properties"
  autoload :PropertyValidator, "composed_validations/property_validator"
  autoload :OrValidator, "composed_validations/or_validator"
  autoload :OrStringJoiner, "composed_validations/or_string_joiner"
end
