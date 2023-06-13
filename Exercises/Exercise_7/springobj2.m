function f = springobj2(x);
% Two variable valve spring problem - Exercise 6 
% Computation of objective function 
% Input:
%   x  : [1x2] row of design variables (D and d)
% Output:
%   f  : {1x1] scalar of objective function value

% Assignment of designvariables
D = x(1);
d = x(2);

% Constant parameter values
springparams2;

% Analysis of current valve spring design.
[svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1]=...
    springanalysis1(D,d,L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp);
 
 % Objective function (unscaled)
f = smass;    
    
%end 