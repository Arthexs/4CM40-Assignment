clear, clc, close all

%%

N = 6;
v = 1;
A = 1;
L = 1;
phi = v*A;

syms c1 c2 c3 c4 c5 c6
x = [c1,c2,c3,c4,c5,c6].';
in = [v*N/L,0,0,0,0,0].';
out = [0,0,0,0,0,1]*x;
start = 0;
finish = 2.5;
stepsize = 0.001;


figure
hold on
for i = 1:2
     if (i == 1)
          f = [0, 0.3, 0.3, 0.1, 0.1, 0.1, 0];
     else
          f = [0, 0,   0,   0,   0,   0,   0];
     end
     forward = (f(2:N+1)+1)*v*N/L;
     backward = f(1:N)*v*N/L;

     A = [-forward(1)-backward(1), backward(2), 0, 0, 0, 0;
          forward(1), -forward(2)-backward(2), backward(3), 0, 0, 0;
          0, forward(2), -forward(3)-backward(3), backward(4), 0, 0;
          0, 0, forward(3), -forward(4)-backward(4), backward(5), 0;
          0, 0, 0, forward(4), -forward(5)-backward(5), backward(6);
          0, 0, 0, 0, forward(5), -forward(6)-backward(6), ]

     [t,c] = ode45(@(t,x) func(t,x,A,in,stepsize,start), start:stepsize:finish,zeros(size(x)));

     plot(t,c);
end


function dydx = func(t,x,A,in,stepsize,start)
     if (t < start+stepsize)
          dydx = A*x+in/stepsize;
     else
          dydx = A*x;
     end
end