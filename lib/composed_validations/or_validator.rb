module ComposedValidations
  class OrValidator
    pattr_initialize :validators

    def valid_value?(record)
      validators.any? do |validator|
        validator.valid_value?(record)
      end
    end

    def message
      @message ||= OrStringJoiner.new(validators.map(&:message)).to_s
    end

  end

end
