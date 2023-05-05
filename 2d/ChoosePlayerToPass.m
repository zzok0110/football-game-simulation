function targetPosition = ChoosePlayerToPass(players,indexOfPlayer,markedDistance)

minPassLength=5;

% Initialize variables
isMarked=true;
nPlayers=length(players{1});
playerTeam=players{3}(indexOfPlayer);

% Set initial target position to be next to the current player
targetPosition=[players{1}(indexOfPlayer,1)+sign(1/2-playerTeam) players{1}(indexOfPlayer,2)];

% Calculate distances between all players
d = pdist(players{1});
z = squareform(d);

% Depending on the team of the current player, determine the distances to their teammates and opponents
if playerTeam==0
    distanceToTeamMates = z(indexOfPlayer,1:nPlayers/2);
    distanceToOpponents = z(indexOfPlayer,nPlayers/2+1:nPlayers);
elseif playerTeam==1
    distanceToTeamMates = z(indexOfPlayer,nPlayers/2+1:nPlayers);
    distanceToOpponents = z(indexOfPlayer,1:nPlayers/2);
end

% Do not consider passing to the goalie
distanceToTeamMates(nPlayers/2)=NaN;

% Do not consider passing if the distance is less than the minimum pass length
distanceToTeamMates(distanceToTeamMates < minPassLength) = NaN;

% Loop until a player is found that is not marked by an opponent or there are no available players to pass to
while isMarked==true
    % Find the closest teammate
    [~,indexOfTarget] = min(distanceToTeamMates);
    
    % Check if the closest teammate is marked by an opponent
    isMarked = IsMarked(players,indexOfTarget,playerTeam,markedDistance);
    
    % If the closest teammate is not marked, set the target position and return
    if ~isMarked
        targetPosition=players{1}(indexOfTarget+playerTeam*nPlayers/2,:);
        return;
    % If there are no available players to pass to, return
    elseif sum(isnan(distanceToTeamMates))==nPlayers/2
        return; %no player to pass
    % If the closest teammate is marked, remove them from the list and try again
    else
        distanceToTeamMates(indexOfTarget)=NaN;
    end
end

% Check if a player is marked by an opponent
function isMarked = IsMarked(players,indexOfTarget,playerTeam,markedDistance)
    isMarked=true;
    nPlayers=length(players{1});
    d = pdist(players{1});
    z = squareform(d);
    z(indexOfTarget,indexOfTarget)=inf;
    
    % Check if the closest opponent to the player is within the marked distance
    if min(z(indexOfTarget,(1-playerTeam)*nPlayers/2+(1:nPlayers/2))) > markedDistance
        isMarked=false;
    end
end

end





