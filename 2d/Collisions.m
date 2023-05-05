function [x,y,cflag,cpIdx1,cpIdx2]=Collisions(x,y,particleRadius)
gridSize=length(x);
c=1.0; % constant used in the repulsion calculation
cflag=0; % flag indicating if a collision occurred
cpIdx1=-1; % the index of one player in the collision
cpIdx2=-1; % the index of another player in the collision
threshold = 0.4;  % the smaller the easier to trigger the collision

% Check for collisions between players
for i = 1:gridSize
    for j = 1:i
        if i ~= j % avoid checking a player against themselves
            distance = sqrt((x(i) - x(j)).^2+(y(i) - y(j)).^2); % calculate distance between players
            if distance < 2*particleRadius - threshold % check if the distance is less than the sum of their radius
                cflag = 1; % a collision occurred
                cpIdx1 = i; % save the index of the first player in the collision
                cpIdx2 = j; % save the index of the second player in the collision
                disp('in collision'); % print a message to the console
                
                % Calculate repulsion force between players
                repulsion = (2*particleRadius-distance)/2;
                
                % Move players away from each other to avoid overlap
                x(i) = x(i) + c*repulsion*(x(i)-x(j))/distance;
                x(j) = x(j) - c*repulsion*(x(i)-x(j))/distance;
                y(i) = y(i) + c*repulsion*(y(i)-y(j))/distance;
                y(j) = y(j) - c*repulsion*(y(i)-y(j))/distance;
            end
        end
    end
end

end

