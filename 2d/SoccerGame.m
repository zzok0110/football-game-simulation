%% Main game file

clear all
clf
clc

%% 3D Parameters
% Video
playback_speed = 0.5;                  % Speed of playback
tF      = 3;                            % Final time                    [s]
fR      = 30/playback_speed;            % Frame rate                    [fps]
dt      = 1/fR;                         % Time resolution               [s]
ptime    = linspace(0,tF,tF*fR);         % Time

%% 2D Parameters
% Initialzing values
field = [90 60];   % length and width
kickoffTeam=0;
formation1=[2 1 0];
formation2=[2 1 0];
nPlayers=sum(formation1)+sum(formation2)+2;
attributes = [zeros(nPlayers/2,1); ones(nPlayers/2,1)];
particleRadius = 1.8;
frictionCoefficient = 0.85;
yellowCardRecord = zeros(0);
substituteMemory = zeros(nPlayers,2); % {yellowcard, substitute}
startPositionBall = [0;0];
startVelBall = [0;0];
startAccBall = [0;0];

goalsTeam1=0;
goalsTeam2=0;

% Timesteps of the simulation in seconds
timeSteps = 5400;
% The gametime elapsed between every update
timeDelta = 1;
% Time between drawing of each plot
timeSync = 0.01;

% Whit these settings one simulation will take 54 seconds
time=0;

global gameState; % initial: 0, ball approach goal: 1, pass ball: 2, dribble: 3, collision: 4
global speedPlayer;
global ballKickedPose;
global goalPlayer;

showSubstitute=false;
showSubstituteTimer = 0;

nParticles = 100; % number of rain drops
particleX = rand(nParticles, 1) * field(1); % random x positions
particleX(1:nParticles/2) = -particleX(1:nParticles/2);  % to cover the whole field
particleY = rand(nParticles, 1) * field(2); % random y positions
particleY(nParticles/4:nParticles/4*3) = -particleY(nParticles/4:nParticles/4*3);  % to cover the whole field

%% 2D Game start
pause(1)

