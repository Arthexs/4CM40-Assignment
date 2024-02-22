clear, clc, close all

%% Parameter definition
A = 1;
g = 9.8;
Av_star = 0.001;
rho = 980;
K = 0.01;
phi_o_star = 0.001;
Av_disturbance = 10^(-5);

StopTime = 20000;
TimeStep = 1;

phi_i.time = (0:TimeStep:StopTime)';
phi_i.signals.values = [phi_o_star*ones(1,2000/TimeStep),...
    phi_o_star/2*ones(1,10000/TimeStep),phi_o_star*ones(1,StopTime/TimeStep-12000/TimeStep+1)]';

Av.time = (0:TimeStep:StopTime)';
Av.signals.values = generate_array(StopTime, TimeStep, Av_star, Av_disturbance);

%% Run model
model = 'Model1.slx';
load_system(model);
set_param(bdroot,'SimulationCommand','Update')
SimOut = sim(model,'StopTime',num2str(StopTime),'FixedStep',num2str(TimeStep));

%% Plotting
% The non-linear no disturbance model
figure, 
sgtitle('The non-linear no disturbance model')
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

% The non-linear disturbance model
figure, 
sgtitle('The non-linear with disturbance model')
subplot(2,2,1)
plot(SimOut.phi_i1.Time,SimOut.phi_i1.Data)
title('Inflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(2,2,2)
plot(SimOut.h1.Time,SimOut.h1.Data)
title('Height over time')
xlabel('Time [s]')
ylabel('Height [m]')

subplot(2,2,3)
plot(SimOut.phi_o1.Time,SimOut.phi_o1.Data)
title('Outflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(2,2,4)
plot(SimOut.p1.Time,SimOut.p1.Data)
title('Pressure over time')
xlabel('Time [s]')
ylabel('Pressure [Pa]')

% Linearized model
% x = m, y = [p;phi_o;h]

figure, 
sgtitle('The linear model')
subplot(2,2,1)
plot(SimOut.phi_i1.Time,SimOut.phi_i1.Data)
title('Inflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(2,2,2)
plot(SimOut.y.Time,SimOut.y.Data(3,:))
title('Height over time')
xlabel('Time [s]')
ylabel('Height [m]')

subplot(2,2,3)
plot(SimOut.y.Time,SimOut.y.Data(2,:))
title('Outflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(2,2,4)
plot(SimOut.y.Time,SimOut.y.Data(1,:))
title('Pressure over time')
xlabel('Time [s]')
ylabel('Pressure [Pa]')

%% Functions
% Needs fixing
function array = generate_array(stoptime, stepsize, Av_star, Av_disturbance)
    % Create time vector
    time = (0:stepsize:stoptime)';

    % Initialize array
    array = Av_star*ones(size(time));

    % Determine cut off at periodic block signal
    period_cut_off = 3000/stepsize;

    % Determine the period length for the periodic signal
    period_length = 6000/stepsize;

    for i = 1:length(array)
        if i <= 1000/stepsize
            continue
        end
        if mod(i-1000/stepsize,period_length) <= period_cut_off
            array(i) = array(i) + Av_disturbance;
            continue
        end
        array(i) = array(i) - Av_disturbance;
    end
end