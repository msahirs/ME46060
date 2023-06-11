function [c, ceq] = springcon3(x)
% Two variable valve spring problem - Exercise 6
% Computation of scaled constraints
% Design variables not scaled.

% Input:
%   x  : [1x2] row of design variables (D and d)
% Output:
%   c  : {1x4] row of inequality constraint values

% Assignment of designvariables
D = x(1);
d = x(2);

% Constant parameter values
springparams2;

% Nominal valve area:
Av = Dv^2*pi/4;

% Analysis of current valve spring design.
[svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1]=...
    springanalysis1(D,d,L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp);
    
% Scaled length constraint
c(1) = Lmin/L2 - 1;
    
% Scaled lowest force constraint
F1min = Av * p1;
c(2) = 1 - F1/F1min;
    
% Scaled highest force constraint
F2min = Av * p2;
c(3) = 1 - F2/F2min;
    
% Scaled shear stress constraint
Tau12max = 600*10^6;
c(4) = Tau2/Tau12max - 1;
    
% Scaled frequency constraint
freq1lb = ncamfac * nm/2;
c(5) = 1 - freq1/freq1lb;

ceq = [];

%end 