while time < timeSteps
    isGoal=false;
    isSubstitute=false;
    collisiontimer = 0;
    rainMoveTimer = 0;
    speedPlayer = 0;
    lcpIdx1=-1; % the index of one player collision in last time step
    lcpIdx2=-1; % the index of another one collision in last time step
    ball=zeros(3,2);
    ball(1,:)=startPositionBall;
    ball(2,:)=startVelBall;
    ball(3,:)=startAccBall;
    [players,playerOriginalPosition] = InitializePlayers(formation1, formation2, field, attributes, substituteMemory, kickoffTeam);
    %FormationPloter(formation1,formation2,field,attributes,kickoffTeam)
    %pause(1);
    while isGoal==false && time < timeSteps && isSubstitute==false
        gameState = 0;
        [players, ball] = Update(players, ball, timeSync, timeDelta, playerOriginalPosition, frictionCoefficient);
        [players{1}(:,1),players{1}(:,2),cflag,cpIdx1,cpIdx2]=...
            Collisions(players{1}(:,1),players{1}(:,2),particleRadius);
        if gameState == 1
            disp('Kick to goal!');
            disp(ballKickedPose);
            [y,Fs] = audioread('cheers.aac');
            sound(y,Fs);
        end
        if cflag == 1   % If there is a collision
            if lcpIdx1 == cpIdx1 && lcpIdx2 == cpIdx2 && players{3}(cpIdx1) ~= players{3}(cpIdx2)
                collisiontimer = collisiontimer + 1;
            else
                collisiontimer = 0;
            end
            disp('collisiontimer');
            disp(collisiontimer);
            if collisiontimer > 15  % The threshold of yellow card
                [y,Fs] = audioread('whistle.mp3');
                sound(y,Fs);
                disp('Collisions!');
                cardPos = (players{1}(cpIdx1,:)+players{1}(cpIdx2,:))/2;
                rectangle('Position',[cardPos(1)+2.5 cardPos(2)+2.5 3 4],'FaceColor','#FFC90E','EdgeColor','none');
                text(0,-33,'Collision foul!','HorizontalAlignment','center','Color','y','FontSize',15);
                if rand(1) < 0.5
                    fIdx = cpIdx1;
                else
                    fIdx = cpIdx2;
                end
                players{4}(fIdx,1) = players{4}(fIdx,1) + 1;
                ycIdx = fIdx + players{4}(fIdx,2)*nPlayers; % If the player had been subsitituted, the idx is different
                yellowCardRecord = [yellowCardRecord ycIdx];
                text(-10,-43,'#','HorizontalAlignment','center','Color','w','FontSize',12);
                if players{3}(fIdx) == 0
                    text(-9,-43,num2str(ycIdx),'HorizontalAlignment','left','Color','#FF5656','FontSize',12);
                else
                    text(-9,-43,num2str(ycIdx),'HorizontalAlignment','left','Color','#0092FF','FontSize',12);
                end
                if players{4}(fIdx,1) == 1
                    text(-6,-43,'get a yellow card!','HorizontalAlignment','left','Color','w','FontSize',12);
                elseif players{4}(fIdx,1) == 2
                    text(-6,-43,'get a second yellow card!','HorizontalAlignment','left','Color','w','FontSize',12);
                    isSubstitute = true;
                    showSubstitute = true;
                    players{4}(fIdx,2) = players{4}(fIdx,2) + 1;
                    players{4}(fIdx,1) = 0;
                end
                pause(2)
                repulsion = 3;
                players{1}(cpIdx1,1) = players{1}(cpIdx1,1) + repulsion;
                players{1}(cpIdx2,1) = players{1}(cpIdx2,1) - repulsion;
                players{1}(cpIdx1,2) = players{1}(cpIdx1,2) - repulsion;
                players{1}(cpIdx2,2) = players{1}(cpIdx2,2) - repulsion;
                collisiontimer = 0;
            end
            lcpIdx1 = cpIdx1;
            lcpIdx2 = cpIdx2;
        else
            collisiontimer = 0;
        end
        figure(1)
        set(gcf,'Position',[300,100,900,600]);
        PlotConField(field)
        PlotPlayers(players,particleRadius)
        PlotBall(ball)
%         particleSize = 40; % size of each rain drop particle
%         if rainMoveTimer > 10
%             particleX = rand(nParticles, 1) * field(1); % random x positions
%             particleX(1:nParticles/2) = -particleX(1:nParticles/2);  % to cover the whole field
%             particleY = rand(nParticles, 1) * field(2); % random y positions
%             particleY(nParticles/4:nParticles/4*3) = -particleY(nParticles/4:nParticles/4*3);  % to cover the whole field
%             rainMoveTimer = 0;
%         else
%             rainMoveTimer = rainMoveTimer + 1;
%         end
        %particleVx = randn(nParticles, 1) * 5; % random x velocities
        %particleVy = randn(nParticles, 1) * 15; % random y velocities
%         particleColor = [1 1 1]; % color of rain drop particles (blue)
        % update rain drop positions
        %particleX = mod(particleX + particleVx, field(1));
        %particleY = mod(particleY + particleVy, field(2));
        % plot rain drop particles
