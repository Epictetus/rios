require "rios/util"
require "rios/terminal"

module Rios
  class Proxy
    DEFAULT_COMMAND = ENV["SHELL"]

    def initialize
      @fd_master, @fd_slave = Util.openpty($stdin.fileno)
      @input_filters  = []
      @output_filters = []
      @on_finishes    = []
      @pty_lock       = Mutex.new
    end

    ##
    # register handler which will be called when user inputs characters
    def on_input(&block)
      @input_filters.push(block)
    end

    ##
    # register handler which will be called when target program outputs characters
    def on_output(&block)
      @output_filters.push(block)
    end

    ##
    # register handler which will be called when target program exits
    def on_finish(&block)
      @on_finishes.push(block)
    end

    ##
    # emulate user input
    def input(string)
      @pty_lock.synchronize {
        terminal.master.syswrite(string)
      }
      nil
    end

    ##
    # output string to the stdout (usually terminal)
    def output(string)
      @pty_lock.synchronize {
        $stdout.syswrite(string)
      }
      nil
    end

    ##
    # begin proxy session
    def listen(command = nil, &block)
      @command = command || DEFAULT_COMMAND

      in_raw_mode {
        fork {
          fork {
            do_command(block)
          }
          do_output()
        }
        Signal.trap(:CHLD) { terminal.master.close() } # TODO: Is this OK?
        do_input()
      }
    end

    private

    def apply_filters(s, filters)
      filters.reduce(s) { |acc, filter|
        res = filter.call(acc)
        # when filter returens `nil', use previous value as output
        res.nil? ? acc : res
      }
    end

    def in_raw_mode
      old_tt = Termios::tcgetattr($stdin)
      raw_tt = old_tt.clone

      begin
        Terminal::set_raw_mode(raw_tt)
        raw_tt.c_lflag &= ~Termios::ECHO
        Termios.tcsetattr($stdin, Termios::TCSAFLUSH, raw_tt)
        yield
      ensure
        Termios.tcsetattr($stdin, Termios::TCSAFLUSH, old_tt)
      end
    end

    def create_terminal
      Terminal.new(@fd_master, @fd_slave)
    end

    def terminal
      @terminal || @terminal = create_terminal
    end

    def do_input
      terminal.slave.close

      begin
        while s = $stdin.sysread(Util::BUFSIZ) do
          input(apply_filters(s, @input_filters))
        end
      rescue
      end

      @on_finishes.each { |block| block.call }
    end

    def do_output
      $stdout.sync = true
      $stdin.close
      terminal.slave.close

      begin
        while s = terminal.master.sysread(Util::BUFSIZ) do
          output(apply_filters(s, @output_filters))
        end
      rescue
      end

      terminal.master.close
    end

    def do_command(block)
      Process.setsid()
      Util::set_controlling_tty(terminal.slave.fileno, $stdin.fileno)

      terminal.master.close
      $stdin.reopen(terminal.slave)
      $stdout.reopen(terminal.slave)
      $stderr.reopen(terminal.slave)
      terminal.slave.close

      if block
        block.call
      elsif @command.class == Array
        exec(*@command)
      else
        exec(@command)
      end
    end
  end
end
