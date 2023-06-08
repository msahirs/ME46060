function [svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1]=...
springanalysis1(D,d,L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp);
% Analysis of valve spring.
%**************************************************
% SI-Units: m, N(ewtons), s
%**************************************************
% INPUT PARAMETERS:
%  (Potential) Design varables:
%   D  : Mean winding diameter (m).
%   d  : Wire diameter (m).
%   L0 : Unloaded spring length (m).
%   L1 : Spring length at closed valve position (m).
%   n  : Number of active windings (-).

% Fixed input parameters:
%   E : Young's modulus (N/m^2).
%   G : Shear modulus (N/M^2).
%   rho: Material density (kg/m^3)
%   Dv: Nominal valve diameter (m).
%   h : Lift of valve (m).
%   p1: Minimum equivalent valve pressure at closed valve (N/m^2).
%       Minimum spring force required to prevent leakage and to reduce 
%       bouncing of valve on the seat. 
%   p2: Minimum equivalent valve pressure at full opened valve (N/m^2).
%       At (about) full opened valve acceleration of the valve is maximum. 
%       Minimum spring force is necessary to enforce the rocker to 
%       follow the cam.
%   nm: Maximum motor speed (revolutions per second).
%   ncamfac: Factor at which lowest eigenfrequency of spring must be
%            above cycle frequency of valve to avoid excessive vibration (-).
%            Note that speed of cam shaft is half motor speed.
%   nne: Number of extra windings for spring ends.
%   matp: Price wire material (euro/kg).
%   bldp: Price per unit build-in volume (=bldvol) (euro/m^3)

% OUTPUT PARAMETERS
%   svol : Spring material volume (m^3).
%   smass: Material weight (kg).
%   bvol : Build-in volume =  pi/4*D^2*L1 (m^3).
%   matc: Material cost of spring (euro).
%   manc: Manufacturing cost of spring (euro).
%   Lmin: minimum length of spring at maximum compression (m).
%   L2: length of spring at opened valve position (m).
%   k : axial spring stiffness (N/m).
%   F1: Spring force at closed valve position (N).
%   F2: Spring force at fully opened valve position (N).
%   Tau1 : Actual shear stress at closed valve (N/m^2).
%   Tau2 : Actual shear stress at fully opened valve (N/m^2).
%   freq1:  First eigenfrequency of spring (Hz).

% LOCAL VARIABLES
%   Av: Nominal valve area (= (pi/4)*Dv^2) (m^2).
%   Lb: blocking length of spring (m).
%   Sa: Total free length (m) between windings at maximum spring compression.
%       This length is necessary to avoid nonlinear spring behaviour at
%       end of compression, and to allow some extra dynamic deflections 
%       of the windings due to impact loading.
%   F1min: Minimum needed spring force at closed valve (N).
%   F2min: Minimum needed spring force at fully opened valve (N).
%   w    : Winding ratio D/d (-).
%   Wahlfac: Factor to account for non-uniform shear stress due to
%            curvature of wire.

% Spring material volume (m^3):
  svol = pi*D*pi/4*d^2*(n+nne);

% Material (steel)weight (kg):
  smass = svol*rho;

% Build-in volume (m^3):
  bvol = pi/4*D^2*L1;

% Material cost of spring (euro).
  matc = smass*matp;

% Manufacturing cost of spring (euro).
  manc = matc + bvol*bldp;
 
% Axial spring stiffness: 
  k=G*d^4/(8*D^3*n);   

% Blocking length of spring:
  Lb = (n + nne)*1.02*d;     % wire may be 2% above nominal value.

% Total free length between windings [m]: 
  Sa = 1.5*(0.0015*D^2/d + 0.1*d)*n;

% Minimum length of spring:
  Lmin = Lb + Sa;

% Spring length at full opened valve:
  L2 = L1 - h;

% ***************************************************
% ***************************************************

% Nominal valve area:
  Av = Dv^2*pi/4;

% Minimum needed spring force at closed valve:
  F1min = Av*p1;

% Actual spring force at closed valve:
  F1 = (L0 - L1)*k;

% ***************************************************
% ***************************************************

% Minimum needed spring force at full opened valve:
  F2min = Av*p2;

% Actual spring force at fully opened valve:
  F2 = (L0 - L1 + h)*k;

% ***************************************************
% ***************************************************

% Winding ratio:
  w = D/d;

% Wahl factor
  Wahlfac = 1 + 5/(4*w) + 7/(8*w^2) + 1/w^3;

% Shear stress at closed valve:
  Tau1 = Wahlfac*8*F1*D/(pi*d^3);

% Shear stress at fully opened valve:
  Tau2 = Wahlfac*8*F2*D/(pi*d^3);

% ***************************************************
% ***************************************************
  
% First eigenfrequency of spring; formula is valid for 
% steel compression springs with fixed ends [Hz]:
  freq1 = 363*d/(n*D^2);

% ***************************************************
% ***************************************************

% ***************************************************
% Buckling of spring is far from critical (and hence 
% will not be considered) because of the relatively 
% short spring length, combined with the firm guidance
% of the spring ends.
% ***************************************************

%end 