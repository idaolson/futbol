require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative './game_manager'
require_relative './game_team_manager'
require_relative './season_manager'
require_relative './team_manager'
require 'csv'

class StatTracker
  attr_reader :game_manager, :team_manager, :game_team_manager, :season_manager

  def initialize(locations)
    @game_manager = GameManager.new(locations)
    @team_manager = TeamManager.new(locations)
    @game_team_manager = GameTeamManager.new(locations)
    @season_manager = SeasonManager.new(@game_manager.games_by_season)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  #game stats
  def highest_total_score
    @game_manager.highest_total_score
  end

  def lowest_total_score
    @game_manager.lowest_total_score
  end

  def percentage_home_wins
    @game_manager.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_manager.percentage_visitor_wins
  end

  def percentage_ties
    @game_manager.percent_ties
  end

  def count_of_games_by_season
    @game_manager.count_of_games_by_season
  end

  def average_goals_per_game
    @game_manager.average_goals_per_game
  end

  def average_goals_by_season
    @game_manager.average_goals_by_season
  end

  # Season methods
  def season_games(season)
    @season_manager.game_id_by_season(season)
  end

  def winningest_coach(season)
    @game_team_manager.winningest_coach(season_games(season))
  end

  def worst_coach(season)
    @game_team_manager.worst_coach(season_games(season))
  end

  def most_accurate_team(season)
    team_id = @game_team_manager.most_accurate_team(season_games(season))
    @team_manager.team_name(team_id)
  end

  def least_accurate_team(season)
    team_id = @game_team_manager.least_accurate_team(season_games(season))
    @team_manager.team_name(team_id)
  end

  def most_tackles(season)
    team_id = @game_team_manager.most_tackles(season_games(season))
    @team_manager.team_name(team_id)
  end

  def fewest_tackles(season)
    team_id = @game_team_manager.fewest_tackles(season_games(season))
    @team_manager.team_name(team_id)
  end

  # LEAGUES METHODS
  def count_of_teams
    @team_manager.count_teams
  end

  def best_offense
    @team_manager.team_name(@game_team_manager.best_average_score_team)
  end

  def worst_offense
    @team_manager.team_name(@game_team_manager.worst_average_score_team)
  end

  def highest_scoring_visitor
    @team_manager.team_name(@game_team_manager.best_average_score_team_away)
  end

  def highest_scoring_home_team
    @team_manager.team_name(@game_team_manager.best_average_score_team_home)
  end

  def lowest_scoring_visitor
    @team_manager.team_name(@game_team_manager.worst_average_score_team_away)
  end

  def lowest_scoring_home_team
    @team_manager.team_name(@game_team_manager.worst_average_score_team_home)
  end

  # Team stats
  def team_info(team_id)
    @team_manager.team_info(team_id)
  end

  def best_season(team_id)
    @team_manager.best_season(team_id)
  end

  def worst_season(team_id)
    @team_manager.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @team_manager.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @team_manager.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @team_manager.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @team_manager.favorite_opponent(team_id)
  end

  def rival(team_id)
    @team_manager.rival_opponent(team_id)
  end
end
