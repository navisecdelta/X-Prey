#!/usr/bin/env ruby

require 'optparse'
require 'ruby-progressbar'
require './lib/xprey.rb'

trap "SIGINT" do
  puts "\nBye Bye, thanks for using X-prey by Navisec Delta :)"
  exit 130
end

ARGV << '-h' if ARGV.empty?

options = {}
optparse = OptionParser.new do|opts|
    # Set a banner, displayed at the top
    # of the help screen.
    opts.banner = "Usage: x-prey.rb " 
    # Define the options, and what they do
    options[:company] = false
    opts.on( '-c', '--company "CompanyName"', 'Name of Company' ) do|company|
        options[:company] = company
    end

    options[:emails_file] = false
    opts.on( '-i', '--emails email-list.txt', 'Domain name used with Email' ) do|emails_file|
        options[:emails_file] = emails_file
    end

    options[:breach_data_file] = false
    opts.on( '-i', '--breaches breachpairs.txt', 'File containing breach data or known passwords' ) do|filename|
        options[:breach_data_file] = filename
    end

    options[:outfile] = false
    opts.on( '-o', '--outfile wordlist.txt', 'File to save the wordlist to' ) do|outfile|
        options[:outfile] = outfile
    end
    # This displays the help screen, all programs are
    # assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end
end

optparse.parse!

if options[:company] and options[:emails_file]
banner = %q{__  __     ____
\ \/ /    |  _ \ _ __ ___ _   _
 \  /_____| |_) | '__/ _ \ | | |
 /  \_____|  __/| | |  __/ |_| |
/_/\_\    |_|   |_|  \___|\__, |
                          |___/

Author: pry0cc | NaviSec Delta | delta.navisec.io
}

    puts banner
    puts "[*] Initializing X-Prey..." 
    company_name = options[:company]
    emails_filename = options[:emails_file]

    emails = File.open(emails_filename).read().split("\n")

    breach_data = ""

    if options[:breach_data_file]
        breach_data = File.open(options[:breach_data_file]).read()
    end

    xprey = XPrey.new(emails, company_name, breach_data)
    wordlist = xprey.run()

    if options[:outfile]
        file = File.open(options[:outfile], "w+")
        wordlist.each do |line|
            file.write(line + "\n")
        end
        file.close
        puts "[+] Wordlist saved to #{options[:outfile]}"
    else
        puts wordlist
    end

end















