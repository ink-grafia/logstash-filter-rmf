# logstash-filter-rmf
This is a Logstash filter plugin, that allows to remove not whitelisted fields

## Usage
This plugin have only one field named "whitelist". As you can guess it stores array of strings, that represent allowed fields. All not specified fields, except for starting with _ (underscore) and @ (at) are deleted. Subfields can be indicated in two ways: by dots or square brackets (like in example below).

```ruby
rmf {
  "whitelist" => ["[a][b][c]", "a.d"]
}
```

You can specify multiple subfields dividing them by | symbol and surrounding expression by optional square or round brackets. So you can create pretty complex combination of subfields like:

```ruby
rmf {
  "whitelist" => ["[first][second|other_second]", "start.(second_start|other_second_start).end|other_end"]
}```
```

With this snippet of code will be created following whitelist: 
- [first][second], 
- [first][other_second], 
- [start][second_start][end], 
- [start][other_second_start][other_end], 
- [start][second_start][end], 
- [start][other_second_start][other_end]. 


If this construction exists more then on one level, there will be each-with-each combination.
