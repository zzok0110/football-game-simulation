function [] = PlotPlayers(players,radie)
% The function takes in two arguments: 
% 1) players: a cell array containing the positions, direction, team and substitution status of each player.
% 2) radie: the radius of the circle to be drawn around each player to indicate their position on the field.

pos = players{1}; % Extract the positions of all players
enPlayers = size(players{1},1)/2; % Calculate the number of players on each team (assuming equal number of players on each team)
direct = players{2}(:,2); % Extract the direction in which each player is facing
sensorLength = 11; % Define the length of the sensor of each player
viewLength = 5.5; % Define the length of the line to be drawn to indicate the view range of each player
viewRange = pi/3.75; % Define the range of the view angle of each player

hold on % Start a new plot and hold the current one

team = players{3}; % Extract the team each player belongs to
team1 = find(team == 0); % Find the indices of all players belonging to team 1
team2 = find(team == 1); % Find the indices of all players belonging to team 2

% Loop through all players in team 1
for i = 1:length(team1)
    % Draw a circle around the player to indicate their position
    plotpos = [pos(team1(i),1)-radie pos(team1(i),2)-radie 2*radie 2*radie];
    rectangle('Position',plotpos,'Curvature',[1 1],'FaceColor','#CD212A',...
        'EdgeColor','none');
    % Draw a line to indicate the direction in which the player is facing
    line([pos(team1(i),1),pos(team1(i),1)+viewLength*cos(direct(i))],[pos(team1(i),2),pos(team1(i),2)+viewLength*sin(direct(i))],'Color','w','linestyle','--');
    % Draw lines to indicate the view range of the player
    line([pos(team1(i),1),pos(team1(i),1)+sensorLength*cos(direct(i)+viewRange)],[pos(team1(i),2),pos(team1(i),2)+sensorLength*sin(direct(i)+viewRange)],'Color','y','linestyle','--','linewidth',1.2);
    line([pos(team1(i),1),pos(team1(i),1)+sensorLength*cos(direct(i)-viewRange)],[pos(team1(i),2),pos(team1(i),2)+sensorLength*sin(direct(i)-viewRange)],'Color','y','linestyle','--','linewidth',1.2);
    % Show the index of the player below their position
    showIdx = i + players{4}(i,2)*enPlayers*2; % If the player had been subsitituted, the idx is different
    text(pos(team1(i),1), pos(team1(i),2)-2*radie, int2str(showIdx),'HorizontalAlignment','center');
    % Hold the plot to add more elements
    hold on
end

% Loop through all players in team 2
for i = 1:length(team2)
    % Draw a circle around the player to indicate their position
    plotpos = [pos(team2(i),1)-radie pos(team2(i),2)-radie 2*radie 2*radie];
    rectangle('Position',plotpos,'Curvature',[1 1],'FaceColor','#0070C9',...
        'EdgeColor','none');
    line([pos(team2(i),1),pos(team2(i),1)+viewLength*cos(direct(i+4))],[pos(team2(i),2),pos(team2(i),2)+viewLength*sin(direct(i+4))],'Color','w','linestyle','--');
    line([pos(team2(i),1),pos(team2(i),1)+sensorLength*cos(direct(i+4)+viewRange)],[pos(team2(i),2),pos(team2(i),2)+sensorLength*sin(direct(i+4)+viewRange)],'Color','y','linestyle','--','linewidth',1.2);
    line([pos(team2(i),1),pos(team2(i),1)+sensorLength*cos(direct(i+4)-viewRange)],[pos(team2(i),2),pos(team2(i),2)+sensorLength*sin(direct(i+4)-viewRange)],'Color','y','linestyle','--','linewidth',1.2);
    showIdx = i + enPlayers + players{4}(i+enPlayers,2)*enPlayers*2; % If the player had been subsitituted, the idx is different
    text(pos(team2(i),1), pos(team2(i),2)-2*radie, int2str(showIdx),'HorizontalAlignment','center');
    hold on
end
end