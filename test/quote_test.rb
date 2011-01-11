require File.expand_path('../../lib/quote', __FILE__)
require 'riot'

context "Quote" do
  setup do
    ENV['QUOTE_SOURCE'] = File.expand_path('../quotes.json', __FILE__)
    @quotes = Yajl::Parser.parse(File.new(ENV['QUOTE_SOURCE']))
    Quote
  end

  context "#load_quotes" do
    setup { topic.load_quotes }
    should("match all quotes"){topic.to_set}.equals{@quotes.to_set}
  end

  context "#say without QUOTE_COLORIZE set" do
    setup { topic.say }
    asserts("gets a random formatted quote from quotes") { @quotes.map(&:format).include?(topic)}
  end

  context "#say with QUOTE_COLORIZE set to true" do
    setup do
      ENV['QUOTE_COLORIZE'] = 'true'
      topic.say
    end
    asserts("gets a random colorized formatted quote from quotes") { @quotes.map(&:format_with_color).include?(topic)}
  end

  context "#say with QUOTE_COLORIZE set to any other string" do
    setup do
      ENV['QUOTE_COLORIZE'] = 'false'
      topic.say
    end
    asserts("gets a random formatted quote from quotes") { @quotes.map(&:format).include?(topic)}
  end

  context "#add with invalid json" do
    setup {topic.add("this is not a valid json")}
    asserts("returns parsing error message") { topic}.equals("Please supply a valid json")
  end

  context "#add with valid json" do
    context "when missing context" do
      setup { topic.add("{\"source\":\"test\",\"quote\":\"hoax\",\"theme\":\"lies\"}")}
      asserts("returns an accurate error message") { topic}.equals("Can't add quote: missing context")
    end

    context "when missing quote" do
      setup { topic.add("{\"context\":\"fake context\", \"source\":\"test\",\"theme\":\"lies\"}")}
      asserts("returns an accurate error message") { topic}.equals("Can't add quote: missing quote")
    end

    context "when missing theme" do
      setup { topic.add("{\"context\":\"fake context\",\"source\":\"test\",\"quote\":\"hoax\"}")}
      asserts("returns an accurate error message") { topic}.equals("Can't add quote: missing theme")
    end

    context "when missing source" do
      setup { topic.add("{\"context\":\"fake context\",\"quote\":\"hoax\",\"theme\":\"lies\"}")}
      asserts("returns an accurate error message") { topic}.equals("Can't add quote: missing source")
    end

    context "when missing more than one parameter" do
      setup { topic.add("{\"context\":\"fake context\",\"source\":\"test\"")}
      asserts("returns an accurate error message") { topic}.equals{"Can't add quote: missing #{["quote", "theme"].sort.join(', ')}"}
    end

    context "when has all required information" do
      setup do
        @quote_json = "{\"context\":\"fake context\",\"source\":\"test\",\"quote\":\"hoax\",\"theme\":\"lies\"}"
        topic.add(@quote_json)
      end
      asserts("returns successful add message") { topic}.equals("Your quote has been successfully added")

      asserts("adds quote to the quote file") do
        quotes = Yajl::Parser.parse(File.new(ENV['QUOTE_SOURCE']))
        quotes.detect {|quote| quote == Yajl::Parser.parse(@quote_json)}
      end

      context "done multiple times" do
        setup do
         Quote.add(@quote_json)
         Quote.add(@quote_json)
        end
        should "only have uniq quote" do
          quotes = Yajl::Parser.parse(File.new(ENV['QUOTE_SOURCE']))
          quotes.size == quotes.uniq.size
        end
      end
    end
  end

  context "#from" do
    setup do
      data_criterion, readable_criteria = *Quote::CRITERIA.detect {|k,v| v.include?("from")}
      @random_quote_context = @quotes.map{|i| i[data_criterion]}.random
      topic.from(@random_quote_context)
    end
    should("returns quote containing 'from' search results"){ topic.match(@random_quote_context)}
  end

  context "#in" do
    setup do
      data_criterion, readable_criteria = *Quote::CRITERIA.detect {|k,v| v.include?("in")}
      @random_quote_context = @quotes.map{|i| i[data_criterion]}.random
      topic.in(@random_quote_context)
    end
    should("returns quote containing 'in' search results") { topic.match(@random_quote_context)}
  end

  context "#by" do
    setup do
      data_criterion, readable_criteria = *Quote::CRITERIA.detect {|k,v| v.include?("by")}
      @random_quote_source = @quotes.map{|i| i[data_criterion]}.random
      topic.by(@random_quote_source)
    end
    should("returns quote containing 'by' search results") { topic.match(@random_quote_source)}
  end

  context "#with" do
    setup do
      data_criterion, readable_criteria = *Quote::CRITERIA.detect {|k,v| v.include?("with")}
      random_quote_text = @quotes.map{|i| i[data_criterion]}.random
      @random_word = random_quote_text.scan(/\w+/).random
      topic.with(@random_word)
    end
    should("returns quote containing 'with' search results") { topic.match(@random_word)}
  end

  context "#containing" do
    setup do
      data_criterion, readable_criteria = *Quote::CRITERIA.detect {|k,v| v.include?("containing")}
      random_quote_text = @quotes.map{|i| i[data_criterion]}.random
      @random_word = random_quote_text.scan(/\w+/).random
      topic.containing(@random_word)
    end
    should("returns quote containing 'containing' search results") { topic.match(@random_word)}
  end

  context "#matching" do
    setup do
      data_criterion, readable_criteria = *Quote::CRITERIA.detect {|k,v| v.include?("matching")}
      random_quote_text = @quotes.map{|i| i[data_criterion]}.random
      @random_word = random_quote_text.scan(/\w+/).random
      topic.matching(@random_word)
    end
    should("returns quote containing 'matching' search results") { topic.match(@random_word)}
  end

  context "#category" do
    setup do
      data_criterion, readable_criteria = *Quote::CRITERIA.detect {|k,v| v.include?("category")}
      @random_value_theme = @quotes.map{|i| i[data_criterion]}.random
      topic.category(@random_value_theme)
    end
    should("returns quote containing 'category' search results") { topic.match(@random_value_theme)}
  end
end
