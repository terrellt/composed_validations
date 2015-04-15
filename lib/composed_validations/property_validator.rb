module ComposedValidations
  class PropertyValidator
    attr_reader :property, :validators
    def initialize(property, validators)
      @property = property
      @validators = Array(validators)
    end

    def decorate_resource(resource)
      validators.each do |validator|
        resource = WithValidatedProperty.new(resource, property, validator)
      end
      resource
    end
  end
end
