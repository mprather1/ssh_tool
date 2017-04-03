#!/usr/bin/env ruby
require 'optparse'

class OptParser
  
  class ScriptOptions
    
    attr_accessor :username, :function, :hostnames
    
    def define_options(parser)
      parser.banner = "Usage: ruby sshtool.rb [options]"
      get_username(parser)
      get_function(parser)
      get_hostnames(parser)
    end
  
    def get_username(parser)
      parser.on('-u, --username') do |u|
        self.username = u
      end
    end
    
    def get_function(parser)
      parser.on('-f, --function') do |f|
        self.function = f
      end
    end
    
    def get_hostnames(parser)
      parser.on('-c, --hostnames', Array) do |h|
        self.hostnames = h
      end
    end
    
    def get_help(parser)
      parser.on('-h', "--help", "Prints help") do
        puts@options
      end
    end
    
  end
  
  def parse(args)
    @options = ScriptOptions.new
    @args = OptionParser.new do |parser|
      @options.define_options(parser)
      parser.parse!(args)
    end
    @options
  end
  
end
