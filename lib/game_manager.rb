require_relative './game'
require_relative './mathable'

class GameManager
  include Mathable

  attr_reader :games,
              :season_hash
              :id_hash

  def initialize(locations)
    @games = Game.read_file(locations[:games])
    @season_hash = {}
    @id_hash = {}
  end

  def games_by_team_id(id)
    @games.find_all do |game|
      game.away_team_id == id || game.home_team_id == id
    end
  end

  def total_game_score
    @games.map do |game|
      add(game.away_goals.to_i, game.home_goals.to_i)
    end
  end

  def highest_total_score
    total_game_score.max_by do |score|
      score
    end
  end

  def lowest_total_score
    total_game_score.min_by do |score|
      score
    end
  end

  def total_games
    @games.count
  end

  def home_wins_count
    @games.count do |game|
      game.home_goals > game.away_goals
    end
  end

  def percentage_home_wins
    compute_average(home_wins_count.to_f, total_games).round(2)
  end

  def visitor_wins_count
    @games.count do |game|
      game.away_goals > game.home_goals
    end
  end

  def percentage_visitor_wins
    compute_average(visitor_wins_count.to_f, total_games).round(2)
  end

  def tie_count
    subtract(total_games, add(home_wins_count, visitor_wins_count))
  end

  def percent_ties
    compute_average(tie_count.to_f, total_games).round(2)
  end

  def game_by_id(id)
    @games.find do |game|
      game.game_id == id
    end
  end

  def count_of_games_by_season
    game_count = {}
    games_by_season.each do |season, games|
      game_count[season] = games.count
    end
    game_count
  end

  def games_by_season
    @games.group_by do |game|
      game.season
    end
  end


  def average_goals_per_game
    total_game_score.sum.fdiv(@games.count).round(2)
  end

  def average_goals_by_season
    goals_by_season = {}
    games_by_season.map do |season, games|
      sum_of_goals = games.sum do |game|
        add(game.away_goals.to_f, game.home_goals.to_f)
        end
      goals_by_season[season] = sum_of_goals.fdiv(games.count).round(2)
    end
    goals_by_season
  end
end
