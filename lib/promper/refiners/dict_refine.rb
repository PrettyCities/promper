class DictRefine
  attr_accessor :main_dict

  def initialize
    @main_dict = Hash.new([])
  end

  def convert_arr_to_dict(word_array)
    iterate_until_finished(word_array)
    result = @main_dict
    dict_reset
    result
  end

  private

    def dict_reset
      @main_dict = Hash.new([])
    end

    def iterate(word_array, previous_word_list=[])
      first_word_key_dict = collect(word_array)
      first_word_key_dict.each do |key, value|
        process(value, previous_word_list)
      end
    end

    def iterate_until_finished(word_array, previous_word_list=[])
      first_word_key_dict = collect(word_array)
      first_word_key_dict.each do |key, value|
        previous_word_list << value[0][0]
        process_repeatedly(value, previous_word_list)
        previous_word_list.pop
      end
    end

    def more_to_process?(word_array)
      word_array.each do |arr|
        if arr.length > 1
          return true
        end
      end
      false
    end

    def collect(original_word_array)
      data_hash = Hash.new([])
      original_word_array.each do |arr|
        if data_hash.key?(arr[0])
          data_hash[arr[0]] << arr
        else
          data_hash[arr[0]] = []
          data_hash[arr[0]] << arr
        end
      end
      data_hash
    end

    def process(word_array, previous_word_list=[])
      previous_word_list << word_array[0][0]

      string_to_eval = make_evalable(previous_word_list)

      word_array.each do |arr|
        arr.shift
      end

      unique_firsts = get_unique_firsts(word_array)
      new_dict = make_new_dict(unique_firsts)
      update_original_dict(new_dict, string_to_eval)
    end

    def process_repeatedly(word_array, previous_word_list=[])
      string_to_eval = make_evalable(previous_word_list)

      word_array.each do |arr|
        arr.shift
      end

      unique_firsts = get_unique_firsts(word_array)
      new_dict = make_new_dict(unique_firsts)
      update_original_dict(new_dict, string_to_eval)

      if more_to_process?(word_array)
        iterate_until_finished(word_array, previous_word_list)
      end
    end

    def make_evalable(previous_word_list)
      string_to_eval = ""
      previous_word_list.each do |word|
        string_to_eval << "[\"#{word}\"]"
      end
      string_to_eval
    end

    

    def get_unique_firsts(word_array)
      uniques = []
      word_array.each do |arr|
        unless uniques.include?(arr[0])
          uniques << arr[0]
        end
      end
      uniques
    end

    def make_new_dict(unique_firsts)
      new_dict = Hash.new({})
      unique_firsts.each do |word|
        new_dict[word] = {}
      end
      new_dict
    end

    def update_original_dict(new_dict, string_to_eval)
      eval("@main_dict#{string_to_eval} = #{new_dict}")
    end
end