%         scatter(particleX, particleY, particleSize, particleColor, 'hexagram');
        % pause for a short time to control the speed of the rainfall
        %pause(timeSync);
        if ~isempty(yellowCardRecord)
            lyellowCardPos = [-52.5 -38];
            ryellowCardPos = [49.5 -38];
            for i = 1:length(yellowCardRecord)
                pIdx = yellowCardRecord(i);
                if mod(pIdx, nPlayers) <= nPlayers/2
                    rectangle('Position',[lyellowCardPos(1) lyellowCardPos(2) 3 4],'FaceColor','#FFC90E','EdgeColor','none');
                    text(lyellowCardPos(1)+1.5,-36,num2str(pIdx),'HorizontalAlignment','center','Color','r','FontSize',12);
                    lyellowCardPos(1) = lyellowCardPos(1) + 5;
                else
                    rectangle('Position',[ryellowCardPos(1) ryellowCardPos(2) 3 4],'FaceColor','#FFC90E','EdgeColor','none');
                    text(ryellowCardPos(1)+1.5,-36,num2str(pIdx),'HorizontalAlignment','center','Color','#0070C9','FontSize',12);
                    ryellowCardPos(1) = ryellowCardPos(1) - 5;
                end
            end
        end
        if showSubstitute
            if showSubstituteTimer < 30
                ycIdx = yellowCardRecord(length(yellowCardRecord));
                newIdx = ycIdx + nPlayers;
                text(-11,-43,'#','HorizontalAlignment','center','Color','w','FontSize',12);
                if mod(ycIdx, nPlayers) <= nPlayers/2
                    text(-10,-43,num2str(ycIdx),'HorizontalAlignment','left','Color','#FF5656','FontSize',12);
                    text(17,-43,num2str(newIdx),'HorizontalAlignment','left','Color','#FF5656','FontSize',12);
                else
                    text(-10,-43,num2str(ycIdx),'HorizontalAlignment','left','Color','#0092FF','FontSize',12);
                    text(17,-43,num2str(newIdx),'HorizontalAlignment','left','Color','#0092FF','FontSize',12);
                end
                text(-7,-43,'was substituted by #','HorizontalAlignment','left','Color','w','FontSize',12);
                showSubstituteTimer = showSubstituteTimer + 1;
            else
                showSubstitute = false;
                showSubstituteTimer = 0;
            end
        end
        [isGoal, ball, players] = CheckBorders(ball, players); % Check if the ball out the border or goal
        if isGoal
            [y,Fs] = audioread('cheers.aac');
            sound(y,Fs);
            [goalsTeam1,goalsTeam2,kickoffTeam] = UpdateScore(ball,goalsTeam1,goalsTeam2);
            if kickoffTeam == 1
                text(0,-33,'Goal!','HorizontalAlignment','center','Color','red','FontSize',15);
            elseif kickoffTeam == 0
                text(0,-33,'Goal!','HorizontalAlignment','center','Color','blue','FontSize',15);
            end
        end
        txt = {[sprintf('%02d',fix(time/60)) ':' sprintf('%02d',mod(time,60))],...
            [num2str(goalsTeam1) '-' num2str(goalsTeam2)]};
        text(0,33,txt,'HorizontalAlignment','center');
        if speedPlayer ~= 0
            text(-53,-48,'#','HorizontalAlignment','center','Color','w','FontSize',12);
            showIdx = speedPlayer + players{4}(speedPlayer,2)*nPlayers;
            if speedPlayer <= nPlayers/2
                text(-52,-48,num2str(showIdx),'HorizontalAlignment','left','Color','#FF5656','FontSize',12);
            else
                text(-52,-48,num2str(showIdx),'HorizontalAlignment','left','Color','#0092FF','FontSize',12);
            end
            text(-49,-48,'running faster on the sideband!','HorizontalAlignment','left','Color','w','FontSize',12);
            speedPlayer = 0;
        end
        if time == 1
            [y,Fs] = audioread('whistle.mp3');
            sound(y,Fs);
        end
        if time == 15
            [y,Fs] = audioread('cheers.aac');
            %[y,Fs] = audioread('cheer_start.mp3');
            sound(y,Fs);
        end
        if isGoal
            disp('goalPlayer');
            disp(goalPlayer);
            pause(1)
            % 3D simulation
            goal_center_pose = [20 -5];
            kick_area_2d = [22.5 45; -30 30];
            kick_area_3d = [0 20; -30 20];
            ballKickedPose_2d = ballKickedPose;
            disp('ballKickedPose');
            disp(ballKickedPose);
            if ballKickedPose_2d(1) < 0
                ballKickedPose_2d = -ballKickedPose_2d;
            end
            % rescale the ball position in 3D
            ballKickedPose_rescale = [(ballKickedPose_2d(1)-kick_area_2d(1,1))/(kick_area_2d(1,2)-kick_area_2d(1,1))*(kick_area_3d(1,2)-kick_area_3d(1,1))+kick_area_3d(1,1) (ballKickedPose_2d(2)-kick_area_2d(2,1))/(kick_area_2d(2,2)-kick_area_2d(2,1))*(kick_area_3d(2,2)-kick_area_3d(2,1))+kick_area_3d(2,1)];
            disp('ballKickedPose_rescale');
            disp(ballKickedPose_rescale);
            % Ball position [x y z]
            ballKickedPose_3d = [ballKickedPose_rescale 0];
            disp(ballKickedPose_3d);
            % The angle the ball is kicked is calculated to the goal center
            phi_degree = atan((goal_center_pose(2)-ballKickedPose_rescale(2))/(goal_center_pose(1)-ballKickedPose_rescale(1)))/pi*180 - 5;
            % The height the ball is kicked is random within a certain range
            theta_rd = 7 + 8*rand(1);  % value range: 7~15
            ball_speed = 40;
            % Ball initial velocity components x, y and z
            vx_3d = ball_speed*cos(theta_rd*pi/180)*cos(phi_degree*pi/180);
            vy_3d = ball_speed*cos(theta_rd*pi/180)*sin(phi_degree*pi/180);
            vz_3d = ball_speed*sin(theta_rd*pi/180);
            % Ball velocity array
            ball_velocity_3d = [vx_3d vy_3d vz_3d];
            % Initial conditions
            goal_state = [ballKickedPose_3d ball_velocity_3d];
            options = odeset('Events',@(t,y) ball_floor_or_end(t,y,goal_center_pose(1)),'RelTol',1e-6);
            [tout,yout] = ode45(@ball_dynamics,ptime,goal_state,options);
            % Retrieving states
            x = yout(:,1);
            y = yout(:,2);
            z = yout(:,3);
            dx = yout(:,4);
            dy = yout(:,5);
            dz = yout(:,6);
            figure(2)   %%%%%%% Control to show the figure in the same window (1) or open another one (2)
            % Create and open video writer object
            v = VideoWriter('free_kick.mp4','MPEG-4');
            v.Quality = 100;
            % v.FrameRate = fR;
            open(v);
            for i=1:length(tout)
                %set(subplot(4,4,1:8),'Color','green')
                set(gca,'Color','#32CD32');
                set(gcf,'Color','black');
                cla
                hold on ; grid on ; axis equal
                set(gca,'FontName','Verdana','FontSize',12)
                plot_field([-206.4874 199.9462 79.6781],goal_center_pose(1),goal_center_pose(2), goal_state(1:3))
                plot3(x(1:i),y(1:i),z(1:i),'r','LineWidth',2,'Color','yellow')
                plot3(x(i),y(i),z(i),'bo','MarkerFaceColor','#C3C3C3','MarkerSize',8)
                xlabel('');
                ylabel('');
                zlabel('');
                xticks([-10 0 10 20])
                xticklabels({'','','',''})
                yticks([-30 -20 -10 0 10 20])
                yticklabels({'','','','','',''})
                zticks([0 5])
                zticklabels({'',''})
                goalPlayerIdx = goalPlayer + players{4}(goalPlayer,2)*nPlayers;
                titleStr = ['Replay Goal from player #' num2str(goalPlayerIdx)];
                if goalPlayer <= nPlayers/2
                    title(titleStr,'Color','#FF5656')
                else
                    title(titleStr,'Color','#0092FF')
                end
                frame = getframe(gcf);
                writeVideo(v,frame);
                if z(i) <= 0.5 && x(i) >= 20
                    break
                end
            end
            close(v);
            pause(5)   %%%%%%% The displaying time (normal is 2 second)
        end
        time=time+1;
    end
    substituteMemory = players{4};
