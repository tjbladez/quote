require 'yajl'
require 'colored'
module Quote
  def self.say(source = nil)
    quotes = Yajl::Parser.parse(File.new(File.dirname(__FILE__) + '/quotes.json'))
    if source
      matching_quotes = quotes.values.flatten.select do |hash|
        hash["source"].match(/#{source}/i)
      end
      entry = random_select(matching_quotes)
      "\"#{entry['quote'].green}\" - #{entry['actor'].red}, #{entry['source'].red}."
    else
      category = random_select(quotes.to_a)
      entry    = random_select(category.last)
      "#{category.first.capitalize}: \"#{entry['quote'].green}\" - #{entry['actor'].red}, #{entry['source'].red}."
    end
  end

  def self.random_select(enumerable)
    enumerable[rand(enumerable.size)]
  end
end