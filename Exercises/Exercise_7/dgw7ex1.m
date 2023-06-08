function dG = dgw7ex1(x);
% Derivatives of constraints of valve spring design  - Exercise 7.1

% Input:
% x  : design point "[D, d]" for which derivatives are computed.

% Output:
% dG  : [5X2] matrix with gradients of 5 constraints:
%        "[dg1dx1  dg1dx2
%          ....     ....
%          dg5dx1  dg5dx2]" 

% Note: Constant parameter values are read within the function  springcon3.

% Forward finite diffence gradients of objective function and constraints

% Finite diffence step
hx = 1.0e-8;

% Constraint gradients 
gx = springcon3(x);  % Note: gx is [1X5] row vector
gx1plush = springcon3([x(1)+hx, x(2)]);
gx2plush = springcon3([x(1), x(2)+hx]);
dgdx1 = (gx1plush - gx)./hx;
dgdx2 = (gx2plush - gx)./hx;
dG = [dgdx1' dgdx2'];

% end 
