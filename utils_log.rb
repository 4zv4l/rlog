require 'find'
require 'colorize'

class LogManager
  attr_reader :logs

  def initialize(logs = nil)
    add_logs(logs) unless logs.nil?
    @logs = {}
  end

  def load_log_from_file(path)
    warn "#{path}: not readable" and return unless File.readable?(path)

    File.foreach(path, chomp: true) do |log|
      add_log(log)
    end
  end

  def load_logs_from_folder(path)
    Find.find(path) { |entry| load_log_from_file(entry) if File.file?(entry) && entry.end_with?('log') && File.readable?(entry) }
  end

  def add_log(log)
    proc = Log.new(log).parse[:prg]
    @logs[proc] = log
  end

  def add_logs(logs)
    logs.each do |log|
      add_log(log)
    end
  end

  def nbr_logs
    @logs.length
  end

  def to_s(procs = nil)
    @logs.each_key do |proc|
      if procs.nil?
        puts "#{proc}:".bold
        puts "======="
        puts "  #{@logs[proc]}".yellow
      elsif procs.include?(proc)
        puts "#{proc}:".bold
        puts "======="
        puts "  #{@logs[proc]}".yellow
      end
    end
    puts "TOTAL LOGS: #{nbr_logs}".green
  end
end

class Log
  def initialize(line)
    @log = line
  end

  def parse
    /^(?<date>([^\s]+)(\s)+(\d+)\s((\d+:?){3}))\s(?<host>[^\s]+)\s(?<prg>[^\s\[]+)(\[(?<pid>\d+)\])?:\s(?<msg>.+)$/.match(self.to_s)
  end

  def to_s
    @log
  end
end
