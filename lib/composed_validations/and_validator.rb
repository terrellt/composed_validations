module ComposedValidations
  class AndValidator
    attr_reader :validators
    def initialize(validators)
      @validators = Array(validators)
    end

    def valid?(record)
      validators.all? do |validator|
        validator.valid?(record)
      end
    end

    def message
      @message ||= AndStringJoiner.new(validators.map(&:message)).to_s
    end

  end

end
