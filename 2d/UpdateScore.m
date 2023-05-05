function [goalsTeam1,goalsTeam2,kickoffTeam] = UpdateScore(ball,goalsTeam1,goalsTeam2)
% This function updates the score and the team that will kickoff after a goal
kickoffTeam=0; % Default value, set to 0 if no goal is scored
fieldLength=90;
% Check if ball has crossed the goal line and is between the goal posts
if ball(1,1)>=fieldLength/2 && ball(1,2)>-13 && ball(1,2)<13
    goalsTeam1=goalsTeam1+1; % Increment goals for team 1
    kickoffTeam=1; % Set kickoff team to team 2
elseif ball(1,1)<=-fieldLength/2 && ball(1,2)>-13 && ball(1,2)<13
    goalsTeam2=goalsTeam2+1; % Increment goals for team 2
    kickoffTeam=0; % Set kickoff team to team 1
end


end

