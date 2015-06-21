#!/usr/bin/env ruby

require 'benchmark'
require 'optparse'

# In this module I present two version of the palendrome method. The first version,
# in which I considered the simple solution, reverse the incoming string and 
# compares it to itself. The second solution, in essence splits the string in half
# and compares the front of the string to the end of the string. Bench marking 
# indicates to me that my first solution is the faster of the two but I present
# both for your interpretation (Which is the closest to O(1) time complexity if
# any at all?).

module Palindrome
	extend self	
	
	# Sudo constructor used to initialize the @option instance variable
	# and control the flow of the module,
	# @param args [Array]
	def Palindrome(args)
		@option = {
			:reverse => nil,
			:benchmark => false,
			:string => nil
		}
	
		parse(args)
			.join
			.work
	end 	
	
	#------------------------------------------------------------------------------------------------------
	
	# Takes the string to be evaluated reverses and compares it against it self.	
	def reverse
		@option[:string] == @option[:string].reverse ? true : false
	end 

	# Calculates the length of the string. 
	# Loops from 0 to the length of the string divided by 2, minusing 1 from the quotient.
	# During the loop string[loop count] is compared against string[(string lenght) - (loop count += 1)]
	# If the loops completes with all conditions met true is return.
	# If there is a mismatch false is returned. 
	def half
		l = @option[:string].length
		
		(0..((l/2)-1)).each do |i|
  		return false unless @option[:string][i] == @option[:string][l-(i+=1)]
		end

		return true
	end
	
	#------------------------------------------------------------------------------------------------------
	
	# User interface
	# @param args [Array]
	def parse(args)
		help = nil
		
		option = OptionParser.new do |opts|
			opts.banner = "Palindrome?".center(80, '-')
			opts.separator ""
			opts.separator "DESCRIPTION:"
			opts.separator "	 Primary function is to inform the user whether or not the input string is a"
			opts.separator "	 Palindrom. Two methods have been implemented into this module to accomplish the"
			opts.separator "	 same task. One method reverses the input string and compares it to itself. The"
			opts.separator "	 other method in essence splits the string in half and compares the string back"
			opts.separator "	 to front, it's a  more mathematical means of accomplishing the task."
			opts.separator "	 Both means are avaliable for your use and evaluation,"
			opts.separator " "
			opts.separator "USAGE:"
			opts.separator "	 A call is made to palindrome.rb with two options (see options for more details)"
			opts.separator "	 one to indicate what method will be used to determine whether or not the input is"
			opts.separator "	 a palindrome, and the next option which will either indicates that the following string"
			opts.separator "	 is the string to be evaluated or run bench mark on the selected method."
			opts.separator " "
			opts.separator "EXAMPLE:"
			opts.separator "	 ./palindrome.rb [METHOD] -s [STRING]"
			opts.separator "	   e.g ./palindrome.rb -r -s \"nurses run\""
			opts.separator "	   e.g ./palindrome.rb -c -s redivider"
			opts.separator "	 ./palindrome.rb [METHOD] [BENCHMARK]"
			opts.separator "	   e.g ./palindrome.rb -r -b"
			opts.separator "	   e.g ./palindrome.rb -c -b"
			opts.separator " "
			opts.separator "OPTIONS:"
			opts.on("-r", "--reverse", "Utilize the reverse string method") do |r| @option[:reverse] = true; end
			opts.on("-h", "--half", "Utilize the half string method") do |m| @option[:reverse] = false; end
			opts.on("-b", "--benchmark", "Run bench mark on the selected method") do |b| @option[:benchmark] = true; end
			opts.on("-s STRING", "--string STRING", String, "String to be evaluated") do |s| @option[:string] = s; end
			opts.on("-?", "--help"){ puts option }
			help = opts.help
		end.parse!
		
		if @option[:reverse].nil? || (!@option[:reverse].nil? && @option[:string].nil? && !@option[:benchmark])
			puts help; exit 1
		end	
		self
	end

	# Join strings containing spaces into a single string	
	def join
		@option[:string].downcase!
		@option[:string] = @option[:string].split('') 
		@option[:string].delete(" ") unless !@option[:string].include?(" ")
		@option[:string] = @option[:string].join unless @option[:string].class != Array		
		self
	end
		
	# Flow control method 	
	def work
		unless @option[:benchmark]
			out = @option[:reverse] ? reverse : half
			print(out)
		else
			time_for(Proc.new {@option[:reverse] ? reverse : half} )
		end	
	end

	# Outputs the parameter to the screen.	
	def print(out); puts out; end
	
	# Utililze to bench mark reverse and half
	# @param a_proc [Process] Either reverse or half
	def time_for(a_proc)
		(2..40).step(2) do |i|
 			@option[:string] = 'dad' * i

  		Benchmark.bm do |x|
    		x.report(:gsub){ 1000.times {a_proc.call}}
  		end
		end
	end
		
end

Palindrome.Palindrome(ARGV)
