require 'readline'

# prevent ctrl-c
Signal.trap("INT", nil)

completion = proc do |str|
  CMDS.grep(/^#{Regexp.escape(str)}/i) unless str.end_with?(' ')
end

Readline.completion_proc = completion        # Set completion process
Readline.completion_append_character = ' '   # Make sure to add a space after completion
Readline.completer_word_break_characters = "\n"

def prompt_lines(prompt='> ')
  while (line = Readline.readline(prompt, true))  # make add_hist = true
    yield line
  end
end
