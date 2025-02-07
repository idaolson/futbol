require 'spec_helper'

RSpec.describe TeamManager do
  before(:each) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @team_manager = TeamManager.new(locations)
    @games = Game.read_file(locations[:games])
  end

  it "exists" do
    expect(@team_manager).to be_a(TeamManager)
  end

  it "is an array" do
    expect(@team_manager.teams).to be_an(Array)
  end

  it 'can return a single team by id' do
    expect(@team_manager.team_by_id("1")).to be_a(Team)
  end

  it "can determine team info" do
    expected = {
      "team_id" => "1",
      "franchise_id" => "23",
      "team_name" => "Atlanta United",
      "abbreviation" => "ATL",
      "link" => "/api/v1/teams/1"
    }
    expect(@team_manager.team_info("1")).to eq(expected)
  end

  it "can count number of teams" do
    expect(@team_manager.count_teams).to eq(32)
  end

  it "can determine win percentage" do
    games = @games.find_all do |game|
      game.away_team_id == "16" || game.home_team_id == "16"
    end

    expect(@team_manager.win_percentage("16", games)).to eq(0.44)
  end

  it "can group the games by season by team" do
    expect(@team_manager.games_by_season_by_team("3").keys).to eq(["20122013", "20152016", "20142015", "20132014", "20172018", "20162017"])
    expect(@team_manager.games_by_season_by_team("3").fetch("20122013").count).to eq(60)
  end

  it "can determine best season for a team" do
    expect(@team_manager.best_season("5")).to eq("20122013")
    expect(@team_manager.best_season("16")).to eq("20122013")
  end

  it "can determine the team's worst season" do
    expect(@team_manager.worst_season("3")).to eq("20172018")
    expect(@team_manager.worst_season("6")).to eq("20142015")
  end

  it "can identify the winning team" do
    games = @games.find do |game|
      game.game_id == "2012030224"
    end
    expect(@team_manager.winning_team("6", games)).to eq(true)
    expect(@team_manager.winning_team("3", games)).to eq(false)
  end

  it "can average the win percentage" do
    expect(@team_manager.average_win_percentage("3")).to eq(0.43)
    expect(@team_manager.average_win_percentage("6")).to eq(0.49)
  end

  it 'shows all score counts by team' do
    expect(@team_manager.all_score_counts_by_team("18")).to eq(["2", "3", "1", "0", "5", "4", "7"])
  end

  it 'can have most goals scored' do
    expect(@team_manager.most_goals_scored("18")).to eq(7)
  end

  it 'can have fewest goals' do
    expect(@team_manager.fewest_goals_scored("3")).to eq(0)
    expect(@team_manager.fewest_goals_scored("1")).to eq(0)
  end

  it "determines which id is the opposing team's" do
    expect(@team_manager.games_against_opponents("3")).to be_a(Hash)
    expect(@team_manager.games_against_opponents("3").keys.first).to eq("6")
  end

  it 'has a favorite opponent' do
    expect(@team_manager.favorite_opponent("18")).to eq('DC United')
  end

  it 'has a rival opponent' do
    expect(@team_manager.rival_opponent("18")).to eq("Houston Dash").or(eq("LA Galaxy"))
  end

  it 'returns team name by id' do
    expect(@team_manager.team_name('3')).to eq('Houston Dynamo')
  end
end
