#!/usr/bin/env ruby
require_relative 'optionsParse'
require_relative 'values_at'
require 'colorize'
require 'net/ssh'

class SSHTool
  
  def initialize(options)
    o = OptParser.new().parse(options)
    @username, @function, @hostnames = o.values_at(:username, :function, :hostnames)
    parse
  end
  
  def parse
    @hostnames.each do |host|
      ssh_start(@username, @function, host)
    end
  end
  
  def ssh_start(username, function, host)
    Net::SSH.start(host, username) do |ssh|
      ssh.open_channel do |channel|
        execute_function(channel, username, function, host)
      end
      ssh.loop
    end
  end  
  
  def execute_function(channel, username, function, host)
    message(username, function, host)
    channel.exec function do |ch, success|
      abort "Error" unless success
      channel.on_data do |c, data|
        puts "#{data}"
      end
    end
  end  
  
  def message(username, function, host)
    function = function.colorize(:light_blue)
    host = host.colorize(:light_magenta)
    username = username.colorize(:light_green)
    puts "Executing '#{function}' on '#{host}' as user '#{username}'...\n"
  end  
  
end

ssh_tool = SSHTool.new(ARGV)
