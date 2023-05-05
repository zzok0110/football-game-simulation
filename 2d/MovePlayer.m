function [updatedPlayer] = MovePlayer(players, indexOfPlayer, ball, timeDelta, playerOriginalPosition)
% The function MovePlayer is used to update the position and velocity of a
% given player based on the position of the ball and the player's team
% configuration.

% Get the number of players in the team
nPlayers=length(players{1});

% Get the team of the player
playerTeam=players{3}(indexOfPlayer);

% Set the distance at which the player takes action on the ball
actionPlayerDistance = 10; % 12-15

% Initialize some variables
flag = 1;
global speedPlayer;

% Set the speeds for the different actions
normalspeed = 0.3;
highspeed = 0.6;
jumpspeed = 4.5;

% Get the current position and velocity of the player
playerPosition = players{1}(indexOfPlayer,:);
playerVelocity = players{2}(indexOfPlayer,:);

% Get the positions of all the players in the team
playerPositions = players{1}(playerTeam*nPlayers/2+(1:nPlayers/2),:);

% Get the position of the ball and calculate the distance to the ball
ballPosition = ball(1,:);
distanceToBall = norm(ballPosition-playerPosition);

% Calculate the distance to the ball for all the players in the team and get
% the index of the player that will go for the ball
distanceToBallForAllTeamMates = vecnorm((ballPosition-playerPositions)');
[~,indexOfPlayerThatWillGoForTheBall]=min(distanceToBallForAllTeamMates);

% Calculate the distance to the original position of the player
distanceToOriginalPosition = norm(playerOriginalPosition(indexOfPlayer,:)-playerPosition);

% Set the view direction of the player to always focus on the ball
playerViewDirection = atan2(ballPosition(2) - playerPosition(2), ballPosition(1) - playerPosition(1));

% Handle goalie behavior
if indexOfPlayer==4 || indexOfPlayer==8 %goalie
    % If the goalie is not at the goal, move towards the original position
    if abs(playerPosition(1)) < 25 || abs(playerPosition(2)) > 25
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        speed = normalspeed;
    else
        % If the ball is close to the goalie or the player is the one that
        % will go for the ball, move towards the ball
        if (distanceToBall<actionPlayerDistance && distanceToOriginalPosition < actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2), ballPosition(1) - playerPosition(1));
            speed = normalspeed;
        else
            % If the player is far from the ball, move towards the original
            % position
            if abs(playerPosition(2)) <= 13
                playerDirection = atan2(ballPosition(2) - playerPosition(2), playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
            else
                playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2), playerOriginalPosition(indexOfPlayer,1)- playerPosition(1));
                % If the player has reached the original position, stop
                if distanceToOriginalPosition < 1
                    flag = 0.0;
                end
            end
            speed = normalspeed;
        end
    end
    
    if abs(ballPosition(1)) > 30 && abs(ballPosition(2)) < 14
        speed = highspeed;
    end
    if abs(ballPosition(1)) > 40 && abs(ballPosition(2)) < 14
        speed = jumpspeed;
    end
