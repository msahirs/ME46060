% Two variable valve spring problem - Exercise 4.1
% 1. Visualization of UNCONSTRAINED spring stiffnes and frequency 
% optimization problem
% 2. Computation of steepest descent search direction
% 3. Line search using this search direction: hand controlled optimization cycles,
% including visualization.

% Initialization
clf, hold off, clear
format long

% 1. Problem visualization
% Constant parameter values
springparams1;
w=1;
ktarget=10000; 
frtarget=300;

% Matrix of output values for combinations of design variables D and d 
D = [0.020:0.0005:0.040];
d = [0.002:0.00004:0.005];
for j=1:1:length(d)
  for i=1:1:length(D)
%   Analysis of valve spring.
    [svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1]=...
    springanalysis1(D(i),d(j),L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp);
 	 % Scaled objective function
     fobj(j,i) = ((k-ktarget)/ktarget)^2 + w*((freq1-frtarget)/frtarget)^2; 
     stiffness(j,i) = k;
     freq(j,i) = freq1;
  end
end

% Contour plot of scaled spring optimization problem
%contour(D, d, fobj,[0:0.05:0.2 0.2:0.1:0.5 0.5:0.5:2 2:5:100])
cc = [0.01 0.02 0.05];
contour(D, d, fobj,[cc 10*cc 100*cc 1000*cc 10000*cc 100000*cc 1000000*cc])
xlabel('Coil diameter D (m)'), ylabel('Wire diameter d (m)'), ...
   title('Figure 1     Spring stiffness and frequency optimization problem (w = 1.0)')
hold on
%contour(D,d,stiffness,[10000 10000])
%contour(D,d,freq,[300 300])
grid

%end problem visualization
xq = [0.022  0.0035];
options = optimoptions("fminunc",Display="iter",FunctionTolerance=1e-6,MaxFunctionEvaluations=20000,MaxIterations=1000,  HessianApproximation="steepdesc" );  % steep descent
%options = optimoptions("fminunc", Display="iter",FunctionTolerance=1e-6,MaxFunctionEvaluations=20000,MaxIterations=1000 ,  HessianApproximation="lbfgs" );          % BFGS
[x, fval] = fminunc(@(xq) s_objw43(xq, ktarget, frtarget, w), xq, options);

plot([xq(1) x(1)],[xq(2) x(2)],x(1),x(2),'o')
disp(x);





%end 