# https://adventofcode.com/2022/day/2

PLAY_TRANSLATIONS = {
  'X' => 'rock',
  'A' => 'rock',
  'Y' => 'paper',
  'B' => 'paper',
  'Z' => 'scissors',
  'C' => 'scissors'
}

PLAY_SCORES = {
  'rock' => 1,
  'paper' => 2,
  'scissors' => 3
}

WINNING_LOSING_PLAYS = {
  'rock' => 'scissors',
  'paper' => 'rock',
  'scissors' => 'paper'
}

class InputParser
  def self.parse
    input = File.readlines('./src/input.txt', chomp: true)
    input.map { |round| round.split(' ') }
  end
end

class Play
  include Comparable
  attr_reader :name

  def initialize(abbrev)
    @name = PLAY_TRANSLATIONS[abbrev]
  end

  def <=>(other)
    if WINNING_LOSING_PLAYS[name] == other.name
      1
    elsif WINNING_LOSING_PLAYS[other.name] == name
      -1
    else
      0
    end
  end
end

class ScoreCalculator
  def self.calculate(rounds)
    rounds.reduce(0) { |sum, round| sum + calculate_round_score(round) }
  end

  def self.calculate_round_score(round)
    their_play = Play.new(round[0])
    my_play = Play.new(round[1])
    round_score = 0

    round_score += PLAY_SCORES[my_play.name]
    return round_score if their_play > my_play

    if my_play > their_play
      round_score += 6
    elsif their_play == my_play
      round_score += 3
    end

    round_score
  end
end

rounds = InputParser.parse
ScoreCalculator.calculate(rounds) # => 11386