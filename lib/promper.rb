require 'promper/version'
require 'gab_tree'
require 'gab_tree_processor'

class Promper
  def initialize
    
  end

  def go_boy
    puts "Ruff ruff ruff!\nMy name is promper! I'm an energetic dog!!!"
    while true
      phrase = prompt("What are we looking for? (Enter nothing to quit)")
      if phrase == ''
        break
      end
      result = search(phrase)
      puts "\nI think I found it!\n"
      pp(result)
    end
  end

  def prompt(phrase = '')
    puts "\n*drool drool drool*\n#{phrase}"
    phrase = gets.chomp
  end

  def search(phrase)
    tree = GabTree.new(phrase,
        phoneme_convert: true, match_criteria: LooseMatch.new)
    processor = GabTreeProcessor.new(tree.root_node)
    tree.iterate_until_finished
    processor.result
  end

  def clipboard_copy(result)
    IO.popen("pbcopy", "w") { |pipe| pipe.puts result }
  end  
end