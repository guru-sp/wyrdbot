module Support
  module Fixtures
    extend self

    def load_file(filename)
      File.read(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/' + filename)
    end
  end
end
