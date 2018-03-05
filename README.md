# Hoze

Hoze is a runtime that helps implementing asynchronous jobs on top of Google Pub/Sub cloud queue system. Write your logic, Hoze takes care of plumbing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hoze'
```

And then execute:

    $ bundle install --binstubs

## Usage

Write a simple worker file `worker.rb`:

```ruby
Hoze.worker
.configure do |config|
  # You can use env variable for each property to overload hardcoded values
  config.channel = "my.pubsub.topic" # HOZE_CONFIG_CHANNEL
  config.key = "my.subscription.name" # HOZE_CONFIG_KEY
  config.connector.type = "pubsub" # HOZE_CONFIG_CONNECTOR_TYPE
  config.connector.project = "my-gcp-project" # HOZE_CONFIG_CONNECTOR_PROJECT
  config.connector.path_to_key = "/path/to/keyfile.json" # HOZE_CONFIG_CONNECTOR_PATH_TO_KEY
end
.process do |message|
  puts "Hello #{message.payload} !"
end
```

And now run it:

```shell
bundle exec hoze worker.rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pluce/hoze.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
