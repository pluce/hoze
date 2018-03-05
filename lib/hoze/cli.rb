require "hoze"

script = ARGV[0]

unless script
  puts "No worker script given"
  exit 1
end

puts "Running with worker script #{script}"

script_path = Pathname.new(script).realpath

puts "Loading script from file #{script_path}"

require script_path