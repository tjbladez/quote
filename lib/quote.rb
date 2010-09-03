require 'yajl'
require 'colored'
module Quote
  def self.say(source = nil)
    quotes = Yajl::Parser.parse(File.new(File.dirname(__FILE__) + '/quotes.json'))
    if source && !find_matches(quotes, source).empty?
      quote(random_select(find_matches(quotes, source)))
    else
      category = random_select(quotes.to_a)
      entry    = random_select(category.last)
      "#{category.first.capitalize}: " + quote(entry)
    end
  end

  def self.random_select(enumerable)
    enumerable[rand(enumerable.size)]
  end

  def self.find_matches(quotes, source)
    quotes.values.flatten.select do |hash|
      hash["source"].match(/#{source}/i)
    end
  end

  def self.quote(entry)
    "\"#{entry['quote'].green}\" - #{entry['actor'].red}, #{entry['source'].red}."
  end
end