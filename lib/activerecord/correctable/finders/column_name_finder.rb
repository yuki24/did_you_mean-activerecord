module ActiveRecord::Correctable
  class ColumnNameFinder
    include ::DidYouMean::BaseFinder

    REGEX_FROM_EXCEPTION = {
      'PG::UndefinedColumn'   => /column \"(.*)\" does not exist/,
      'SQLite3::SQLException' => /no such column\: (.*)/
    }

    def initialize(exception)
      @cause         = exception.original_exception
      @frame_binding = exception.frame_binding
    end

    def searches
      { name.to_s => column_names }
    end

    def name
      REGEX_FROM_EXCEPTION[@cause.class.to_s] =~ @cause.message && $1
    end

    def column_names
      @frame_binding.eval("self").schema_cache.instance_variable_get(:@columns).values.flatten.map(&:name)
    end
  end
end
