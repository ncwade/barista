
require 'optparse'

class BaristaOptionParser

  def initialize
    @commands = {}
  end

  def command(cmd)
    options = {:toolchain => "gcc", :prefix => "", :baseimage => "linux-x86"}
    option_parser = OptionParser.new do |opts|
      opts.banner = "Usage: barista #{cmd} [options]"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end
    end

    @commands[cmd] = [option_parser, options]

    yield option_parser, options if block_given?
  end

  def parse!(args = ARGV)
    cmd = args.shift
    if @commands.keys.include? cmd
      @commands[cmd][0].parse!(args)
    else
      puts "Invalid command :/"
      exit
    end
    return cmd, @commands[cmd][1]
  end
end
