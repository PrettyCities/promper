
require 'db'

class BasicMatching
  include DataBase

  def removeTooLongPotentialMatches(
    potential_match_array, node_target_phoneme)
    potential_match_array.each do |word|
      if word.length > node_target_phoneme.length
        potential_match_array.delete(word)
      else
        next
      end
    end
  end
end

class ExactMatch < BasicMatching
  def initialize
    super
  end

  def determine_first_letter(node_target_phoneme)
    node_target_phoneme[0]
  end

  def pull_relevant_values_from_dict(key)
    db[key]
  end

  def match(node_target_phoneme)    
    first_letter = determine_first_letter(node_target_phoneme)
    relevant_values = pull_relevant_values_from_dict(first_letter)
    matches = relevant_values.select {|word, phoneme_representation| passes_tests?(word, node_target_phoneme)}    
    phoneme_chunks = determine_remaining_phoneme_chunks(matches, node_target_phoneme)
    combine_matches_and_phoneme_chunks(matches,phoneme_chunks)
  end

  def passes_tests?(word, node_target_phoneme)
    letter_match?(word, node_target_phoneme) &&
    length_okay?(word, node_target_phoneme) &&
    remaining_letter_match?(word, node_target_phoneme)
  end

  def letter_match?(word, node_target_phoneme, index=0)    
    word[index] == node_target_phoneme[index]
  end

  def length_okay?(word, node_target_phoneme)
    word.length <= node_target_phoneme.length
  end

  def remaining_letter_match?(word, node_target_phoneme)
    word_length = word.length
    word_length.times do |letter|
      unless letter_match?(word, node_target_phoneme, index=letter)
        return false        
      end
    end
    true
  end

  def determine_remaining_phoneme_chunks(final_matches, node_target_phoneme)
    chunks = final_matches.map do |phonemes|
      phoneme_length = phonemes.length
      this_chunk = node_target_phoneme[phoneme_length..-1]
    end
  end

  def combine_matches_and_phoneme_chunks(final_matches,phoneme_chunks)
    final_matches.zip(phoneme_chunks)
  end

end

class LooseMatch < BasicMatching
  attr_reader :basic_equivalence_dict, :prev_switch
  attr_accessor :node_target_phoneme, :previously_searched_phonemes
  def initialize
    super
    @basic_equivalence_dict = {
  "i" => %w[ɪ ə],
  "z" => %w[s],
  "ə" => %w[i ɪ ʌ æ u],
  "u" => %w[ə],
  "ɪ" => %w[i],
  "d" => %w[t],
  "æ" => %w[ə ʌ ɛ],
  "s" => %w[z],
  "ɝ" => %w[r],
  "r" => %w[ɝ],
  "a" => %w[ʌ ə],
  "p" => %w[b],
  "t" => %w[d],
  "g" => %w[k],
  "ʌ" => %w[ə æ i a],
  "ɛ" => %w[æ],
  "b" => %w[p],
  "f" => %w[v],
  "v" => %w[f],
  "k" => %w[g],  
  "j" => %w[ʃ],
  "ʃ" => %w[j]
}
  @previously_searched_phonemes = {}
  end

  def add_to_prev_phones(node_target_phoneme, matches)
    previously_searched_phonemes[node_target_phoneme] = matches
  end

  def one_phoneme_remaining?(node_target_phoneme)
    begin
      node_target_phoneme.length == 1
    rescue
      false
    end
  end

  def bail
    [node_target_phoneme, ""]
  end

  def no_phonemes_remaining?(node_target_phoneme)
    node_target_phoneme == nil ||
    node_target_phoneme.length == 0
  end

  def target_phoneme_convert(node_target_phoneme)
      list_of_words = node_target_phoneme.split
      ipa_list = list_of_words.map do |word|
        word.to_ipa.tr('ˈˌ', '')
      end
      ipa_list = ipa_list.join
  end

  def match(node_target_phoneme)
    if previously_searched_phonemes.key? node_target_phoneme
      return previously_searched_phonemes[node_target_phoneme]
    end
    if one_phoneme_remaining?(node_target_phoneme)
      bail 
    elsif no_phonemes_remaining?(node_target_phoneme)
      return nil
    else
      first_letter = determine_first_letter(node_target_phoneme)
      begin
        relevant_values = pull_relevant_values_from_dict(first_letter)

        matches = get_relevant_matches(relevant_values, node_target_phoneme)
        if matches.empty?
          add_to_prev_phones(node_target_phoneme, nil)
          return nil
        else
          chunks = matches.map do |word, phoneme_representation|
            determine_remaining_phoneme_chunks(phoneme_representation, node_target_phoneme)
          end
          matches = post_processing(chunks, matches)
        end
      rescue
        puts "Inner rescue"
        puts $!, $@
      end
    end
    add_to_prev_phones(node_target_phoneme, matches)
    matches
  end

  def determine_first_letter(node_target_phoneme)
    node_target_phoneme[0]
  end

  def pull_relevant_values_from_dict(key)
    initial_values      = db[key]
    if basic_equivalence_dict.has_key?(key)
      equilvalent_keys    = basic_equivalence_dict[key]
      equilvalent_keys.map do |key|
        db[key].each do |word|
          initial_values << word
        end
      end
    end
    initial_values
  end

  def get_relevant_matches(relevant_values, node_target_phoneme)
    rel = relevant_values.map {
        |word, phoneme_representation| [word, phoneme_representation] if passes_tests?(phoneme_representation, node_target_phoneme)}
    rel.compact
  end

  def passes_tests?(word, node_target_phoneme)
    letter_match?(word, node_target_phoneme) &&
    length_okay?(word, node_target_phoneme) &&
    remaining_letter_match?(word, node_target_phoneme)
  end

  def letter_match?(word, node_target_phoneme, index=0)       
    word[index] == node_target_phoneme[index] ||
    (basic_equivalence_dict.key?(word[index]) &&
    basic_equivalence_dict[word[index]].include?(node_target_phoneme[index]))
  end

  def length_okay?(word, node_target_phoneme)
    word.length <= node_target_phoneme.length
  end

  def remaining_letter_match?(word, node_target_phoneme)
    word_length = word.length
    word_length.times do |letter|
      unless letter_match?(word, node_target_phoneme, index=letter)
        return false        
      end
    end
    true
  end

  def determine_remaining_phoneme_chunks(phoneme_representation, node_target_phoneme)
    phoneme_length = phoneme_representation.length
    node_target_phoneme[phoneme_length..-1]
  end

  def post_processing(chunks, matches)
    matches.zip(chunks).each{ |word, chunk| word[1] = chunk }
    matches
  end

  def combine_matches_and_phoneme_chunks(final_matches,phoneme_chunks)
    final_matches.zip(phoneme_chunks)
  end
end