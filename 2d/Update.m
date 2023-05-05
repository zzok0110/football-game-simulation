function [updatedPlayers, updatedBall] = Update(players, ball, timeSync, timeDelta, playerOriginalPosition, frictionCoefficient)
%This function updates the state of all the players and the ball
% acceleration of the ball
acceleration = 0.1;

% number of attributes for each player
nAttributes = size(players{3},2);

% number of players
nPlayers = size(players{1},1);

% initialize updatedPlayers cell array
updatedPlayers = {zeros(nPlayers,2), zeros(nPlayers,2), zeros(nPlayers,nAttributes), zeros(nPlayers,2)};

% iterate through each player
for indexOfPlayer = 1:nPlayers
    % update the state of the player and the ball
    [updatedPlayer, updatedBall] = UpdatePlayer(players, ball, indexOfPlayer, timeDelta, playerOriginalPosition);

    % update the positions of the player
    updatedPlayers{1}(indexOfPlayer,:) = updatedPlayer{1}(indexOfPlayer,:);
    updatedPlayers{2}(indexOfPlayer,:) = updatedPlayer{2}(indexOfPlayer,:);

    % update the attributes of the player
    updatedPlayers{3}(indexOfPlayer,:) = updatedPlayer{3};

    % keep track of the original position of the player
    updatedPlayers{4}(indexOfPlayer,:) = players{4}(indexOfPlayer,:);

    % update the ball position
    ball = updatedBall;
end

% update the ball position
updatedBall = UpdateBallPosition(ball, timeDelta, frictionCoefficient);

% pause for time synchronization
pause(timeSync);

end