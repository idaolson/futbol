 require 'spec_helper'

RSpec.describe GameManager do
  before(:each) do
    game_path = './data/games_sample.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams_sample.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @game_manager = GameManager.new(locations)
  end

  it "exists" do
    expect(@game_manager).to be_a(GameManager)
  end

  it "is an array" do
    expect(@game_manager.games).to be_an(Array)
  end

  it "adds team scores together for total score" do
    result = [5, 5, 3, 5, 4, 3, 5, 3, 1, 3, 3, 4, 2, 3, 5, 3, 4, 4, 5, 5, 5, 3, 5, 5, 3, 4, 3, 3, 1, 5, 5, 3, 4, 5, 2, 5, 5, 5, 5, 3, 5, 5, 6, 2, 5, 4, 1, 5, 5, 3]
    expect(@game_manager.total_game_score).to eq(result)
  end

  it "finds the higest total score" do
    expect(@game_manager.highest_total_score).to eq(6)
  end

  it "finds the lowest total score" do
    expect(@game_manager.lowest_total_score).to eq(1)
  end

  it 'counts total games' do
    expect(@game_manager.total_games).to eq(50)
  end

  it 'has home wins count' do
    expect(@game_manager.home_wins_count).to eq(33)
  end

  it 'has home win percents' do
    expect(@game_manager.percentage_home_wins).to eq(0.66)
  end

  it 'has visitor wins count' do
    expect(@game_manager.visitor_wins_count).to eq(16)
  end

  it 'has visitor win percents' do
    expect(@game_manager.percentage_visitor_wins).to eq(0.32)
  end

  it 'has a tie count' do
    expect(@game_manager.tie_count).to eq(1)
  end

  it 'has tie percent' do
    expect(@game_manager.percent_ties).to eq(0.02)
  end

  it 'has games sorted by season' do
    expect(@game_manager.games_by_season).to be_a(Hash)
    hash_keys = @game_manager.games_by_season.keys
    expect(hash_keys.count).to eq(1)
    expect(@game_manager.games_by_season.values.flatten[0]).to be_a(Game)
  end

  it 'can return a single game by id' do
    expect(@game_manager.game_by_id('2012030221')).to be_a(Game)
  end

  it "can return games based on team id" do
    expect(@game_manager.games_by_team_id("3").count).to eq(10)
  end
end

# xit "is an array of season numbers" do
#   result = ["20122013", "20152016", "20132014", "20142015", "20172018", "20162017"]
#   expect(@game_manager.array_of_seasons).to eq(result)
# end
