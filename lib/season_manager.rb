class SeasonManager
  def initialize(hash)
    @seasons = hash 
  end

  def games_in_season(season)
    @seasons[season]
  end

  def game_id_by_season(season)
    games_in_season(season).map do |game|
      game.game_id
    end
  end

  def team_id_by_season(season)
    team_ids = []
    games_in_season(season).each do |game|
      team_ids << game.away_team_id
      team_ids << game.home_team_id
    end
    team_ids.uniq
  end
end
