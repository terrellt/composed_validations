require "composed_validations/version"
require 'delegate'
require 'attr_extras'

module ComposedValidations
  autoload :WithValidatedProperty, "composed_validations/with_validated_property"
  autoload :DecorateProperties, "composed_validations/decorate_properties"
  autoload :PropertyValidator, "composed_validations/property_validator"
  autoload :OrValidator, "composed_validations/or_validator"
  autoload :OrStringJoiner, "composed_validations/or_string_joiner"
  autoload :ValidatedProperty, "composed_validations/validated_property"

  def ValidatedProperty(value)
    if value.kind_of? ValidatedProperty
      value
    else
      ValidatedProperty.new(value.to_sym, value.to_sym)
    end
  end

  module_function :ValidatedProperty
end
