# encoding: utf-8
require "spec_helper"

describe Google do
  it "should call JSON parse when trying to translate" do
    google_response = {"data"=>{"translations"=>[{"translatedText"=>"inferno"}]}}
    JSON.should_receive(:parse).and_return(google_response)
    subject.class.translate("en","pt","hell")
  end

  it "should search pothix on google" do
    subject.class.should_receive(:open).and_return('<h3 class="r"><a href="http://pothix.com/blog">PotHix Blog</a></h3>')
    subject.class.search("pothix").should eql("http://pothix.com/blog")
  end
end
