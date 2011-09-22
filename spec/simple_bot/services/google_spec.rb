# encoding: utf-8
require "spec_helper"

describe SimpleBot::Google do
  before {subject.class.stub(:key => "AAAAAAAAAAAAAA")}
  it "should call JSON parse when trying to translate" do
    subject.class.should_receive(:google_request).and_return("{data: {translations: [{translatedText: 'inferno'}]}}")
    subject.class.translate("en","pt","hell")
  end

  it "should search pothix on google" do
    subject.class.should_receive(:open).and_return('<h3 class="r"><a href="http://pothix.com/blog">PotHix Blog</a></h3>')
    subject.class.search("pothix").should eql("http://pothix.com/blog")
  end

  it "should call JSON parse when trying to search image" do
    why = "http://farm1.static.flickr.com/62/174356973_563e8ee775_b.jpg"
    subject.class.should_receive(:google_request).and_return("{responseData: {results: [{unescapedUrl: #{why}}]}}")
    subject.class.search_image("Guru SP").should eql why
  end
end