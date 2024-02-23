clear, clc, close all

%% Parameter definition
A = 1;
A_slope = 1/4;
g = 9.8;
Av_star = 0.001;
rho = 980;
K = 0.01;
phi_o_star = 0.001;
Av_disturbance = 10^(-5);

StopTime = 20000;
TimeStep = 1;

Time = (0:TimeStep:StopTime)';

phi_i_in = [phi_o_star*ones(1,2000/TimeStep),...
    phi_o_star/2*ones(1,10000/TimeStep),phi_o_star*ones(1,StopTime/TimeStep-12000/TimeStep+1)]';
phi_i = timeseries(phi_i_in);

Av_in = generate_array(StopTime, TimeStep, Av_star, Av_disturbance);
Av = timeseries(Av_in);

%% Run model
model = 'Model1.slx';
load_system(model);
SimOut = sim(model,'StopTime',num2str(StopTime),'FixedStep',num2str(TimeStep));

%% Plotting
% The non-linear no disturbance model
figure, 
sgtitle('The non-linear no disturbance model')
subplot(3,2,1)
plot(Time,phi_i_in)
title('Inflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(3,2,2)
plot(SimOut.h.Time,SimOut.h.Data)
title('Height over time')
xlabel('Time [s]')
ylabel('Height [m]')

subplot(3,2,3)
plot(SimOut.phi_o.Time,SimOut.phi_o.Data)
title('Outflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(3,2,4)
plot(SimOut.p.Time,SimOut.p.Data)
title('Pressure over time')
xlabel('Time [s]')
ylabel('Pressure [Pa]')

subplot(3,2,5)
plot(SimOut.m.Time,SimOut.m.Data)
title('Mass over time')
xlabel('Time [s]')
ylabel('Mass [kg]')

subplot(3,2,6)
plot(Time,Av_in)
title('A_v over time')
xlabel('Time [s]')
ylabel('A_v [m^2]')

%{
% The non-linear disturbance model
figure, 
sgtitle('The non-linear with disturbance model')
subplot(3,2,1)
plot(Time,phi_i_in)
title('Inflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(3,2,2)
plot(SimOut.h1.Time,SimOut.h1.Data)
title('Height over time')
xlabel('Time [s]')
ylabel('Height [m]')

subplot(3,2,3)
plot(SimOut.phi_o1.Time,SimOut.phi_o1.Data)
title('Outflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(3,2,4)
plot(SimOut.p1.Time,SimOut.p1.Data)
title('Pressure over time')
xlabel('Time [s]')
ylabel('Pressure [Pa]')

subplot(3,2,5)
plot(SimOut.m1.Time,SimOut.m1.Data)
title('Mass over time')
xlabel('Time [s]')
ylabel('Mass [kg]')

%}
% Linearized delta model
% x = m, y = [p;phi_o;h]

figure, 
sgtitle('The change in linear and non-linear model')
subplot(3,2,1)
hold on
plot(Time,phi_i_in)
hold off
title('Inflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(3,2,2)
hold on
plot(SimOut.y.Time,SimOut.y.Data(3,:),'DisplayName','Linear')
plot(Time,SimOut.h1.Data-SimOut.h.Data,'DisplayName','Non-linear')
hold off
title('Height over time')
xlabel('Time [s]')
ylabel('\Delta Height [m]')
legend

subplot(3,2,3)
hold on
plot(SimOut.y.Time,SimOut.y.Data(2,:),'DisplayName','Linear')
plot(Time,SimOut.phi_o1.Data-SimOut.phi_o.Data,'DisplayName','Non-linear')
hold off
title('Outflow over time')
xlabel('Time [s]')
ylabel('\Delta Volumetric flow [m^3/s]')
legend

subplot(3,2,4)
hold on
plot(SimOut.y.Time,SimOut.y.Data(1,:),'DisplayName','Linear')
plot(Time,SimOut.p1.Data-SimOut.p.Data,'DisplayName','Non-linear')
hold off
title('Pressure over time')
xlabel('Time [s]')
ylabel('\Delta Pressure [Pa]')
legend

subplot(3,2,5)
hold on
plot(SimOut.x.Time,SimOut.x.Data,'DisplayName','Linear')
plot(Time,SimOut.m1.Data-SimOut.m.Data,'DisplayName','Non-linear')
hold off
title('Mass over time')
xlabel('Time [s]')
ylabel('\Delta Mass [kg]')
legend

subplot(3,2,6)
plot(Time,Av_in-Av_star)
title('Disturbances over time')
xlabel('Time [s]')
ylabel('A_v disturbance [m^2]')

%{
% Linear model 
figure, 
sgtitle('The linear model')
subplot(3,2,1)
plot(Time,phi_i_in)
title('Inflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(3,2,2)
plot(SimOut.y.Time,SimOut.y.Data(3,:)+SimOut.h.Data')
title('Height over time')
xlabel('Time [s]')
ylabel('Height [m]')

subplot(3,2,3)
plot(SimOut.y.Time,SimOut.y.Data(2,:)+SimOut.phi_o.Data')
title('Outflow over time')
xlabel('Time [s]')
ylabel('Volumetric flow [m^3/s]')

subplot(3,2,4)
plot(SimOut.y.Time,SimOut.y.Data(1,:)+SimOut.p.Data')
title('Pressure over time')
xlabel('Time [s]')
ylabel('Pressure [Pa]')

subplot(3,2,5)
plot(SimOut.x.Time,SimOut.x.Data+SimOut.m.Data)
title('Mass over time')
xlabel('Time [s]')
ylabel('Mass [kg]')
%}

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