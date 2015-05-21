module ComposedValidations
  class AndStringJoiner
    attr_reader :strings, :last_two
    def initialize(*strings)
      @strings = strings
      @last_two = @strings.pop(2)
    end

    def to_s
      [first_elements_string, last_two_elements_string].join(", ").gsub(/^, /,'')
    end

    private

    def first_elements_string
      strings.join(", ")
    end

    def last_two_elements_string
      last_two.join(" and ")
    end
  end
end
