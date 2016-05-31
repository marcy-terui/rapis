module Rapis
  class TermColor
    class << self
      def green(msg)
        colorize 32, msg
      end

      def yellow(msg)
        colorize 33, msg
      end

      def red(msg)
        colorize 31, msg
      end

      def colorize(num, msg)
        "\e[#{num}m#{msg}\e[0m"
      end
    end
  end

  def self.logger
    Rapis::Logger.instance
  end

  #
  # Default logger
  #
  class Logger < Logger
    include Singleton

    def initialize
      super(STDERR)

      self.formatter = proc do |_severity, _datetime, _progname, msg|
        "#{msg}\n"
      end

      self.level = Logger::INFO
    end

    def debug(msg, progname = nil, method_name = nil)
      super(progname) { { method_name: method_name, message: msg } }
    end

    def info(msg)
      super { Rapis::TermColor.green(msg) }
    end

    def warn(msg)
      super { Rapis::TermColor.yellow(msg) }
    end

    def fatal(msg)
      super { Rapis::TermColor.red(msg) }
    end

    def error(msg, backtrace, progname = nil, method_name = nil)
      super(progname) do
        { method_name: method_name, message: msg, backtrace: backtrace }
      end
    end
  end
end
