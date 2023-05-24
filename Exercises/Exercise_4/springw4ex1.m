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
contour(D,d,stiffness,[10000 10000])
contour(D,d,freq,[300 300])
grid

%end problem visualization


% Initial design point:
xq = [0.022  0.0035];

% Initiation of optimization process:
again = 1;
cycle = 0
D = xq(1)
d = xq(2)

% Loop over optimization cycle:
while again >= 1,
   cycle = cycle +1
   % Plot marker in current design point:
   plot(xq(1),xq(2),'o');
   
	% Forward finite diffence gradients of objective function and constraints
	hi=1e-8;
	alpha=0.0;
	sq=[0 0];
	% Objective function in point xq
	fx = springobjw4(alpha,xq,sq,ktarget,frtarget,w);
	% Perturbated objective function values:
	fx1plush = springobjw4(alpha,[xq(1)+hi, xq(2)],sq,ktarget,frtarget,w);
	fx2plush = springobjw4(alpha,[xq(1), xq(2)+hi],sq,ktarget,frtarget,w);
	% Objective function derivatives:
	dfdx1 = (fx1plush - fx)/hi;
	dfdx2 = (fx2plush - fx)/hi;
	 % Gradient vector:
  	df = [dfdx1 dfdx2];
	% Steepest descent search direction:
	sq = -df;
   sq
   
	% Setting of options:
	options = optimset('tolx',1.0e-8,'MaxFunEvals',50);

	%Line search (note the lower and upper bound of alfhaq):
   [alphaq,fval,exitflag] = ...
           fminbnd('springobjw4',0,1.0,[options],xq,sq,ktarget,frtarget,w);

	% Optimization results:
	alphaq         % step size
	fval           % value objective function

	% Computation of result of line search (new design point):
	xnew(1) = xq(1) + alphaq*sq(1);
   xnew(2) = xq(2) + alphaq*sq(2);
   D = xnew(1)
   d = xnew(2)

	% Visualisation of line search in problem contour plot:
   plot([xq(1) xnew(1)],[xq(2) xnew(2)],xnew(1),xnew(2),'o')
   
   % Update design point:
   xq = xnew;
   
   % Continu optimization?
   again = input('  Another optimization cycle? (0: No  1: Yes):')
   if again == 0, return; end;

end;  % end optimization cycle (while-loop)

%end 