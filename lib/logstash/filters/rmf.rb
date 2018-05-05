# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Rmf < LogStash::Filters::Base

  config_name "rmf"

  config :whitelist, :validate => :list
  

  public
  def register
    # set whitelist to an array of arrays each element of those are field
    # for example if we had ["a.a.a", "[b][c]"] we'll have [["a","a","a"]["b","c"]]
    @whitelist.map! { |item| item.include? "[" ? item.split "][" : item.split "." }
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
  def iterate(event, level, path)
    
    # if !event.is_a?(::Hash)
    #   hash = event.to_hash
    # else
    #   hash = event
    # end
    # @whitelist.each do |allowed|
    #   hash.each do |k,v|
    #     if v.is_a?(::Hash)
    #       iterate(v)
    #     else
    #       @whitelist.each do |field|
    #
    #       end
    #     end
    #   end
    # end
  end

  public
  def filter(event)

    iterate(event)
    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Rmf
