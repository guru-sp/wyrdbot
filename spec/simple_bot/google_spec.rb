# encoding: utf-8
require "spec_helper"

describe Google do
  it "should call JSON parse when trying to translate" do
    google_response = {"data"=>{"translations"=>[{"translatedText"=>"inferno"}]}}
    JSON.should_receive(:parse).and_return(google_response)
    subject.class.translate("en","pt","hell")
  end
end
