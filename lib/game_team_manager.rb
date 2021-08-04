require_relative './game_team'
require_relative './mathable'

class GameTeamManager
  include Mathable

  attr_reader :game_teams

  def initialize(locations)
    @game_teams = GameTeam.read_file(locations[:game_teams])
  end

  def by_game_id(game_id)
    @game_teams.filter do |game_team|
      game_team.game_id == game_id
    end
  end

  def coaches(game_ids)
    game_ids.flat_map do |game_id|
      by_game_id(game_id).flat_map do |game_team|
        game_team.head_coach
      end
    end.uniq
  end

  def by_coach(game_ids, coach)
    all = game_ids.flat_map do |game_id|
      by_game_id(game_id)
    end
    filtered = all.filter do |game_team|
      game_team.head_coach == coach
    end
    filtered
  end

  def wins(collection)
    collection.count do |game_team|
      game_team.result == "WIN"
    end
  end

  def total_games(collection)
    collection.count
  end

  def win_percentage(collection)
    percentage(wins(collection).to_f, total_games(collection)).round(2)
  end

  def winningest_coach(game_ids)
    winningest = coaches(game_ids).max_by do |coach|
      win_percentage(by_coach(game_ids, coach))
    end
    winningest
  end

  def worst_coach(game_ids)
    worst_team = coaches(game_ids).min_by do |coach|
      win_percentage(by_coach(game_ids, coach))
    end
    worst_team
  end

  def by_team_id(collection, team_id)
    collection.filter do |game_team|
      game_team.team_id == team_id
    end
  end

  def season_collection(game_ids)
    game_ids.flat_map do |game_id|
      by_game_id(game_id)
    end
  end

  def team_ids(collection)
    collection.map do |game_team|
      game_team.team_id
    end.uniq
  end

  def total_shots(collection)
    collection.sum do |game_team|
      game_team.shots.to_i
    end
  end

  def total_goals(collection)
    collection.sum do |game_team|
      game_team.goals.to_i
    end
  end

  def team_accuracy(collection)
    compute_average(total_shots(collection), total_goals(collection).to_f).round(3)
  end

  def most_accurate_team(season_game_ids)
    collection = season_collection(season_game_ids)
    team_ids = team_ids(collection)
    team_ids.min_by do |team_id|
      team_accuracy(by_team_id(collection, team_id))
    end
  end

  def least_accurate_team(season_game_ids)
    collection = season_collection(season_game_ids)
    team_ids = team_ids(collection)
    team_ids.max_by do |team_id|
      team_accuracy(by_team_id(collection, team_id))
    end
  end

  def team_tackles(collection, team_id)
    by_team_id(collection, team_id).sum do |game_team|
      game_team.tackles.to_i
    end
  end

  def most_tackles(season_game_ids)
    collection = season_collection(season_game_ids)
    team_ids = team_ids(collection)
    team_ids.max_by do |team_id|
      team_tackles(collection, team_id)
    end
  end

  def fewest_tackles(season_game_ids)
    collection = season_collection(season_game_ids)
    team_ids = team_ids(collection)
    team_ids.min_by do |team_id|
      team_tackles(collection, team_id)
    end
  end

  # LEAGUE METHODS

  def goals_by_team
    @game_teams.reduce({}) do |sorted_goals, game_team|
      sorted_goals[game_team.team_id] ||= []
      sorted_goals[game_team.team_id] << game_team.goals.to_i
      sorted_goals
    end
  end

  def average_goals
    goals_by_team.reduce({}) do |average, (team, sorted_goals)|
      average[team] = compute_average(sorted_goals.sum, sorted_goals.count.to_f).truncate(2)
      average
    end
  end

  def best_average_score_team
    average_goals.max_by do |team, average|
      average
    end.first
  end

  def worst_average_score_team
    average_goals.min_by do |team, average|
      average
    end.first
  end

  def goals_by_team_home
    @game_teams.reduce({}) do |sorted_goals_home, game_team|
      if game_team.home?
        sorted_goals_home[game_team.team_id] ||= []
        sorted_goals_home[game_team.team_id] << game_team.goals.to_i
      end
      sorted_goals_home
    end
  end

  def average_goals_home
    goals_by_team_home.reduce({}) do |average, (team, sorted_goals)|
      average[team] = compute_average(sorted_goals.sum, sorted_goals.count.to_f).truncate(2)
      average
    end
  end

  def best_average_score_team_home
    average_goals_home.max_by do |team, average|
      average
    end.first
  end

  def worst_average_score_team_home
    average_goals_home.min_by do |team, average|
      average
    end.first
  end

  def goals_by_team_away
    @game_teams.reduce({}) do |sorted_goals_away, game_team|
      if !game_team.home?
        sorted_goals_away[game_team.team_id] ||= []
        sorted_goals_away[game_team.team_id] << game_team.goals.to_i
      end
      sorted_goals_away
    end
  end

  def average_goals_away
    goals_by_team_away.reduce({}) do |average, (team, sorted_goals)|
      average[team] = compute_average(sorted_goals.sum, sorted_goals.count.to_f).truncate(2)
      average
    end
  end

  def best_average_score_team_away
    average_goals_away.max_by do |team, average|
      average
    end.first
  end

  def worst_average_score_team_away
    average_goals_away.min_by do |team, average|
      average
    end.first
  end
end