end
clf
PlotConField(field)
PlotPlayers(players,particleRadius)

function plot_field(camera_position,goal_lon_pos,goal_lat_pos, ball_position)

% Goal
goal_width      = 16.32; % [m]
goal_height     = 4.04; % [m]
% Penalty area
penalty_area_width  = 40.2; % [m]
penalty_area_length = 16.5; % [m]
% Goal area
goal_area_width  = 22.3;    %[m]
goal_area_length = 8.25;     %[m]
% Penalty mark
penalty_mark_distance_from_goal = 12; %[m]
% Penalty arc
penalty_arc_radius      = 9.15;
%     penalty_arc_center_x    = goal_lon_pos-penalty_mark_distance_from_goal;
%     penalty_arc_center_y    = 0;
theta_amp = acos((penalty_area_length-penalty_mark_distance_from_goal)/penalty_arc_radius);
theta = linspace(-theta_amp+pi,theta_amp+pi,10);
x_arc = penalty_arc_radius*cos(theta)+(goal_lon_pos-penalty_mark_distance_from_goal);
y_arc = penalty_arc_radius*sin(theta);
% Endline
endline_width = 50;

set(gca,'CameraPosition',camera_position)
set(gca,'xlim',[-10 goal_lon_pos+5],'ylim',[-endline_width/2+goal_lat_pos endline_width/2+goal_lat_pos],'zlim',[0 6])
% Goal
plot3(  goal_lon_pos*ones(4,1),...
    [-goal_width/2+goal_lat_pos -goal_width/2+goal_lat_pos goal_width/2+goal_lat_pos goal_width/2+goal_lat_pos],...
    [0 goal_height goal_height 0],'k','LineWidth',2)
