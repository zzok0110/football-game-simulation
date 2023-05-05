function [players,playerOriginalPosition] = InitializePlayers(formation1,formation2,fieldSize,attributes, substituteMemory, kickoffTeam)
%function initializes the players' positions, velocities, and attributes at the beginning of a game.
% number of players is the sum of the players in each formation plus the two goalies
nPlayers=sum(formation1)+sum(formation2)+2;
epsillon=1/10; % small constant to ensure that players don't start exactly on the boundary
fieldLength=fieldSize(1);
fieldWidth=fieldSize(2);
nAttributes=size(attributes,2);

% initialize players cell array with empty matrices
players = {zeros(nPlayers,2),zeros(nPlayers,2),zeros(nPlayers,nAttributes),substituteMemory}; % {position(x,y)}, {velocity, direction}, {team}, {yellowcard, substitute}
playerOriginalPosition=zeros(nPlayers,2);

% Starting Positions for team 0 (below)

playersLongSide=length(formation1);
xPositions=linspace(-fieldLength/2,0,playersLongSide+2); % divide the field into sections for each player
counter=1;
for i=1:playersLongSide
playersShortSide = formation1(i);
yPositions=linspace(-fieldWidth/2,fieldWidth/2,playersShortSide+2);
for j=1:playersShortSide
players{1}(counter,1)=xPositions(i+1);
players{1}(counter,2)=yPositions(j+1)+epsillon; % set y-position and add a small constant to ensure player is not on the boundary
counter=counter+1;
end
end
players{1}(nPlayers/2,:)=[-43.5 0]; %set the goalie's position
playerOriginalPosition(1,1) = -26.25; % store original positions for each player
playerOriginalPosition(1,2) = -14;
playerOriginalPosition(2,1) = -26.25;
playerOriginalPosition(2,2) = 14;
playerOriginalPosition(3,1) = -5;
playerOriginalPosition(3,2) = 0;
playerOriginalPosition(4,1) = -42;
playerOriginalPosition(4,2) = 0;

% Starting Positions for team 1 (below)

playersLongSide=length(formation2);
xPositions=linspace(fieldLength/2,0,playersLongSide+2);
counter=nPlayers/2+1;
for i=1:playersLongSide
playersShortSide = formation2(i);
yPositions=linspace(-fieldWidth/2,fieldWidth/2,playersShortSide+2);
for j=1:playersShortSide
players{1}(counter,1)=xPositions(i+1);
players{1}(counter,2)=yPositions(j+1); % set y-position
counter=counter+1;
end
end
players{1}(nPlayers,:)=[43.5 0]; % set the goalie's position
playerOriginalPosition(5,1) = 26.25; % store original positions for each player
playerOriginalPosition(5,2) = -14;
playerOriginalPosition(6,1) = 26.25;
playerOriginalPosition(6,2) = 14;
playerOriginalPosition(7,1) = 5;
playerOriginalPosition(7,2) = 0;
playerOriginalPosition(8,1) = 42;
playerOriginalPosition(8,2) = 0;
players{1}(nPlayers/2+1:nPlayers,2)=players{1}(nPlayers/2+1:nPlayers,2)+epsillon;
if kickoffTeam==0
    players{1}(nPlayers/2-1,:)=[-2 0]; %striker has index 10
elseif kickoffTeam==1
    players{1}(nPlayers-1,:)=[2 0];
end

%Fixing angles, velocities=1 in the begining
players{2}(nPlayers/2+1:end,2)=pi;
players{2}(:,1)=0.5;

%attributes
players{3}=attributes;
        

end

