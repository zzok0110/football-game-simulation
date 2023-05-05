function [updatedPlayer, updatedBall] = UpdatePlayer(players, ball, indexOfPlayer, timeDelta, playerOriginalPosition)
% Global variables
global lastTeamOnBall;
global gameState;
global ballKickedPose;
global goalPlayer;

% Get number of player attributes and number of players
nAttributes = size(players{3},2);
nPlayers=length(players{1});

% Set ball kick constants
kickBallSigma = 1/200;
passBallSigma = 1/200;
shootBallCoefficient = 5;
passBallCoefficient = 0.15;
moveForwardCoefficient = 0.5;
kickBallProbabilityCoefficient=5;
% Set distance constants
markedDistance=12; % 10-15 seems optimal
actionBallDistance = 1.5;
actionPlayerDistance = 27;
actionGoalDistance = 22.5;
actionmyDistance = 15;

% Get player team, goal positions, corner positions
playerTeam=players{3}(indexOfPlayer);
if playerTeam==0
    goalPosition = [+45 0];
    goalPositionmy = [-45 0];
else
    goalPosition = [-45 0];
    goalPositionmy = [+45 0];
end
cornerPosition1 = [0 -30];
cornerPosition2 = [0 30];

% Set likelihood constants
kickBallLikelihood = 0.0;
passBallLikelihood = 0.5;
doNothingWithBallLikelihood = 0.5;

% Ensure likelihoods sum to 1
sumOfLikelihoods = kickBallLikelihood + passBallLikelihood + doNothingWithBallLikelihood;
if sumOfLikelihoods ~= 1
    ME = MException('The sum of the likelyhoods has to equal 1. They are currently summed to %s',sumOfLikelihoods);
    throw(ME)
end

% Get player and ball positions
playerPosition = players{1}(indexOfPlayer,:);
ballPosition = ball(1,:);
distanceToBall = sqrt((ballPosition(1) - playerPosition(1))^2 + (ballPosition(2) - playerPosition(2))^2);
distanceToGoal = sqrt((goalPosition(1) - playerPosition(1)).^2 + (goalPosition(2) - playerPosition(2)).^2);
distanceToMy = sqrt((goalPositionmy(1) - playerPosition(1)).^2 + (goalPositionmy(2) - playerPosition(2)).^2);

% If ball is close, determine action based on likelihoods
if distanceToBall < actionBallDistance
    lastTeamOnBall=playerTeam;
    kickBallLikelihood=exp(-distanceToGoal/kickBallProbabilityCoefficient);

    whatTodo = rand();
    kickLikeRange = kickBallLikelihood;
    passLikeRange = kickBallLikelihood + passBallLikelihood;
    % Kick to goal if in range or close to goal
    if whatTodo <= kickLikeRange || distanceToGoal < actionGoalDistance
        targetPosition = goalPosition;
        ball = KickBall(ball, 1, kickBallSigma, shootBallCoefficient, targetPosition, timeDelta);
        gameState = 1;
        ballKickedPose = ballPosition;
        goalPlayer = indexOfPlayer;
        % Kick to corner if close to own goal
    elseif distanceToMy < actionmyDistance
        if ballPosition(2) < 0
            targetPosition = cornerPosition1;
            ball = KickBall(ball, 1, kickBallSigma, shootBallCoefficient, targetPosition, timeDelta);
        else
            targetPosition = cornerPosition2;
            ball = KickBall(ball, 1, kickBallSigma, shootBallCoefficient, targetPosition, timeDelta);
        end
        gameState = 1;
        % Pass if marked or goalie
    elseif IsMarked(players,indexOfPlayer,playerTeam,markedDistance) || mod(indexOfPlayer,nPlayers/2)==0
        targetPosition = ChoosePlayerToPass(players,indexOfPlayer,markedDistance);
        ball = KickBall(ball, 2, passBallSigma, passBallCoefficient, targetPosition, timeDelta);
        gameState = 2;
        % Dribble forward otherwise
    else
        targetPosition = [goalPosition(1)+sign(playerTeam-1/2) players{1}(indexOfPlayer,2)];
        ball = KickBall(ball, 3, kickBallSigma, moveForwardCoefficient, targetPosition, timeDelta);
        gameState = 3;
    end
end

% Return updated ball and player
updatedBall = ball;
updatedPlayer = MovePlayer(players, indexOfPlayer, updatedBall, timeDelta, playerOriginalPosition);

% Check if player is marked by a defender
    function isMarked = IsMarked(players,indexOfTarget,playerTeam,markedDistance)
        isMarked=true;
        nPlayers=length(players{1});
        d = pdist(players{1});
        z = squareform(d);
        z(indexOfTarget,indexOfTarget)=inf;

        if min(z(indexOfTarget,(1-playerTeam)*nPlayers/2+(1:nPlayers/2))) > markedDistance
            isMarked=false;
        end
    end
end