# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Rmf < LogStash::Filters::Base

  config_name "rmf"

  config :whitelist, :validate => :array
  

  public
  def register
    # set whitelist to an array of arrays each element of those are field
    # for example if we had ["a.a.a", "[b][c]"] we'll have [["a","a","a"]["b","c"]]
    @whitelist.map! { |item| item.include?("[") ? item.split("][") : item.split(".") }
    @whitelist.each do |item|
      if item.kind_of?(Array)
        if item[0].include? "["
          item[0]=item[1..-1]
        end
        if item[-1].include? "]"
          item[-1]=item[0..-2]
        end
      end
    end
  end # def register

  private
  def iterate(event, hash, level, path)
    hash.each do |k,v|
      contains = false
      @whitelist.each do |allowed|
        if k == allowed[level]
          contains = true
        end
      end
      if contains
        if v.is_a?(::Hash)
          iterate(event, v, level+1, path + "[" + k.to_s + "]")
        end
        path = path[0..-2]
      else
        event.remove(path)
      end
    end
  end

  public
  def filter(event)
    iterate(event, event.to_hash, 0, "")
    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Rmf
