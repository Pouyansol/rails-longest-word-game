require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(9) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(' ')
    @result = run_game(@word, @letters)
  end

  private

  def run_game(attempt, grid)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    response = URI.open(url).read
    word_data = JSON.parse(response)

    result = { word: attempt }

    if word_in_grid?(attempt, grid) && word_data['found']
      result[:message] = "Congratulations! #{attempt} is a valid English word!"
      result[:score] = word_data['length'] # or any other scoring logic you want
    elsif word_in_grid?(attempt, grid)
      result[:message] = "Sorry but #{attempt} does not seem to be a valid English word..."
      result[:score] = 0
    else
      result[:message] = "Sorry but #{attempt} can't be built out of #{grid.join(', ')}"
      result[:score] = 0
    end

    result
  end

  def word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
end
