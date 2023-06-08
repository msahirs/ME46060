function dF = dfw7ex1(x);
% Derivatives of objective function of valve spring design  - Exercise 1

% Input:
% x  : design point "[D, d]" for which derivatives are computed.

% Output:
% dF  : [1x2] gradient (row)vector "[dfdx1 dfdx2]" of objective function.

% Note: Constant parameter values are read within the function springobj2. 
% Forward finite diffence gradients of objective function and constraints

% Finite diffence step
hx = 1.0e-8;

% Gradient of objective function
fx = springobj2(x);
fx1plush = springobj2([x(1)+hx, x(2)]);
fx2plush = springobj2([x(1), x(2)+hx]);
dfdx1 = (fx1plush - fx)/hx;
dfdx2 = (fx2plush - fx)/hx;
dF = [dfdx1 dfdx2];

% end 