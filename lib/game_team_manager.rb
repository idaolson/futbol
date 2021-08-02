require_relative './game_team'

class GameTeamManager
  attr_reader :game_teams

  def initialize(locations)
    @game_teams = GameTeam.read_file(locations[:game_teams])
  end

  def by_game_id(game_id)
    @game_teams.filter do |game_team|
      game_team.game_id == game_id
    end
  end

  def by_team_id(team_id)
    @game_teams.filter do |game_team|
      game_team.team_id == team_id
    end
  end

  def coaches(season_game_ids)
    season_game_ids.flat_map do |game_id|
      game_team_pair = by_game_id(game_id)
      game_team_pair.map do |game_team|
        game_team.head_coach
      end
    end
  end

  def coach_wins(season_game_ids)
    coach_results = {}
    coaches(season_game_ids).uniq.each do |coach|
      coach_results[coach] = winning_coaches(season_game_ids).count(coach)
    end
    coach_results
  end

  def winning_coach(game_id)
    winner = by_game_id(game_id).find do |game_team|
        game_team.result == "WIN"
      end
    winner.head_coach
  end

  def winning_coaches(season_game_ids)
    season_game_ids.map do |game|
      winning_coach(game)
    end
  end

  def winningest_coach(season_game_ids)
    winningest = coach_wins(season_game_ids).max_by do |coach, wins|
      wins.to_f / coaches(season_game_ids).count(coach) * 100
    end # returns array [coach_name, win_count]
    winningest[0] #coach name will be index 0
  end

  def worst_coach(season_game_ids)
    worst = coach_wins(season_game_ids).min_by do |coach, wins|
      wins.to_f / coaches(season_game_ids).count(coach) * 100
    end
    worst[0]
  end

  def total_shots(team_id)
    by_team_id(team_id).sum do |game_team|
      game_team.shots.to_i
    end
  end

  def total_goals(team_id)
    by_team_id(team_id).sum do |game_team|
      game_team.goals.to_i
    end
  end

  def team_accuracy(season_team_ids)
    accuracy = {}
    season_team_ids.each do |team_id|
      accuracy[team_id] = (total_shots(team_id).to_f / total_goals(team_id)).round(2)
    end
    accuracy
  end

  def most_accurate_team(season_team_ids)
    most_accurate = team_accuracy(season_team_ids).min_by do |team_id, s_to_g|
      s_to_g
    end
    most_accurate[0]
  end

  def least_accurate_team(season_team_ids)
    least_accurate = team_accuracy(season_team_ids).max_by do |team_id, s_to_g|
      s_to_g
    end
    least_accurate[0]
  end

  def team_tackles(team_id)
    by_team_id(team_id).sum do |game_team|
      game_team.tackles.to_i
    end
  end

  def most_tackles(season_team_ids)
    season_team_ids.max_by do |team_id|
      team_tackles(team_id)
    end
  end

  def fewest_tackles(season_team_ids)
    season_team_ids.min_by do |team_id|
      team_tackles(team_id)
    end
  end

  def goals_by_team
    sorted_goals = {}
    @game_teams.reduce({}) do |goals_hash, game_team|
      sorted_goals[game_team.team_id] ||= []
      sorted_goals[game_team.team_id] << game_team.goals.to_i
      sorted_goals
    end
  end

  def average_goals
    goals_by_team.reduce({}) do |average, (team, sorted_goals)|
      average[team] = (sorted_goals.sum / sorted_goals.count.to_f).truncate(2)
      average
    end
  end

  def best_average_score_team
    average_goals.max_by { |team, average| average }.first
  end

  def worst_average_score_team
    average_goals.min_by { |team, average| average }.first
  end

  def goals_by_team_home
    sorted_goals_home = {}
    @game_teams.reduce({}) do |goals_hash, game_team|
      if game_team.hoa == "home"
        sorted_goals_home[game_team.team_id] ||= []
        sorted_goals_home[game_team.team_id] << game_team.goals.to_i
      end
      sorted_goals_home
    end
  end

  def average_goals_home
    goals_by_team_home.reduce({}) do |average, (team, sorted_goals)|
      average[team] = (sorted_goals.sum / sorted_goals.count.to_f).truncate(2)
      average
    end
  end

  def best_average_score_team_home
    average_goals_home.max_by { |team, average| average }.first
  end

  def worst_average_score_team_home
    average_goals_home.min_by { |team, average| average }.first
  end

  def goals_by_team_away
    sorted_goals_away = {}
    @game_teams.reduce({}) do |goals_hash, game_team|
      if game_team.hoa == "away"
        sorted_goals_away[game_team.team_id] ||= []
        sorted_goals_away[game_team.team_id] << game_team.goals.to_i
      end
      sorted_goals_away
    end
  end

  def average_goals_away
    goals_by_team_away.reduce({}) do |average, (team, sorted_goals)|
      average[team] = (sorted_goals.sum / sorted_goals.count.to_f).truncate(2)
      average
    end
  end

  def best_average_score_team_away
    average_goals_away.max_by { |team, average| average }.first
  end

  def worst_average_score_team_away
    average_goals_away.min_by { |team, average| average }.first
  end
end



# def by_team_and_game_id(team_id, game_id)
#   @game_teams.find do |game_team|
#     game_team.game_id == game_id && game_team.team_id == team_id
#   end
# end
