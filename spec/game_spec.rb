require './lib/game'

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

    game2 = Game.new({
      game_id: "2012020251",
      season: "20122013",
      type: "Regular Season",
      date_time: "2/23/13",
      away_team_id: "52",
      home_team_id: "4",
      away_goals: "3",
      home_goals: "3"
    })

    it "exists" do
      expect(game).to be_a(Game)
    end

    it "has attributes" do
      expect(game.game_id).to eq("2012030314")
    end
  end
end
