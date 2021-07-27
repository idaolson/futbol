require_relative './lib/game'
require_relative './data/games_sample'

RSpec.describe Game do
  context "it's a futbol game" do
    game = Game.new({
      game_id: "2012030314",
      season: "20122013",
      type: "Postseason",
      date_time: "6/8/13",
      away_team_id: "5",
      home_team_id: "6",
      away_goals: "0",
      home_goals: "1"
    })

    it "exists" do
      expect(game).to be_a(Game)
    end

    it "has attributes" do
      expect(game.game_id).to eq("2012030314")
    end

    it "calculates total game score" do
      expect(game.total_game_score).to eq(1)
    end
  end
end
