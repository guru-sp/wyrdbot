require "spec_helper"

describe "SimpleIrcBot" do
  NICK    = "wyrd"
  CHANNEL = "guru-sp"

  before do
    @socket = mock
    TCPSocket.should_receive(:open).and_return(@socket)

    nick = "NICK #{NICK}"
    user = "USER #{NICK} 0 * #{NICK.capitalize}"
    join = "JOIN ##{CHANNEL}"

    $stdout.should_receive(:write).with("#{nick}\n")
    $stdout.should_receive(:write).with("#{user}\n")
    $stdout.should_receive(:write).with("#{join}\n")

    @socket.should_receive(:puts).with(nick)
    @socket.should_receive(:puts).with(user)
    @socket.should_receive(:puts).with(join)
  end

  subject { SimpleIrcBot.new("irc.freenode.net", 6667, CHANNEL, NICK)}

  it "should post on irc channel and write a log" do
    message = "Yes! This bot is really awesome!"

    $stdout.should_receive(:write).with("#{message}\n")
    @socket.should_receive(:puts).with(message)
    subject.say(message)
  end
end
