require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10).join
  end

  def valid?(words, letters)
    # this method should take two parameters and return true or false
    # .chars splits the word into letters and all returns true or false
    # after checking each of the letters' counts
    words.chars.all? do |letter|
      words.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    # open, then parse to JSON
    # then can access JSON keys (strings)
    json = JSON.parse(response.read)
    json['found']
    # this method checks the word entered, checks the found key of the JSON and
    # returns true or false
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split("")
    @english_word = english_word?(@word)
    if valid?(@word, @letters) == true && @english_word == false
      @result = "Sorry, but #{@word} does not seem to be a
      valid English word..."
    elsif valid?(@word, @letters) && @english_word == true
      @result = "Congratulations! #{@word} is a valid English word!"
    else
      @result = "Sorry, but #{@word} can't be built out of #{@letters}"
    end
  end
end
