module DidYouMean
  module ActiveRecord
    class TableNameChecker
      REGEX_FROM_EXCEPTION = {
        'PG::UndefinedTable'    => /[relation|for table] \"(.*)\"[ does not exist]*/,
        'SQLite3::SQLException' => /no such table\: (.*)/
      }

      def initialize(exception)
        @cause         = exception.original_exception
        @frame_binding = exception.frame_binding
      end

      def corrections
        DidYouMean::SpellChecker.new(dictionary: table_names).correct(name.to_s)
      end

      def name
        REGEX_FROM_EXCEPTION[@cause.class.to_s] =~ @cause.message && $1
      end

      def table_names
        @frame_binding.eval("self").schema_cache.instance_variable_get(:@columns).keys
      end
    end
  end
end