% Penalty area
plot3(  [goal_lon_pos goal_lon_pos-penalty_area_length goal_lon_pos-penalty_area_length goal_lon_pos],...
    [-penalty_area_width/2+goal_lat_pos -penalty_area_width/2+goal_lat_pos penalty_area_width/2+goal_lat_pos penalty_area_width/2+goal_lat_pos],...
    [0 0 0 0],'k')
% Goal area
plot3(  [goal_lon_pos goal_lon_pos-goal_area_length goal_lon_pos-goal_area_length goal_lon_pos],...
    [-goal_area_width/2+goal_lat_pos -goal_area_width/2+goal_lat_pos goal_area_width/2+goal_lat_pos goal_area_width/2+goal_lat_pos],...
    [0 0 0 0],'k')
% Penalty mark
plot3(goal_lon_pos-penalty_mark_distance_from_goal,goal_lat_pos,0,'ko','MarkerFaceColor','k','MarkerSize',2)
% Penalty arc
plot3(x_arc,y_arc+goal_lat_pos,zeros(length(theta)),'k')
% Endline
plot3([goal_lon_pos goal_lon_pos],[-endline_width/2+goal_lat_pos endline_width/2+goal_lat_pos],[0 0],'k')
% Ball initial position
plot3(ball_position(1), ball_position(2), ball_position(3),'ko','MarkerFaceColor','k','MarkerSize',2)
end

function dstates = ball_dynamics(~,states)
% States
% x   = states(1);
% y   = states(2);
% z   = states(3);
dx  = states(4);
dy  = states(5);
dz  = states(6);

v = sqrt(dx^2 + dy^2 + dz^2);   % Speed                     [m/s]

% Parameters
m   = 0.425;                    % Mass                      [kg]
A   = 0.0388;                   % Cross-sectional area      [m2]
g   = 9.8;                      % Gravity                   [m/s2]
rho = 1.2;                      % Air density               [kg/m3]
r   = 0.111;                    % Radius                    [m]
CM  = 1;                        % Magnus coefficient (Magnus)
CD  = 0.275;                    % Drag coefficient (Prandtl)

% Ball angular velocity
wx = 0;
wy = 0;
wz = 6*2*pi;        % rad/s

% Lumped coefficients
C1 = 1/2*CD*rho*A;
C2 = 1/2*CM*rho*A*r;

ddx = (-C1*v*dx + C2*(wy*dz - wz*dy))/m;
ddy = (-C1*v*dy + C2*(wz*dx - wx*dz))/m;
ddz = (-C1*v*dz + C2*(wx*dy - wy*dx) - m*g)/m;

dstates = [dx ; dy ; dz ; ddx ; ddy ; ddz];

end

function [position,isterminal,direction] = ball_floor_or_end(~,y,goal_lon_pos)
% Terminate simulation when ball touches the floor or YZ plane.
position = (goal_lon_pos+5)-y(1);
isterminal = 1;
direction = 0;
end