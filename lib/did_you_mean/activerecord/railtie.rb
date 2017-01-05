module DidYouMean
  module ActiveRecord
    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'after_initialize' do
        require 'did_you_mean/experimental'

        require 'did_you_mean/activerecord/spell_checkers/attribute_name_checker'
        require 'did_you_mean/activerecord/spell_checkers/column_name_checker'
        require 'did_you_mean/activerecord/spell_checkers/table_name_checker'

        DidYouMean::SPELL_CHECKERS.merge!({
          'ActiveModel::UnknownAttributeError'  => AttributeNameChecker, # >= Rails 5.0
          'ActiveRecord::UnknownAttributeError' => AttributeNameChecker, # <= Rails 4.2
          'ActiveRecord::StatementInvalid'      => ByCause.new({
            'PG::UndefinedTable'    => TableNameChecker,
            'PG::UndefinedColumn'   => ColumnNameChecker,
            'SQLite3::SQLException' => ByRegex.new({
              /no such table\: (.*)/  => TableNameChecker,
              /no such column\: (.*)/ => ColumnNameChecker
            })
          })
        })
      end

      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::StatementInvalid.include(DidYouMean::Correctable)
        ::ActiveRecord::StatementInvalid.send(:attr, :frame_binding)
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

        @cause_mapping.fetch(cause.class.to_s, ::DidYouMean::NullChecker).new(exception)
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

        ::DidYouMean::NullChecker.new(exception)
      end
    end

    private_constant :ByCause, :ByRegex
  end
end
