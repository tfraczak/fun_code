# This file can be called with require_relative
# or you can wrap this in a module and include it in a class
# made by Tim Fraczak

###################################### CONTENTS #############################################
#                                                                                           #
# Everything is generated based on the frequency of the particular in the                   #
# English language.                                                                         #
#                                                                                           #
# rand_username - generates a username of variable length with 1 to 4 numbers               #
# rand_title - generates a title with proper capitalization                                 #
# rand_word - generates a word                                                              #
# rand_sentence - generates a proper sentence with proper punctuation                       #
# rand_paragraph - generates a proper paragraph with indentation                            #
# rand_essay - generates an essay                                                           #
# rand_n_words_paper(num) - need a 10,000 words paper quick for your class? I got you, fam. #
#                                                                                           #
#############################################################################################

# -------------- some helper methods for constructing the rand stuff

def bell_sort(arr)
  bell = []
  arr.sort!
  l = arr.length
  l.times do |i|
    if i.even?
      bell.unshift(arr.pop)
    else
      bell.push(arr.pop)
    end
  end
  bell
end

def weights_constructor(hash)
  weighted_keys = []
  hash.each do |key,weight|
    (weight*10).to_i.times { weighted_keys << key }
  end
  weighted_keys
end

# ------------- constructing weights for particulars

def weighted_vowels
  vowels = %w(a e i o u)
  vowel_weights = [8.6,12.1,7.3,7.4,2.7]
  weights_hash = Hash[vowels.zip vowel_weights]
  weights_constructor(weights_hash)
end

def weighted_consonants
  consonants = %w( b c ch d f g h j k l m n p ph qu r s sh t th v w x y z )
  consonant_weights = [1.6,2.7,0.5,3.9,2.2,2.1,5.0,0.2,0.8,4.2,2.5,7.2,2.0,0.1,0.1,6.3,6.2,0.5,5.0,4.0,1.1,1.8,0.2,1.7,0.1]
  weights_hash = Hash[consonants.zip consonant_weights]
  weights_constructor(weights_hash)
end

def weighted_word_lengths
  lengths = (1..16).to_a 
  length_weights = [8,12,5.2,8.5,12.2,14,14,12.6,10.1,7.5,5.2,3.2,2.0,1.0,0.6,0.3]
  weights_constructor(Hash[lengths.zip length_weights])
end

def weighted_sentence_lengths
  weighted_lengths = []
  lengths = (5...20).to_a
  arr = [2.3, 3.2, 4.7, 6.8, 7.0, 10.8, 11.5, 13, 11.1, 8.6, 6.9, 5.1, 4.5, 2.4, 2.1]
  pcts = bell_sort(arr)
  weights_constructor(Hash[lengths.zip pcts])
end

def weighted_paragraph_lengths
  lengths = (3..15).to_a
  weighted_lengths = bell_sort([6.0,8.6,8.2,5.1,4.5,4.8,6.5,10.8,12.1,3.9,9.1,8.8,1.4])
  para_hash = Hash[lengths.zip weighted_lengths]
  weights_constructor(para_hash)
end

# ------------------- constants to be used in various parts of code

VOWELS = weighted_vowels
CONSONANTS = weighted_consonants
WORD_LENGTHS = weighted_word_lengths
SENTENCE_LENGTHS = weighted_sentence_lengths
PARAGRAPH_LENGTHS = weighted_paragraph_lengths

# ------------------- #rand_ methods

def rand_username
  username = ""
  nums = (0..9).to_a
  (4..7).to_a.sample.times do |i|
    if i.even?
      username << CONSONANTS.sample
    else
      if username[-2..-1] == "qu" || username[-2..-1] == "Qu"
        username << (VOWELS-["u"]).sample
      else
        username << VOWELS.sample
      end
    end
  end
  (1..4).to_a.sample.times do
    username << nums.sample.to_s
  end
  username
end

def rand_title
  title = ""
  n = [1,2].sample
  n.times do |j|
    min = 5/(j+1)
    max = 9/(j+1)
    (min..max).to_a.sample.times do |i|
      if i.even? && i != 0
        title << CONSONANTS.sample
      elsif i == 0
        title << CONSONANTS.sample.capitalize
      else
        if title[-2..-1] == "qu" || title[-2..-1] == "Qu"
          title << (VOWELS-["u"]).sample
        else
          title << VOWELS.sample
        end
      end
    end
    title += " "
  end
  title[0...-1]
  title[0...-1].split(" ").reverse.join(" ")
end

def rand_word
  word = ""
  length = WORD_LENGTHS.sample
  
  return VOWELS.sample if length == 1
  
  if length == 2
    i = [0,1,1].sample
    (i..i+1).each do |j|
      if j.even?
        word << (CONSONANTS-["qu"]).sample
      else
        word << VOWELS.sample
      end
    end
    return word
  end

  length.times do |n|
    if n.even?
      word << CONSONANTS.sample
    else
      if word[-2..-1] == "qu"
        word << (VOWELS-["u"]).sample
      else
        word << VOWELS.sample
      end
    end
  end
  word

end

def rand_sentence
  sentence = []
  mid_puncts = ["", ",", ":", ";"]
  mp_weights = [5,2.0,0.5,0.5]
  mp_hash = Hash[mid_puncts.zip mp_weights]
  mp_hash_no_colons = Hash[mid_puncts[0..1].zip mp_weights[0..1]]

  end_puncts = [".","?","!"]
  ep_weights = [5,0.5,1]
  ep_hash = Hash[end_puncts.zip ep_weights]

  length = SENTENCE_LENGTHS.sample
  length.times do |l|
    if rand < 0.25 && l < length - 1
      sentence_includes_either_colon = sentence.join(" ").include?(":") || sentence.join(" ").include?(";")
      if sentence_includes_either_colon
        sentence << rand_word + weights_constructor(mp_hash_no_colons).sample
      else
        sentence << rand_word + weights_constructor(mp_hash).sample
      end
    else
      sentence << rand_word
    end
  end
  sentence = sentence.join(" ")
  sentence << weights_constructor(ep_hash).sample
  sentence.capitalize
end

def rand_paragraph
  paragraph = "    "
  PARAGRAPH_LENGTHS.sample.times { paragraph << rand_sentence + " " }
  paragraph[0...-1]
end

def rand_essay
  essay = ""
  (3..5).to_a.sample.times { essay << rand_paragraph + "\n" }
  essay.chomp
end

def rand_n_words_paper(n)
  paper = ""
  until paper.split(" ").length >= n
    paper << rand_paragraph + "\n"
  end
  paper.chomp
end