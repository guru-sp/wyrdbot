# encoding: utf-8
require 'spec_helper'

describe SimpleIrcBot::Redhead do
  class FetcherFake
    def get(*args)
      Support::Fixtures.load_file('redheads.xml')
    end
  end

  describe ".fetch" do
    let(:fetcher) { FetcherFake.new }
    subject { described_class.fetch(fetcher) }

    it "returns the biggest image from the set" do
      subject.should == "http://26.media.tumblr.com/tumblr_lqd645Twx01qhp4e9o1_500.jpg"
    end
  end
end
