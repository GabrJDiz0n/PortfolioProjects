% Code by Gabriel Dizon, Inho Song, and Antoine Wang

% Numerical methods and code based off of the notes of
% Professor Charles Peskin

% Objective: Study the stability of an oscillating planet 
% in a binary star system

clear
close all

% Initialization
n = 3;
G = 6.6743 * 10^(-11); % Gravitational Constant m^3/(kg*s^2)
m1 = 1.9891 * 10^(30); % Mass of Star 1
m2 = m1; % Mass of Star 2 (kg)
mp = 5.97219 * 10^(24); % Mass of Planet (kg) 5.97219 * 10^(24)
M = m1 + m2; % Mass of both stars
m = [m1, m2, mp]';
r = 2 * 10^(11); % Distance between the 2 stars (m)
a = r; % Maximum Seperation (m)
b = r; % Minimum Seperation (m)
i_speed = 1; % Initial speed multiplier
v_s = i_speed*sqrt((b/a)*2*G*(m1+m2)/(a+b)); % Initial speed of stars (m/s)
v_p = 6 * 10^(4); % Initial speed of planet (m/s)
% Oscillation stays at equilibrium at 3 * 10^(2) m/s & 6 * 10^4 m/s
% with no perturbance
prtrb = 1 * 10^(-4); % Perturbance of angle
% Changes as small as 1*10^(-14) degrees were enough to break equilibrium
% at planet initial speed 3*10^(2) m/s!
% For 6 * 10^(4) m/s, changes as small as 1*10^(-12) did the job.
degree = 90-prtrb; % Angle of initial planet path relative to plane of stars (Degrees)
theta = degree*(pi/180); % Angle in Radians

tmax = 10*60*60*24*(365.25); % (s)
clockmax = 100*1000; % Number of timesteps
dt = tmax/clockmax; % Timestep (s)
nskip = 90; % Animation speed modifier
% Needed to reduce time step further without compromising animation speed

xsave = zeros(n,clockmax);
ysave = zeros(n,clockmax);
zsave = zeros(n,clockmax);
tsave = zeros(1,clockmax);

Tsave = zeros(1,clockmax);
Usave = zeros(1,clockmax);
Esave = zeros(1,clockmax);

x = [(-m2/M)*a,(m1/M)*a,0]';
y= [0,0,0]';
z = [0,0,0]';
u = [0,0,0]';
v = [(-m2/M)*v_s,(m1/M)*v_s,v_p*cos(theta)]';
w = [0,0,v_p*sin(theta)]';

figure(1)
set(gcf,'double','on')
plot3(0,0,0)
hold on
hb = plot3(x,y,z,'bo');

axis equal
axis((1.2)*[-r,r,-r,r,-r,r]);
axis manual

% For Loop
for i = 1:n
    htr(i) = plot3(x(i),y(i),z(i),'r','linewidth',2);
end

for clock = 1:clockmax
    t = clock*dt;
    for i = 1:n
        for j = 1:n
            if(i ~= j)
                dx = x(j) - x(i);
                dy = y(j) - y(i);
                dz = z(j) - z(i);
                r = sqrt(dx^2 + dy^2 + dz^2);
                u(i) = u(i) + dt*G*m(j)*dx/r^3;
                v(i) = v(i) + dt*G*m(j)*dy/r^3;
                w(i) = w(i) + dt*G*m(j)*dz/r^3;
            end % if
        end % for loop over j
    end % for loop over i

    for i = 1:n
        x(i) = x(i) + dt*u(i);
        y(i) = y(i) + dt*v(i);
        z(i) = z(i) + dt*w(i);
    end % for loop over i
    
    tsave(:,clock) = t;
    xsave(:,clock) = x;
    ysave(:,clock) = y;
    zsave(:,clock) = z;
    hb.XData = x; hb.YData = y; hb.ZData = z;

    if(mod(clock,nskip) == 0)
        for i = 1:n
            htr(i).XData = xsave(i,1:clock);
            htr(i).YData = ysave(i,1:clock);
            htr(i).ZData = zsave(i,1:clock);
        end % for loop over i
        drawnow
    end % if
    % Energy conservation checker
    T = 0; % Initializing Total Kinetic Energy
    for i = 1:n
        T = T+(1/2)*m(i)*(u(i)^2+v(i)^2+w(i)^2);
        Tsave(clock) = T;
    end
    U1p = -G*m1*mp/sqrt((x(1)-x(3))^2+(y(1)-y(3))^2+(z(1)-z(3))^2); % Total Gravitational Potential Energy for m1 and mp
    U2p = -G*m2*mp/sqrt((x(2)-x(3))^2+(y(2)-y(3))^2+(z(2)-z(3))^2); % Total Gravitational Potential Energy for m2 and mp
    U12 = -G*m1*m2/sqrt((x(1)-x(2))^2+(y(1)-y(2))^2+(z(1)-z(2))^2); % Total Gravitational Potential Energy for m1 and m2
    U = U1p + U2p + U12; % Total Gravitational Potential Energy
    Usave(clock) = U;
    Energy = T + U;
    Esave(clock) = Energy;
end % big for loop

% Energy plots
figure(2)
plot(tsave,Tsave,'r-')
hold on
plot(tsave,Usave,'b-')
plot(tsave,Esave,'m-')
title("Energy Plot")
legend("Kinetic Energy","Potential Energy","Total Energy")
ylabel("Joules (J)")
xlabel("Time (s)")

figure(3)
plot(tsave,Esave,'m-')
title("Total Energy Plot (Close Up)")
ylabel("Joules (J)")
xlabel("Time (s)")

figure(4)
plot(tsave,zsave,'r-')
ylabel("Z-Position (m)")
xlabel("Time (s)")

% We have found this system to be extremely unstable! Changes in the path's
% angle as small as 1*10^(-12) were enough to disrupt the system! For some
% speeds, no intentional disturbance was even necessary.

% Additionally, the higher the initial speed of the planet, the longer it
% takes for the planet to break equilibrium, both when deliberately
% perturbed and in the range between intial speeds 3*10^2 and 6*10^4 where
% the planet breaks equilibrium on its own.