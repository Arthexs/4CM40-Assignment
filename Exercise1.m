clear, clc, close all

%% Parameter definition
A = 1;
g = 9.8;
Av_star = 0.001;
rho = 980;
K = 0.01;
phi_o_star = 0.001;

StopTime = 20000;
TimeStep = 1;

phi_i.time = [0:TimeStep:StopTime]';
phi_i.signals.values = [phi_o_star*ones(1,2000),...
    phi_o_star/2*ones(1,10000),phi_o_star*ones(1,StopTime-12000+1)]';

%% Run model
model = 'Model1.slx';
load_system(model);
set_param(bdroot,'SimulationCommand','Update')
SimOut = sim(model,'StopTime',num2str(StopTime),'FixedStep',num2str(TimeStep));

%% Plotting
figure, 
subplot(2,2,1)
plot(SimOut.phi_i.Time,SimOut.phi_i.Data)
title('Inflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(2,2,2)
plot(SimOut.h.Time,SimOut.h.Data)
title('Height over time')
xlabel('Time [s]')
ylabel('Height [m]')

subplot(2,2,3)
plot(SimOut.phi_o.Time,SimOut.phi_o.Data)
title('Outflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(2,2,4)
plot(SimOut.p.Time,SimOut.p.Data)
title('Pressure over time')
xlabel('Time [s]')
ylabel('Pressure [Pa]')
