module ComposedValidations
  class ValidatedProperty
    vattr_initialize :validated_property, :property_accessor
    def to_sym
      validated_property
    end
  end
end
