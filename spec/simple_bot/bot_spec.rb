# encoding: utf-8
require "spec_helper"

describe "SimpleBot" do
  NICK    = "wyrd"
  CHANNEL = "guru-sp"

  before do
    @socket = mock
    TCPSocket.stub(:open).and_return(@socket)

    nick = "NICK #{NICK}"
    user = "USER #{NICK} 0 * #{NICK.capitalize}"
    join = "JOIN ##{CHANNEL}"
    @socket.stub(:puts)
    @socket.stub(:gets)
  end

  subject {
    config = YAML.load_file File.join(File.expand_path(File.dirname(__FILE__)), "../config/wyrd.yml")
    SimpleBot::Bot.new(config)
  }

  it "should instantiate root directory as pathname" do
    SimpleBot.root.should be_a(Pathname)
  end

  it "should set root directory" do
    SimpleBot.root.to_s.should == File.expand_path("../../..", __FILE__)
  end

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

  context "when retrieving any kind of quotes" do
    before do
      @quote_message = "<qmx> Eu amo Ruby 1.9"
      @mock_quote = SimpleBot::Quote.new(@quote_message)
      @mock_motorcycle = SimpleBot::Motorcycle.new(@quote_message)
      @mock_troll = SimpleBot::Troll.new(@quote_message)
      SimpleBot::Quote.stub(:new).with(@quote_message).and_return(@mock_quote)
      SimpleBot::Motorcycle.stub(:new).with(@quote_message).and_return(@mock_motorcycle)
      SimpleBot::Troll.stub(:new).with(@quote_message).and_return(@mock_troll)
    end

    it "should not troll if the bot nickname was passed" do
      subject.should_receive(:say_to_chan).with("Ta se achando espertinho né, idiota? Não vou praticar self-trolling. ¬¬")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!troll #{NICK}")
    end

    it "should not troll if no nickname was passed" do
      subject.should_receive(:say_to_chan).with("Trolla alguém, né idioti!")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!troll")
    end

    it "should call the correct show a quote when calling !troll command" do
      SimpleBot::Troll.should_receive(:random_to).with("morellon")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!troll morellon")
    end

    it "should call the correct show a quote when calling !quote command" do
      SimpleBot::Motorcycle.should_receive(:random)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!motorcycle")
    end

    it "should call the correct show a quote when calling !quote command" do
      SimpleBot::Quote.should_receive(:random)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote")
    end

    context "when adding a new quote of any kind" do
      it "should call the correct method to add a new quote when calling !add_quote command without mentioning the bot" do
        @mock_quote.should_receive(:add!)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_quote #{@quote_message}")
      end

      it "should call the correct method to add a new trolling when calling !add_troll command" do
        @mock_troll.should_receive(:add!)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_troll #{@quote_message}")
      end

      it "should call the correct method to add a new motorcycle when calling !add_motorcycle command" do
        @mock_motorcycle.should_receive(:add!)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_motorcycle #{@quote_message}")
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
        SimpleBot::Quote.should_receive(:random)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote")
      end

      it "should not call random by user method when a space is passed" do
        SimpleBot::Quote.should_receive(:random)
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote ")
      end

      it "should call the method to return a quote from a specific user" do
        SimpleBot::Quote.should_receive(:random_by_search).with("qmx")
        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!quote qmx")
      end
    end
  end

  context "when using flame war" do
    it "should call the correct method to enable flame war" do
      SimpleBot::FlameWar.should_receive(:on!)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!flame on")
    end

    it "should call the correct method to disable flame war" do
      SimpleBot::FlameWar.should_receive(:off!)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!flame off")
    end

    it "should check for flames if is a simple message" do
      SimpleBot::FlameWar.should_receive(:flame_on)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :ruby sux")
    end

    it "should add a flame sentence" do
      key = "php"
      sentence = "php is a virus"
      SimpleBot::FlameWar.should_receive(:add).with(key, sentence)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!add_flame #{key}, #{sentence}")
    end
  end

  context "using google services" do
    it "should call google translate method with the given query" do
      SimpleBot::Google.should_not_receive(:translate)
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!t-asdf^asdf hell")
    end

    it "should return the translation using the correct format" do
      SimpleBot::Google.should_receive(:translate).with("en", "pt", "hell").and_return("inferno")
      subject.should_receive(:say_to_chan).with("inferno")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!t-en-pt hell")
    end

    it "should search on google for a given query" do
      SimpleBot::Google.should_receive(:search).with("pothix")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!google pothix")
    end
  end

  describe "#message_control" do
    context "dispatching events to EventListener" do
      it "dispatches the event" do
        SimpleBot::EventListener.should_receive(:registered?).
                                 with('abobrinha').
                                 and_return(true)

        SimpleBot::EventListener.should_receive(:dispatch).
                                 with('abobrinha', 'Salada', subject)

        subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!abobrinha Salada")
      end
    end
  end

  context "looking for asians" do
    it "should return a picture of an asian girl" do
      SimpleBot::Asian.should_receive(:fetch).and_return("korea")
      subject.should_receive(:say_to_chan).with("korea")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!asian")
    end
  end

  context "asking for the git repository" do
    it "should return the github address" do
      subject.should_receive(:say_to_chan).with("https://github.com/guru-sp/Guru-sp-IRC-Bot")
      subject.message_control(@socket, ":PotHix ! PRIVMSG ##{CHANNEL} :!git")
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
