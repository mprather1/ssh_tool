#!/usr/bin/env ruby
require_relative 'optionsParse'

require 'net/ssh'

o = OptParser.new

options = o.parse(ARGV)

username = options.username
function = options.function
hostnames = options.hostnames
def run(username, function, hostnames)
  hostnames.each do |host|
    ssh_start(username, function, host)
  end
end

def ssh_start(username, function, hostname)
  Net::SSH.start(hostname, username) do |ssh|
    ssh.open_channel do |channel|
      puts "\nExecuting #{function} on #{hostname}"
      channel.exec function do |ch, success|
        abort "Error" unless success
        channel.on_data do |c, data|
          puts "#{data}"
        end
      end
    end
    ssh.loop
  end
end

run(username, function, hostnames)
