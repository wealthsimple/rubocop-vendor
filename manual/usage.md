You need to tell RuboCop to load the Vendor extension. There are three
ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yaml
require: rubocop-vendor
```

Now you can run `rubocop` and it will automatically load the RuboCop Vendor
cops together with the standard cops.

### Command line

```sh
rubocop --require rubocop-vendor
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-vendor'
end
```
