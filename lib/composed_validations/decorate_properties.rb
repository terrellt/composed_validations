##
# Takes a resource and a hash with properties as the keys and validators as the
# values and decorates those validations onto the resource.
module ComposedValidations
  class DecorateProperties
    pattr_initialize :resource, :property_mapper

    def run
      temp_resource = resource
      property_mapper.to_a.map{|x| PropertyValidator.new(*x) }.each do |p|
        temp_resource = p.decorate_resource(temp_resource)
      end
      temp_resource
    end
  end

end
