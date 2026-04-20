# encoding: utf-8
require "spec_helper"

describe SimpleBot::Google do
  before { allow(subject.class).to receive(:key).and_return("AAAAAAAAAAAAAA") }

  it "should call JSON parse when trying to translate" do
    expect(subject.class).to receive(:google_request).and_return("{data: {translations: [{translatedText: 'inferno'}]}}")
    subject.class.translate("en", "pt", "hell")
  end

  it "should search pothix on google" do
    expect(subject.class).to receive(:open).and_return('<h3 class="r"><a href="http://pothix.com/blog">PotHix Blog</a></h3>')
    expect(subject.class.search("pothix")).to eql("http://pothix.com/blog")
  end

  it "should call JSON parse when trying to search image" do
    why = "http://farm1.static.flickr.com/62/174356973_563e8ee775_b.jpg"
    expect(subject.class).to receive(:google_request).and_return("{responseData: {results: [{unescapedUrl: #{why}}]}}")
    expect(subject.class.search_image("Guru SP")).to eql(why)
  end
end
