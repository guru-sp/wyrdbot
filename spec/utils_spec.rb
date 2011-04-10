# encoding: utf-8
require "spec_helper"

describe "Utils" do
  before :all do
    class Dummy; include Utils; end
  end

  subject { Dummy.new }
end
