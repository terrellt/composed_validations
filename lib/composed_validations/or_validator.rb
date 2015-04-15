module ComposedValidations
  class OrValidator
    pattr_initialize :validators

    def valid?(record)
      validators.any? do |validator|
        validator.valid?(record)
      end
    end

    def message
      @message ||= OrStringJoiner.new(validators.map(&:message)).to_s
    end

  end

end
