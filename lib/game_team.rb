
class GameTeam
  attr_reader :team_id,
              :game_id,
              :hoa,
              :result,
              :head_coach,
              :goals,
              :shots,
              :tackles

  def initialize(params)
    @game_id = params[:game_id]
    @team_id = params[:team_id]
    @hoa = params[:hoa]
    @result = params[:result]
    @head_coach = params[:head_coach]
    @goals = params[:goals]
    @shots = params[:shots]
    @tackles = params[:tackles]
  end

  def self.read_file(location)
    game_team_rows = CSV.read(location, headers: true, header_converters: :symbol)
    game_team_rows.map do |game_team_row|
      new(game_team_row)
    end
  end

  def home?
    @hoa == "home"
  end
end
