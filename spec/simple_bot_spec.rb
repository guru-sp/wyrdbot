require "spec_helper"

describe "SimpleIrcBot" do
  NICK    = "wyrd"
  CHANNEL = "guru-sp"

  before do
    @socket = mock
    TCPSocket.stub(:open).and_return(@socket)

    nick = "NICK #{NICK}"
    user = "USER #{NICK} 0 * #{NICK.capitalize}"
    join = "JOIN ##{CHANNEL}"

    $stdout.stub(:write)
    @socket.stub(:puts)
  end

  subject { SimpleIrcBot.new("irc.freenode.net", 6667, CHANNEL, NICK)}

  it "should post on irc channel and write a log" do
    message = "Yes! This bot is really awesome!"

    $stdout.should_receive(:write).with("#{message}\n")
    @socket.should_receive(:puts).with(message)
    subject.say(message)
  end

  it "should greet for a good morning message" do
    subject.should_receive(:greet).with("Bom dia galera", "PotHix ")
    subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :Bom dia galera")
  end

  it "should add a new quote to the quotes file" do
    subject.add_quote("I'm testing if this thing works...")
  end

  context "when trying to translate" do
    it "should return a message of wrong format for a invalid format" do
      message = subject.try_to_translate("t-asfd^asdf", "hell")
      message.should eql("Ow, usa o formato: t-idioma1-idioma2. #fikdik")
    end

    it "should return the translation using the correct format" do
      subject.should_receive(:translate).with("en", "pt", "hell").and_return("inferno")
      message = subject.try_to_translate("t-en-pt", "hell")
      message.should eql("inferno")
    end
  end
end
