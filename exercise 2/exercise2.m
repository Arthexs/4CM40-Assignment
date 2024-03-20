clear, clc, close all

%%

N = 6;
v = 1;
A = 1;
L = 1;
phi = v*N/L;

syms c1 c2 c3 c4 c5 c6
x = [c1,c2,c3,c4,c5,c6].';
in = [phi,0,0,0,0,0].';
out = [0,0,0,0,0,phi].';
start = 0;
finish = 3.5;
stepsize = 0.0001;


figure
hold on
for i = 0:1
     if (i == 0)
          fprintf("no backflow case:")
     else
          fprintf("backflow case:")
     end
     f = [0, 0.3, 0.3, 0.1, 0.1, 0.1, 0] * i;
     
     forward = (f(2:N+1)+1)*phi;
     backward = f(1:N)*phi;

     A = [-forward(1)-backward(1), backward(2), 0, 0, 0, 0;
          forward(1), -forward(2)-backward(2), backward(3), 0, 0, 0;
          0, forward(2), -forward(3)-backward(3), backward(4), 0, 0;
          0, 0, forward(3), -forward(4)-backward(4), backward(5), 0;
          0, 0, 0, forward(4), -forward(5)-backward(5), backward(6);
          0, 0, 0, 0, forward(5), -forward(6)-backward(6), ]

     [t,c] = ode45(@(t,x) func(t,x,A,in,stepsize,start), start:stepsize:finish,zeros(size(x)));
     y = c*out/(phi);
     %normalize area
     y = y / trapz(t,y,1);
     m_1 = 0;
     for j = 1:length(y)
          m_1 = m_1 + t(j)*y(j)*stepsize;
     end
     fprintf("area = " + trapz(t,y,1) + ", m_1 = " + m_1)
     %a) & b)
     plot(t,y);

     %c)
     mu = zeros(size(1:3));
     for j = 1:3
          for k = 1:length(y)
               mu(j) = mu(j) + ((t(k)-m_1)^j)*y(k)*stepsize;
          end
     end
     mu
     
     %d)
     %check positive definite:
     flow_mat = [forward(1)+backward(1), -forward(1), 0, 0, 0, 0;
                 -backward(2), forward(2)+backward(2), -forward(2), 0, 0, 0;
                 0, -backward(3), forward(3)+backward(3), -forward(3), 0, 0;
                 0, 0, -backward(4), forward(4)+backward(4), -forward(4), 0;
                 0, 0, 0, -backward(5), forward(5)+backward(5), -forward(5);
                 0, 0, 0, 0, -backward(6), forward(6)+backward(6), ]
     
     %check stability of system
     eig(A)

end
xlabel("time(s)")
ylabel("concentration")
legend(["no backflow","regular backflow"])

function dydx = func(t,x,A,in,stepsize,start)
     if (t < start+stepsize)
          dydx = A*x+in/stepsize;
     else
          dydx = A*x;
     end
end