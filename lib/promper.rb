require 'promper/version'
require_relative 'promper/gab_tree'
require 'promper/gab_tree_processor'
require 'promper/refiners/dict_refine'

class Promper
  def initialize(args = {})
    @refiner = args[:refiner] || DictRefine.new
  end

  def search(phrase)
    tree = GabTree.new(phrase)
    processor = GabTreeProcessor.new(tree.root_node)
    tree.iterate_until_finished
    result_ar = processor.result
    @refiner.convert_arr_to_dict(result_ar)
  end
end
