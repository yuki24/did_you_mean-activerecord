# Activerecord::Correctable

More 'Did you mean?' experience on Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'did_you_mean-activerecord', github: 'yuki24/did_you_mean-activerecord'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install did_you_mean-activerecord


## Examples

### ActiveRecord::UnknownAttributeError

```ruby
User.new(nmee: "wrong flrst name")
# => ActiveRecord::UnknownAttributeError: unknown attribute: nmee
#
#     Did you mean? name: string
#
```

### ActiveRecord::StatementInvalid (cause: PG::UndefinedTable)

```ruby
User.select("suers.first_name").to_a
# => ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "suers"
#    LINE 1: SELECT suers.first_name FROM "users"
#                   ^
#    : SELECT suers.first_name FROM "users"
#
#     Did you mean? users
#
```

### ActiveRecord::StatementInvalid (cause: PG::UndefinedColumn)

```ruby
User.select("firstname").to_a
# => ActiveRecord::StatementInvalid: PG::UndefinedColumn: ERROR:  column "firstname" does not exist
#    LINE 1: SELECT firstname FROM "users"
#                   ^
#    : SELECT firstname FROM "users"
#
#     Did you mean? first_name
#
```

## Support

Currently, this gem only works with `pg` and `sqlite3`.

## TODO

  * Support for mysql2 gem

## Contributing

1. Fork it ( https://github.com/yuki24/did_you_mean-activerecord/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
