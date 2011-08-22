# encoding: utf-8
require "spec_helper"

describe SimpleIrcBot::Google do
  before {subject.class.stub(:key => "AAAAAAAAAAAAAA")}
  it "should call JSON parse when trying to translate" do
    subject.class.stub(:translation_result => '{data: {translations: [{translatedText: "inferno"}]}}')
    subject.class.translate("en","pt","hell")
  end

  it "should search pothix on google" do
    subject.class.should_receive(:open).and_return('<h3 class="r"><a href="http://pothix.com/blog">PotHix Blog</a></h3>')
    subject.class.search("pothix").should eql("http://pothix.com/blog")
  end
end
