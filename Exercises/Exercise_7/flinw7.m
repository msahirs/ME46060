function flin = flinw7(x, x0);
% Two variable valve spring problem - Exercise 7.1 
% Scaled linearized objective function (spring mass). 
% Input:
%   x  : ([1x2] row) design variables (D and d)
%   x0 : ([1x2] row) design point where objective is linearized.
% Output:
%   flin  : [1x1] scalar of linearized objective function value

% Assignment of designvariables
D = x(1);
d = x(2);

% Constant parameter values
springparams2;

% Analysis of valve spring in linearization point x0:
[svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1]=...
    springanalysis1(x0(1),x0(2),L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp);
 
% Objective function in linearization point:
fx0 = smass;
 
% Gradient of objective function in linearization point:
dF = dfw7ex1(x0);
 
% Linearized objective function:
flin = fx0 + dF*(x - x0)';
    
%end 