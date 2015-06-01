module ActiveRecord::Correctable
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'after_initialize' do
      require 'activerecord/correctable/finders/attribute_name_finder'
      require 'activerecord/correctable/finders/column_name_finder'
      require 'activerecord/correctable/finders/table_name_finder'

      DidYouMean.finders.merge!({
        'ActiveModel::UnknownAttributeError'  => AttributeNameFinder, # >= Rails 5.0
        'ActiveRecord::UnknownAttributeError' => AttributeNameFinder, # <= Rails 4.2
        'ActiveRecord::StatementInvalid'      => ByCause.new({
          'PG::UndefinedTable'    => TableNameFinder,
          'PG::UndefinedColumn'   => ColumnNameFinder,
          'SQLite3::SQLException' => ByRegex.new({
            /no such table\: (.*)/  => TableNameFinder,
            /no such column\: (.*)/ => ColumnNameFinder
          })
        })
      })
    end

    ActiveSupport.on_load(:active_record) do
      ActiveRecord::StatementInvalid.include(DidYouMean::Correctable)
    end
  end

  class ByCause
    def initialize(hash)
      @cause_mapping = hash
    end

    def new(exception)
      cause = if exception.respond_to?(:cause)
                exception.cause
              elsif exception.respond_to?(:original_exception)
                exception.original_exception
              end

      (@cause_mapping[cause.class.to_s] || ::DidYouMean::NullFinder).new(exception)
    end
  end

  class ByRegex
    def initialize(hash)
      @regex_mapping = hash
    end

    def new(exception)
      msg = if exception.respond_to?(:original_message)
              exception.original_message
            else
              exception.message
            end

      @regex_mapping.each do |regex, finder_class|
        return finder_class.new(exception) if regex =~ msg
      end

      ::DidYouMean::NullFinder.new(exception)
    end
  end

  private_constant :ByCause, :ByRegex
end
