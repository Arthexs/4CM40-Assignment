clear, clc, close all

A = [-1.097 0 0 0 0 0 0 0;
0 -5.361 8.555 0 0 0 0 0;
0 -8.555 -5.361 0 0 0 0 0;
0 0 0 -15.476 12.250 0 0 0;
0 0 0 -12.250 -15.476 0 0 0;
0 0 0 0 0 -29.442 0 0;
0 0 0 0 0 0 -25.391 8.761;
0 0 0 0 0 0 -8.761 -25.391];

A_1 = [A(1,1)];
A_2 = [A(2,2) A(2,3);
       A(3,2) A(3,3)];
A_3 = [A(4,4) A(4,5);
       A(5,4) A(5,5)];
A_4 = [A(7,7) A(7,8);
       A(8,7) A(8,8)];
A_5 = [A(6,6)];

combine(A_3,A_2)

lambda = eig(A);
eig(A_2);

%scatter(real(lambda),imag(lambda))

function out = combine(A,B)
    sizeA = size(A);
    sizeB = size(B);
    out = zeros(sizeA+sizeB);
    for i = 1:sizeA(1)
        for j = 1:sizeA(2)
            out(i,j) = A(i,j);
        end
    end
    for i = 1:sizeB(1)
        for j = 1:sizeB(2)
            out(i+sizeA(1),j+sizeA(2)) = B(i,j);
        end
    end
end