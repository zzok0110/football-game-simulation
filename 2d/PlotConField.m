function [] = PlotConField(fieldSize)
clf % Clears the current figure
l = fieldSize(1); % Length of the field
s = fieldSize(2); % Width of the field
% Define vertices of the field
u = [-l/2   l/2     %Upper longside            
     -l/2   l/2     %Lower longside     
     l/2    l/2     %Right shortside
     -l/2   -l/2    %Left shortside
     0      0       %Middle line
     ]';
v = [s/2    s/2     %Upper longside
     -s/2   -s/2    %Lower longside
     -s/2   s/2     %Right shortside
     -s/2   s/2     %Left shortside  
     -s/2   s/2     %Middle line
    ]';

% Draw the field lines
line(u,v,'Color','w','LineWidth', 1.5)
hold on

% Draw the goal posts
ug = [-6    0;    -6    0;    -6    -6]';
vg = [13     13;    -13    -13;    -13    13]';
ug = [l/2-ug -l/2+rot90(ug,-2)];
vg = [vg rot90(vg,-2)];
line(ug,vg,'Color','w','LineWidth', 3)
hold on

% Draw the penalty box

uPenBox = [0        20
           0        10
           20     20
           0        20
           10      10
           0        10];
vPenBox = [50/2   50/2
           30/2   30/2
           -50/2  50/2
           -50/2  -50/2
           30/2   -30/2
           -30/2  -30/2]';
uPenBox = uPenBox';
uPenBox = [l/2-uPenBox -l/2+rot90(uPenBox,-2)];
vPenBox = [vPenBox rot90(vPenBox,-2)];
line(uPenBox,vPenBox,'Color','w','LineWidth', 1.5)
hold on
% Draw the penalty spots
p = [0              0       %Center point
     l/2-15       0       %Right penalty point 8.25
     -l/2+15      0       %Left penalty point 8.25
     ];
plot(p(:,1),p(:,2),'.','Color','w')
hold on

% Draw the center circle and arcs
theta = acos(5.5/9.5); % Angle for the arcs
a = 7.5; % x-axis length for the center circle
b = 7.5; % y-axis length for the center circle
t = [linspace(0,2*pi) linspace(-theta,theta) linspace(pi-theta,pi+theta)];
X = a*cos(t);
X = [X(1:100) -l/2+15.7+X(101:200) l/2-15.7+X(201:300)];
Y = b*sin(t);
plot(X(1:100),Y(1:100),'w',X(101:200),Y(101:200),'w',...
    X(201:300),Y(201:300),'w','LineWidth', 1.5)
hold on
xlabel('');
ylabel('');
yticks('');
xticks('');
axis equal
axis(1.15/2*[-l l -s s])
xlim([-55 55]);
ylim([-40 40]);
set(gca,'Color','#32CD32');
set(gcf,'Color','black');
end