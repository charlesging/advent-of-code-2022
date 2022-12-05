require_relative 'part1'

RESULT_MAPPINGS = {
  'X' => 'lose',
  'Y' => 'draw',
  'Z' => 'win'
}

class DecisionMaker
  def self.process(round)
    their_play = Play.new(round[0])
    required_end = RESULT_MAPPINGS[round[1]]
    return round[0] if required_end == 'draw'

    play_code(required_end, their_play)
  end

  def self.play_code(required_end, their_play)
    case required_end
    when 'win'
      play_name = WINNING_LOSING_PLAYS.key(their_play.name)
      PLAY_TRANSLATIONS.key(play_name)
    when 'lose'
      play_name = WINNING_LOSING_PLAYS[their_play.name]
      PLAY_TRANSLATIONS.key(play_name)
    end
  end
end

rounds = InputParser.parse
input_with_decisions_made = rounds.map { |round| [round[0], DecisionMaker.process(round)] }

ScoreCalculator.calculate(input_with_decisions_made) # => 13600