#!/bin/ruby

require_relative 'prompt_log'
require_relative 'utils_log'

# List of commands
CMDS = %w[show load help exit].sort

def execute(line, manager)
  case line
  when /^debug/
    puts manager.logs
  when /^help/
    puts "Available commands:\n#{CMDS.join("\t")}"
  when /^show\s?(\s+(?<procs>\S+(\s+\S+)*))?$/
    if $~[:procs].nil?
      manager.to_s
    else
      manager.to_s($~[:procs].split)
    end
  when /^load\s?(?<path>[^\s]+)?(?<too_much>.+)?$/
    if not $~[:too_much].nil?
      warn "load: too many arguments".red
    elsif $~[:path].nil?
      warn "load: missing path argument".red
    elsif File.file?($~[:path])
      manager.load_log_from_file($~[:path])
      puts "LOADED: FILE".green
    elsif File.directory?($~[:path])
      manager.load_log_from_folder($~[:path])
      puts "LOADED: DIRECTORY".green
    else
      warn "load: Invalid path argument".red
    end
  when /^exit/
    puts 'Exiting..'.green
    exit 0
  when ''
    nil
  else
    puts "#{line}: unknown command, type 'help' for help"
  end
end

manager = LogManager.new
prompt_lines do |line|
  execute(line, manager)
end
