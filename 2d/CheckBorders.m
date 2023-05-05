function [isGoal, ball, players] = CheckBorders(ball, players)
    nPlayers=length(players{1}); % get number of players
    isGoal=false; % initialize isGoal flag to false
    if (abs(ball(1,1))  > 45 || abs(ball(1,2))  > 30) % check if ball is out of bounds
        if (abs(ball(1,2))  < 13) % check if ball is within goal boundaries
            disp('Goal!') % display message indicating a goal has been scored
            isGoal=true; % set isGoal flag to true
            return % return values and exit function
        else % ball is out of bounds, but not in goal boundaries
            disp('Out!') % display message indicating ball is out of bounds
            text(0,-33,'Ball out!','HorizontalAlignment','center','Color','y','FontSize',15); % display text indicating ball is out of bounds
            
            global lastTeamOnBall; % access global variable indicating the last team in possession of the ball
            otherTeam = -sign(lastTeamOnBall - 1); % calculate the opposing team's number based on the last team in possession of the ball
            teamIndex = find(players{3}(:,1) == otherTeam); % get index of players on the opposing team
            distanceToBall = vecnorm(players{1}(teamIndex,:) - ball(1,:), 2, 2); % calculate distance of each opposing player to the ball
            [~, closestPlayer] = min(distanceToBall); % get index of closest opposing player to the ball
            closestPlayer = teamIndex(closestPlayer); % convert closest player index to index within the players cell array
            pause(1) % pause execution for 1 second
            
            % adjust ball position and player positions based on which
            % boundary the ball went out of bounds on
            if (ball(1,1) > 45)
                ball(1,1) = 45;
                if (otherTeam == 0)
                    ball(1,2) = sign(ball(1,2)) * 45;
                else
                    ball(1,:) = [42,0];
                    for i = 1:nPlayers
                        if (players{3}(i,1) == lastTeamOnBall && players{1}(i,1) > 40)
                            players{1}(i,1) = 40;
                        end
                    end
                end
            end
            if (ball(1,1) < -45)
                ball(1,1) = -45;
                if (otherTeam == 1)
                    ball(1,2) = sign(ball(1,2)) * 45;
                else
                    ball(1,:) = [-42,0];
                    for i = 1:nPlayers
                        if (players{3}(i,1) == lastTeamOnBall && players{1}(i,1) < -40)
                            players{1}(i,1) = -40;
                        end
                    end
                end
            end
            if (ball(1,2) > 30)
                ball(1,2) = 30;
            end
            if (ball(1,2) < -30)
                ball(1,2) = -30;
            end
            
            ball(2,:) = [0 0]; % set ball velocity to zero
            ball(3,:) = [0 0]; % set ball acceleration to zero
            players{1}(closestPlayer,:) = ball(1,:); % set the closest player's position to the ball's position
            
        end
    end
end




