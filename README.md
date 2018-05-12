# logstash-filter-rmf
This is a Logstash filter plugin, that allows to remove not whitelisted fields

## Using
This plugin have only one field named "whitelist". As you can guess it stores array of allowed fields. All other fields, except for starting from _ (underscore) and @ (at) are deleted. Subfields can be specified in two ways: by dots or square brackets (like in example below).

```ruby
rmf {
  "whitelist" => ["[a][b][c]", "a.d"]
}
```

You can specify multiple subfields dividing them by | symbol and surrounding expression by optional square or round brackets. So you can create pretty complex combination of subfields like:

```ruby
rmf {
  "whitelist" => ["[a][b|c]", "a.(d|d2).g|h"]
}
```

With this snippet of code will be created following whitelist: [a][b], [a][c], [a][d][g], [a][d][h], [a][d2][g], [a][d2][h]. If this construction exists more then on one level, there will be each-with-each combination.
