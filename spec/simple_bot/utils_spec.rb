# encoding: utf-8
require "spec_helper"

describe "SimpleIrcBot::Utils" do
  before :all do
    class Dummy; include SimpleIrcBot::Utils; end
  end

  subject { Dummy.new }
end
