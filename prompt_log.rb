require 'readline'

# prevent ctrl-c
Signal.trap("INT", nil)

completion = proc do |str|
  if Readline.line_buffer.split.length > 1 or Readline.line_buffer.end_with?(' ')
    Dir["#{str}*"].grep(/^#{Regexp.escape(str)}/i)
  else
    CMDS.grep(/^#{Regexp.escape(str)}/i).map { |s| "#{s} " }
  end
end

Readline.completion_proc = completion        # Set completion process
Readline.completion_append_character = nil   # Make sure to add a space after completion
Readline.completer_word_break_characters = ' '

def prompt_lines(prompt = '> ')
  while (line = Readline.readline(prompt, true))  # make add_hist = true
    yield line
  end
end
