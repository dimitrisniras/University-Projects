function [A,B] = findAffineTransform(p1,p2)

syms a1 a2 a3 a4 b1 b2

eqn1 = a1*p1(1,1) + a2*p1(1,2) + b1 == p2(1,1);
eqn2 = a3*p1(1,1) + a4*p1(1,2) + b2 == p2(1,2);

eqn3 = a1*p1(2,1) + a2*p1(2,2) + b1 == p2(2,1);
eqn4 = a3*p1(2,1) + a4*p1(2,2) + b2 == p2(2,2);

eqn5 = a1*p1(3,1) + a2*p1(3,2) + b1 == p2(3,1);
eqn6 = a3*p1(3,1) + a4*p1(3,2) + b2 == p2(3,2);

sol = solve([eqn1, eqn2, eqn3, eqn4, eqn5, eqn6] , [a1, a2, a3, a4, b1, b2]);

A = [sol.a1 sol.a2; sol.a3 sol.a4];
B = [sol.b1; sol.b2];

end

