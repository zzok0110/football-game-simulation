% This function takes two formations, the field size, player attributes,
% and the team that has the kickoff, and plots the players on the field.
function [] = FormationPloter(formation1,formation2,fieldSize,attributes,kickoffTeam)

% Calculate the number of players on the field.
nPlayers = sum(formation1)+sum(formation2)+2;

% Initialize the players and their original positions.
[players,playerOriginalPosition] = InitializePlayers(formation1,formation2,fieldSize,attributes,kickoffTeam);

% Set the initial positions of the players.
for iPlayer = 1:nPlayers
    players{1}(iPlayer,:) = playerOriginalPosition(iPlayer,:);
end

% Plot the field and the players.
PlotConField(fieldSize);
PlotPlayers(players);
end


