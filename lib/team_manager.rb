require_relative './team'
require_relative './game_manager'
require_relative './game'

class TeamManager
  include Mathable
  attr_reader :teams

  def initialize(locations)
    @teams = Team.read_file(locations[:teams])
    @games = Game.read_file(locations[:games])
    @game_manager = GameManager.new(locations)
    @game_team_manager = GameTeamManager.new(locations)
  end

  def team_by_id(id)
    @teams.find do |team|
       team.team_id == id
     end
  end

  def team_info(id)
    team = team_by_id(id)
    {
      "team_id" => id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end

  def team_name(id)
    team_by_id(id).team_name
  end

  def count_teams
    @teams.count
  end

  def games_by_season_by_team(id)
    @game_manager.games_by_team_id(id).group_by do |game|
      game.season
    end
  end

  def best_season(id)
    games_by_season_by_team(id).max_by do |season, season_games|
      win_percentage(id, season_games)
    end.flatten[0]
  end

  def worst_season(id)
    games_by_season_by_team(id).min_by do |season, season_games|
      win_percentage(id, season_games)
    end.flatten[0]
  end

  def winning_team(id, game)
    game.home_team_id == id && game.home_goals > game.away_goals || game.away_team_id == id && game.away_goals > game.home_goals
  end

  def win_percentage(id, games)
    total_wins = games.count do |game|
    winning_team(id, game)
    end
    compute_average(total_wins.to_f,games.count).round(2)
  end

  def average_win_percentage(id)
    win_percentage(id, @game_manager.games_by_team_id(id))
  end

  def all_score_counts_by_team(id)
    @game_manager.games_by_team_id(id).filter_map do |game|
      (game.home_goals if game.home_team_id == id) || (game.away_goals if game.away_team_id == id)
    end.uniq
  end

  def most_goals_scored(id)
    all_score_counts_by_team(id).max.to_i
  end

  def fewest_goals_scored(id)
    all_score_counts_by_team(id).min.to_i
  end

  def games_against_opponents(id)
    @game_manager.games_by_team_id(id).group_by do |game|
      if game.home_team_id == id
        game.away_team_id
      elsif game.away_team_id == id
        game.home_team_id
      end
    end
  end

  def favorite_opponent(id)
    opponent = games_against_opponents(id).max_by do |opponent_id, games|
      win_percentage(id, games)
    end.flatten[0]
    team_var = @teams.find do |team|
      team.team_id == opponent
    end
    team_var.team_name
  end

  def rival_opponent(id)
    opponent = games_against_opponents(id).min_by do |opponent_id, games|
      win_percentage(id, games)
    end.flatten[0]
    team_var = @teams.find do |team|
      team.team_id == opponent
    end
    team_var.team_name
  end
end
