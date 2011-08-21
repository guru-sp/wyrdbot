# encoding: utf-8
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
    @socket.stub(:puts)
  end

  subject { SimpleIrcBot.new("irc.freenode.net", 6667, CHANNEL, NICK)}

  it "should post on irc channel and write a log" do
    message = "Yes! This bot is really awesome!"

    @socket.should_receive(:puts).with(message)
    subject.say(message)
  end

  it "should greet for a good morning message" do
    subject.should_receive(:greet).with("Bom dia galera", "PotHix ")
    subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :Bom dia galera")
  end

  context "when retrieving quotes" do
    it "should call the correct method to add a new quote when calling !add_quote command" do
      subject.should_receive(:quote)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote")
    end

    it "should call the correct show a quote when calling !quote command" do
      subject.should_receive(:quote)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote")
    end

    it "should add a new quote to the quotes file" do
      message = "I'm testing if this thing works..."
      subject.add_quote(message)
      quotes_file = YAML.load_file(File.expand_path(File.dirname(__FILE__))+"/../speak/quotes.yml")
      quotes_file[:quotes][quotes_file[:quotes].size - 1].should == message
    end

    it "should print a message after add a new quote to the quotes file" do
      message = subject.add_quote(message)
      message.should eql("Boa! Seu quote foi adicionado com sucesso! \o/")
    end

    it "should return a random quote" do
      not_so_random_number = 0
      subject.should_receive(:rand).and_return(not_so_random_number)
      quotes_file = YAML.load_file(File.expand_path(File.dirname(__FILE__))+"/../speak/quotes.yml")
      subject.quote.should quotes_file[not_so_random_number]
    end

    it "shoud add the quote with accents" do
      message = "I really don't like forró"
      subject.add_quote(message)
      quotes_file = YAML.load_file(File.expand_path(File.dirname(__FILE__))+"/../speak/quotes.yml")
      quotes_file[:quotes][quotes_file[:quotes].size - 1].should == message
    end
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
