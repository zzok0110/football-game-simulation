% This function initializes the ball with a given start position, velocity, and acceleration.
function [ball] = InitializeBall(startPosition, startVel, startAcc)

% Create a 3x2 matrix for the ball.
ball = zeros(3,2);

% Set the ball's position, velocity, and acceleration.
ball(1,:) = startPosition;
ball(2,:) = startVel;
ball(3,:) = startAcc;
end