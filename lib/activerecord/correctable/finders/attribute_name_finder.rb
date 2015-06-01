module ActiveRecord::Correctable
  class AttributeNameFinder
    include ::DidYouMean::BaseFinder
    attr_reader :columns, :attribute_name

    def initialize(exception)
      @columns        = exception.frame_binding.eval("self.class").columns
      @attribute_name = (/unknown attribute(: | ')(\w+)/ =~ exception.original_message) && $2
    end

    def suggestions
      super.map(&:name_with_type)
    end

    def searches
      { attribute_name => columns.map{|c| AttributeName.new(c.name, c.type)} }
    end

    class AttributeName < SimpleDelegator
      attr :type

      def initialize(name, type)
        super(name)
        @type = type
      end

      def name_with_type
        "%{attribute}: %{type}" % {
          attribute: __getobj__,
          type:      @type
        }
      end
    end

    private_constant :AttributeName
  end
end
