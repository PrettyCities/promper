class GabTreeProcessor < GabTree
  attr_reader :gab_tree
  def initialize(gab_tree) # Root node of gab_tree
    @gab_tree = gab_tree
  end

  def result
    leaf_phoneme_array_from_completed_tree
  end

  def check_leaves # This seems to duplicate the GabTree class code.
    gab_tree.each_leaf
  end

  def leaf_phoneme_array_from_completed_tree
    nodes = check_leaves()
    node_parents_path = node_parents_path_from_nodes(nodes)
    parents_content = conv_node_parents_path_to_parents_content(node_parents_path)
    leafs_content = get_leaf_content(nodes)    
    zipped_content = leafs_content.zip(parents_content)
    massage_zipped_content(zipped_content)   
  end

  def only_keep_completed_nodes(nodes)
    nodes.each do |node|      
      if node.content[2][:state] != :completed        
        nodes.delete(node)
      end
    end
  end

  def node_parents_path_from_nodes(nodes)
    nodes = nodes.select  {|node| node.content[2][:state] == :completed }
    nodes.map do |node|
      parents = node.parentage
    end
  end

  def conv_node_parents_path_to_parents_content(node_parents_path)
    node_parents_path.map do |node_path|
      content_from_node_path(node_path)        
    end
  end

  def content_from_node_path(node_path)
    node_path.map do |node|
      node.content[0]
    end
  end

  def get_leaf_content(nodes)
    nodes = nodes.select  {|node| node.content[2][:state] == :completed }
    nodes.map do |node|
      node.content[0]
    end
  end

  def massage_zipped_content(zipped_content)
    flattened_matches = zipped_content.map do |match|
      match.flatten      
    end

    flattened_matches.map do |match|
      match.pop
      match.reverse
    end
  end
end