class GabTree
  require 'tree'
  require 'string_to_ipa'
  require 'matching'
  require 'test/unit'


  attr_reader :match_critera, :phoneme_convert
  attr_accessor :root_node, :node_counter, :target_phoneme

  def initialize(target_phoneme, args={})
    @target_phoneme = target_phoneme    
    @phoneme_convert = args[:phoneme_convert] || default_phoneme_convert
    @match_critera = args[:match_criteria] || default_match_criteria

    if @phoneme_convert == true
      @target_phoneme = target_phoneme_convert
    else
      @target_phoneme = default_target_phoneme
    end
    
    @node_counter = 0
    @root_node = Tree::TreeNode.new(
      node_counter_to_string, ["NONE IM THE ROOT!", @target_phoneme,
      state: :ready_to_continue])    
  end

  def default_phoneme_convert    
    false
  end

  def default_match_criteria    
    ExactMatch.new
  end

  def target_phoneme_convert
    if @phoneme_convert == true
        list_of_words = @target_phoneme.split
        ipa_list = list_of_words.map do |word|
          word.to_ipa.tr('ˈˌ', '')
        end
        ipa_list = ipa_list.join
    end
  end

  def default_target_phoneme
    target_phoneme.downcase.gsub(/\s+/, "")
  end

  def node_counter_to_string
    node_counter.to_s    
  end

  def iterate_until_finished
    until finished? do
      iterate_over_leaves     
    end    
  end

  def finished?
    @finished_check = false

    nodes = check_leaves
    nodes.each do |node|      
      if check_node_state(node) == :completed # How can I do this on one line?
        @finished_check = true
      elsif check_node_state(node) == :aborted
        @finished_check = true      
      else
        @finished_check = false
        break
      end        
    end

    @finished_check
  end

  def iterate_over_leaves
    nodes = check_leaves

    nodes.each do |node|

      unless check_node_state(node) == :ready_to_continue
        next
      else
        if checked_all_target_phonemes?(node)
          change_node_state_completed(node)
        else
          try_to_make_leaves(node)                    
          change_node_state_completed(node)
        end
      end
      
      if failedToMakeLeaves?(node)
        change_node_state_aborted(node)
      end
    end
  end

  def check_leaves
    root_node.each_leaf
  end

  def check_node_state(node)
    node.content[2][:state]
  end

  def checked_all_target_phonemes?(node)
    begin 
      node.content[1].length == 0
    rescue
      true
    end
  end

  def change_node_state_aborted(node)
    node.content[2][:state] = :aborted
  end

  def change_node_state_completed(node)
    node.content[2][:state] = :completed
  end

  def failedToMakeLeaves?(node)
    node.is_leaf? && !checked_all_target_phonemes?(node)
  end
  
  def try_to_make_leaves(node)
    @remaining_phoneme = get_remaining_phoneme_from(node)
    @match_array = make_match_array(@remaining_phoneme)
    unless @match_array == nil
      make_child_nodes(@match_array, node)
    end
  end

  def get_remaining_phoneme_from(node)
    node.content[1]
  end

  def make_match_array(node_target_phoneme) # Consider renaming to remaining_phoneme
    match_array = match_critera.match(node_target_phoneme)
    match_array
  end

  # Put as a separate method to remind me I have to figure out
  # what is going on! For some reason I can't increment
  # the counter if I use node_counter += 1. Strange!
  def node_counter_increment
    @node_counter += 1
  end

  def make_child_nodes(match_array, node)
    match_array.each do |matched_phoneme, remaining_phoneme_chunk|      
      node_counter_increment         
      node << Tree::TreeNode.new(
        node_counter_to_string, [matched_phoneme, remaining_phoneme_chunk,
        state: :ready_to_continue])      
    end
  end
end





