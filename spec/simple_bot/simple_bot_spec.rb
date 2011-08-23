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

  subject {
    config = YAML.load_file File.join(File.expand_path(File.dirname(__FILE__)), "../config/wyrd.yml")
    SimpleIrcBot.new(config)
  }

  it "should call agendatech to verify the next meeting" do
    subject.should_receive(:agendatech)
    subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!agendatech")
  end

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
      @mock_quote = SimpleIrcBot::Quote.new(@quote_message)
      SimpleIrcBot::Quote.stub(:new).with(@quote_message).and_return(@mock_quote)
    end

    it "should call the correct show a quote when calling !quote command" do
      SimpleIrcBot::Quote.should_receive(:random)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote")
    end

    context "when adding a new quote" do
      it "should call the correct method to add a new quote when calling !add_quote command without mentioning the bot" do
        @mock_quote.should_receive(:add!)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_quote #{@quote_message}")
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

    context "when retrieving a quote" do
      it "should call the correct show a quote when calling !quote command" do
        SimpleIrcBot::Quote.should_receive(:random)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote")
      end

      it "should not call random by user method when a space is passed" do
        SimpleIrcBot::Quote.should_receive(:random)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote ")
      end

      it "should call the method to return a quote from a specific user" do
        SimpleIrcBot::Quote.should_receive(:random_by_user).with("qmx")
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote qmx")
      end
    end
  end

  context "using google services" do
    it "should call google translate method with the given query" do
      SimpleIrcBot::Google.should_not_receive(:translate)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!t-asdf^asdf hell")
    end

    it "should return the translation using the correct format" do
      SimpleIrcBot::Google.should_receive(:translate).with("en", "pt", "hell").and_return("inferno")
      subject.should_receive(:say_to_chan).with("inferno")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!t-en-pt hell")
    end

    it "should search on google for a given query" do
      SimpleIrcBot::Google.should_receive(:search).with("pothix")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!google pothix")
    end
  end

  context "in unknown messages (actions)" do
    it "should ask to Ed" do
      question = "2 * 2"
      subject.should_receive(:ask_to_ed).with(question)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :#{NICK}: #{question} ")
    end
  end
end
