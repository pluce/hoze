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

### Basic usage

Write a simple worker file `worker.rb`:

```ruby
Hoze.worker
.listen_to do |config| # Define where to find messages
  # You can use env variable for each property to overload hardcoded values
  config.channel = "my.pubsub.topic" # HOZE_CONFIG_CHANNEL
  config.key = "my.subscription.name" # HOZE_CONFIG_KEY
  config.connector.type = "pubsub" # HOZE_CONFIG_CONNECTOR_TYPE
  config.connector.project = "my-gcp-project" # HOZE_CONFIG_CONNECTOR_PROJECT
  config.connector.path_to_key = "/path/to/keyfile.json" # HOZE_CONFIG_CONNECTOR_PATH_TO_KEY
end
.process do |message| # Define job function
  puts "Hello #{message.payload} !"
  "my result"
end
.push_to do |config| # Define where to push job result
  # You can use env variable for each property to overload hardcoded values
  config.channel = "my.other.pubsub.topic" # HOZE_CONFIG_DEST_CHANNEL
  config.connector.type = "pubsub" # HOZE_CONFIG_CONNECTOR_DEST_TYPE
  config.connector.project = "my-gcp-project" # HOZE_CONFIG_CONNECTOR_DEST_PROJECT
  config.connector.path_to_key = "/path/to/keyfile.json" # HOZE_CONFIG_CONNECTOR_DEST_PATH_TO_KEY
end
.go!
```

And now run it:

```shell
bundle exec hoze worker.rb
```

It'll now listen to `my.subscription.name` for any message, print the payload to `STDOUT` then push the message `my result` to `my.other.pubsub.topic`.

### Acknowledgement, delay and rejection

By default, messages must be acknowledged explicitly. If messages are not acked before a time depending on the source implementation, they'll be sent again to the subscribers. Your worker may ask for more time before the timeout expires if the processing is known to be long. It may also `reject` a message, telling the source it won't process it and then sending it bck to its queue.
You may also define an automatic acknowledgement if you don't want to handle this by hand.

#### Auto-ack

```ruby
Hoze.worker
.listen_to do |config|
    # ...
    config.auto_ack = true # Will ack the message as soon as it is received
end
.process do |message|
    # ...
end
.go!
```

#### Manual ack

```ruby
Hoze.worker
.listen_to do |config|
    # ...
end
.process do |message|
    # ...
    message.ack!
end
.go!
```

#### Delay and rejection

```ruby
Hoze.worker
.listen_to do |config|
    # ...
end
.process do |message|
    # pretty long processing
    message.delay! 10 # asking for 10 more seconds
    # continue long processing
    message.reject! # finally reject the message
end
.go!
```

### Retries

Failed processing may be retried. Set the config variable `max_tries` to tell how many times it's gonna be tried before it's considered dead.

```ruby
Hoze.worker
.listen_to do |config|
    # ...
    config.max_tries = 5
end
.process do |message|
    # Failable processing
end
.go!
```

*Beware* the retry system is still alpha. Messages will be pushed back immediately in the queue with a `tries` metadata recording the tries count. Dead messages will just be logged.

### Metadata transfer

When the result is pushed to another topic, original message's metadata are transfered along. They can be modified in the `process` block:

```ruby
Hoze.worker
.listen_to do |config|
    # ...
end
.process do |message|
  message.metadata[:who_is_the_best] = "I am the best"
  "my result"
end
.push_to do |config| 
    # ...
end
.go!
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pluce/hoze.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
