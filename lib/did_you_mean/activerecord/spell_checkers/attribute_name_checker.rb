module DidYouMean
  module ActiveRecord
    class AttributeNameChecker
      attr_reader :columns, :attribute_name

      def initialize(exception)
        @columns        = exception.frame_binding.eval("self.class").columns
        @attribute_name = (/unknown attribute(: | ')(\w+)/ =~ exception.original_message) && $2
      end

      def corrections
        DidYouMean::SpellChecker
          .new(dictionary: attribute_names_on_model)
          .correct(attribute_name)
          .map(&:name_with_type)
      end

      def attribute_names_on_model
        columns.map {|column| AttributeName.new(column.name.dup, column.type) }
      end

      class AttributeName < DelegateClass(String)
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
end
