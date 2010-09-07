require 'yajl'
require 'colored'

module ArrayExtensions
  def where(criteria ={})
    result = self
    criteria.each do |cr_key, cr_value|
      result = result.select do |hash|
        hash[cr_key].to_s.match(/#{cr_value}/i)
      end
    end
    result
  end
end
Array.send(:include, ArrayExtensions)

module Quote
  def self.say(criteria = {})
    quotes = Yajl::Parser.parse(File.new(File.dirname(__FILE__) + '/quotes.json'))
    quote(random_select(quotes.where(criteria)))
  end

  def self.random_select(enumerable)
    enumerable[rand(enumerable.size)]
  end

  def self.quote(entry)
    "#{entry['theme']}: \"#{entry['quote'].green}\" - #{entry['source'].red}, #{entry['context'].red}."
  end
end