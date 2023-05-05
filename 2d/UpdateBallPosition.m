function [updatedBall] = UpdateBallPosition(ball, timeDelta, frictionCoefficient)
% This function updates the position and velocity of the ball after a timeDelta
% has passed, taking into account friction and the field boundaries.

% define physical parameters
%bounceCoefficient=0.2;
%frictionCoefficient=0.85;

% Copy the original ball and update its position and velocity.
updatedBall=ball;
updatedBall(1,1)=ball(1,1)+ball(2,1)*timeDelta; % Update x position
updatedBall(1,2)=ball(1,2)+ball(2,2)*timeDelta; % Update y position
updatedBall(2,1)=frictionCoefficient*ball(2,1); % Update x velocity with friction
updatedBall(2,2)=frictionCoefficient*ball(2,2); % Update y velocity with friction


end