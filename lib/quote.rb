require 'rubygems'
require 'yajl'
require 'colored'
require 'ruby-debug'

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

  def random
    self[rand(self.size)]
  end
end
Array.send(:include, ArrayExtensions)

module QuoteHashExtensions
  def format_with_color
    "#{self['theme']}: \"#{self['quote'].green}\" - #{self['source'].red}, #{self['context'].red}."
  end

  def format
    "#{self['theme']}: \"#{self['quote']}\" - #{self['source']}, #{self['context']}."
  end
end
Hash.send(:include, QuoteHashExtensions)

module Quote
  CRITERIA = {
    "context" => ["from", "in"],
    "source"  => ["by"],
    "quote"   => ["with", "containing", "matching"],
    "theme"   => ["category"]
  }

  class << self
    def say(criteria = {})
      random_quote = load_quotes.where(criteria).random
      ENV['QUOTE_COLORIZE'] == "true" ? random_quote.format_with_color : random_quote.format
    end

    def add(json)
      quote = Yajl::Parser.parse(json)
      missing_criteria = []
      CRITERIA.keys.each do |criterion|
        missing_criteria << criterion unless quote[criterion]
      end
      missing_criteria.empty? ? add_quote(quote) : "Can't add quote: missing #{missing_criteria.sort.join(', ')}"
    rescue Yajl::ParseError
      return "Please supply a valid json"
    end

    def load_quotes
      Yajl::Parser.parse(File.new(source_file_path))
    end

    CRITERIA.each do |key, match_array|
      match_array.each do |match_criterion|
        define_method(match_criterion) { |criterion_text| criterion_text ? say({key => criterion_text}) : say }
      end
    end

    private

    def add_quote(quote)
      quotes = load_quotes
      quotes += [quote]
      File.open(source_file_path, 'w') do |f|
        f.write Yajl::Encoder.encode(quotes.uniq)
      end
      return "Your quote has been successfully added"
    end

    def source_file_path
      ENV['QUOTE_SOURCE'] || File.dirname(__FILE__) + '/quotes.json'
    end
  end
end