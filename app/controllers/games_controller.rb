require "JSON"
require "open-uri"

class GamesController < ApplicationController

  def newGame
    alphabet = ('a'..'z').to_a
    length = 10
    @letters = alphabet.sample(length)
  end

  def isEnglishWord?(word)
    api_url = "https://dictionary.lewagon.com/autocomplete/#{word}"
    answer = URI.parse(api_url).read
    answer_json = JSON.parse(answer)
    words = answer_json["words"]
    return words.include?(word)
  end

  def useUnauthorizedLetters?(word)
    # word is params[:word]
    letters = params[:letters]
    user_letters = word.chars
    check_letters = []
    user_letters.each do |letter|
      check_letter = letters.include?(letter)
      check_letters << check_letter
    end
    # s'il y a un false, ça veut dire qu'il a utilisé une lettre hors scope
    check_letters.include?(false)
  end

  def score
    params
    if (useUnauthorizedLetters?(params[:word]))
      return @message = "Please use the letters we gave you 💥 #{params[:letters]}"
    elsif (isEnglishWord?(params[:word]))
      return @message = "Congrats ! #{params[:word]} is an english word ✅"
    else
      return @message = "#{params[:word]} is not an english word ❌"
    end
    raise
  end
end