else %players (not goalie)
    if (distanceToBall<actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2), ballPosition(1) - playerPosition(1));
        if playerPosition(2) < -16 || playerPosition(2) > 16
            speed = highspeed;
            speedPlayer = indexOfPlayer;
        else
            speed = normalspeed;
        end
    else
        if indexOfPlayer == 1 %defenser cut the goal line
            playerDirection = atan2(ballPosition(2)/2- playerPosition(2), (ballPosition(1)-45)/2- playerPosition(1));
            if playerPosition(2) < -16 || playerPosition(2) > 16
                speed = highspeed;
                speedPlayer = indexOfPlayer;
            else
                speed = normalspeed;
            end
        end
        if indexOfPlayer == 2 %assist on one side
            if ballPosition(1) < -26.25 %go for assisting defense
                playerDirection = atan2(ballPosition(2) - playerPosition(2), ballPosition(1) - playerPosition(1));
                if playerPosition(2) < -16 || playerPosition(2) > 16
                    speed = highspeed;
                    speedPlayer = indexOfPlayer;
                else
                    speed = normalspeed;
                end
            else
                if ballPosition(2) < 0
                    playerDirection = atan2((ballPosition(2)+23)- playerPosition(2),ballPosition(1)- playerPosition(1));
                    if playerPosition(2) < -16 || playerPosition(2) > 16
                        speed = highspeed;
                        speedPlayer = indexOfPlayer;
                    else
                        speed = normalspeed;
                    end
                else
                    playerDirection = atan2((ballPosition(2)-23)- playerPosition(2),ballPosition(1)- playerPosition(1));
                    if playerPosition(2) < -16 || playerPosition(2) > 16
                        speed = highspeed;
                        speedPlayer = indexOfPlayer;
                    else
                        speed = normalspeed;
                    end
                end
            end
        end







        if indexOfPlayer == 3 %attack forward
            if ballPosition(2) < 0
                playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) -10 - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) + 15- playerPosition(1));
                if playerPosition(2) < -16 || playerPosition(2) > 16
                    speed = highspeed;
                    speedPlayer = indexOfPlayer;
                else
                    speed = normalspeed;
                end
            else
                playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) +10 - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) + 15- playerPosition(1));
                if playerPosition(2) < -16 || playerPosition(2) > 16
                    speed = highspeed;
                    speedPlayer = indexOfPlayer;
                else
                    speed = normalspeed;
                end
            end
        end
        if indexOfPlayer == 5 %defenser cut the goal line
            playerDirection = atan2(ballPosition(2)/2- playerPosition(2),(ballPosition(1)+45)/2- playerPosition(1));
            if playerPosition(2) < -16 || playerPosition(2) > 16
                speed = highspeed;
                speedPlayer = indexOfPlayer;
            else
                speed = normalspeed;
            end
        end
        if indexOfPlayer == 6 %assist on one side
            if ballPosition(1) > 26.25 %go for assisting defense
                playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
                if playerPosition(2) < -16 || playerPosition(2) > 16
                    speed = highspeed;
                    speedPlayer = indexOfPlayer;
                else
                    speed = normalspeed;
                end
            else
                if ballPosition(2) < 0
                    playerDirection = atan2((ballPosition(2)+23)- playerPosition(2),ballPosition(1)- playerPosition(1));
                    if playerPosition(2) < -16 || playerPosition(2) > 16
                        speed = highspeed;
                        speedPlayer = indexOfPlayer;
                    else
                        speed = normalspeed;
                    end
                else
                    playerDirection = atan2((ballPosition(2)-23)- playerPosition(2),ballPosition(1)- playerPosition(1));
                    if playerPosition(2) < -16 || playerPosition(2) > 16
                        speed = highspeed;
                        speedPlayer = indexOfPlayer;
                    else
                        speed = normalspeed;
                    end
                end
            end
        end

        if indexOfPlayer == 7 %attack forward
            if ballPosition(2) < 0
                playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) -10 - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - 15- playerPosition(1));
                if playerPosition(2) < -16 || playerPosition(2) > 16
                    speed = highspeed;
                    speedPlayer = indexOfPlayer;
                else
                    speed = normalspeed;
                end
            else
                playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) +10 - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - 15- playerPosition(1));
                if playerPosition(2) < -16 || playerPosition(2) > 16
                    speed = highspeed;
                    speedPlayer = indexOfPlayer;
                else
                    speed = normalspeed;
                end
            end
        end

        if distanceToOriginalPosition < 1
            flag = 0.1;
        end
    end
end

player{1}(indexOfPlayer,1) = playerPosition(1) + cos(playerDirection) * playerVelocity(1) * timeDelta * flag;
player{1}(indexOfPlayer,2) = playerPosition(2) + sin(playerDirection) * playerVelocity(1) * timeDelta * flag;
player{2}(indexOfPlayer,1) = speed;
player{2}(indexOfPlayer,2) = playerViewDirection;
player{3} = players{3}(indexOfPlayer,:);

updatedPlayer = player;

end

