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
    before do
      @quote_message = "<qmx> Eu amo Ruby 1.9"
      @mock_quote = Quote.new(@quote_message)
      Quote.stub(:new).with(@quote_message).and_return(@mock_quote)
    end
    it "should call the correct method to add a new quote when calling !add_quote command without mentioning the bot" do
      @mock_quote.should_receive(:add!)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_quote #{@quote_message}")
    end

    it "should call the correct show a quote when calling !quote command" do
      Quote.should_receive(:random)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote")
    end

    it "should print a message after add a new quote to the quotes file" do
      @mock_quote.stub(:add!)
      subject.should_receive(:say_to_chan).with("Boa! Seu quote foi adicionado com sucesso! \\o/")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_quote #{@quote_message}")
    end

    it "should not add the quote if it mentions the bot" do
      @mock_quote.should_not_receive(:add!)
      subject.should_receive(:say_to_chan).with("Não sou tão idiota de ficar adicionando quotes que mencionem a mim ;)")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_quote o wyrd é um idiota")
    end
  end

  context "using google services" do
    it "should call google translate method with the given query" do
      Google.should_not_receive(:translate)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!t-asdf^asdf hell")
    end

    it "should return the translation using the correct format" do
      Google.should_receive(:translate).with("en", "pt", "hell").and_return("inferno")
      subject.should_receive(:say_to_chan).with("inferno")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!t-en-pt hell")
    end

    it "should search on google for a given query" do
      Google.should_receive(:search).with("pothix")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!google pothix")
    end
  end
end
