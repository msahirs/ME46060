% Two variable valve spring problem - Exercise 3.1
% Visualization of SCALED spring stiffnes and frequency 
% optimization problem

% Initialization
clf, hold off, clear

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
     fobj(j,i) = abs((k-ktarget)/ktarget) + w*abs((freq1-frtarget)/frtarget);
     stiffness(j,i) = k;
     freq(j,i) = freq1;
  end
end

% Investigate search directions from x_q
alpha = 0:0.01:10;
x_q = [0.022 0.004];

S_q1 = repmat([0.002 0.0],size(alpha,2),1);
S_q2 = repmat([0.0 -0.0005],size(alpha,2),1);
S_q3 = repmat([0.002, -0.0005],size(alpha,2),1);

X_q1 = x_q + S_q1 .* alpha';
X_q2 = x_q + S_q2 .* alpha';
X_q3 = x_q + S_q3 .* alpha';

% Contour plot of scaled spring optimization problem
%contour(D, d, fobj,[0:0.05:0.2 0.2:0.1:0.5 0.5:0.5:2 2:5:100])
cc = [0.01 0.02 0.05];
contour(D, d, fobj,[cc 10*cc 100*cc 1000*cc 10000*cc 100000*cc 1000000*cc])
xlabel('Coil diameter D (m)'), ylabel('Wire diameter d (m)'), ...
   % title('Figure 1: Spring stiffness and frequency optimization problem for w = 1.0')
title('Investigation of line searching along prescribed directions')
hold on

% contour(D,d,stiffness,[10000 10000],'r')
% contour(D,d,freq,[300 300],'g')
hold on

a = plot(X_q1(:,1),X_q1(:,2),'LineStyle','--','DisplayName',"S_{q1}", ...
    'LineWidth',1);
b = plot(X_q2(:,1),X_q2(:,2),'LineStyle','--','DisplayName',"S_{q2}", ...
    'LineWidth',1);
c = plot(X_q3(:,1),X_q3(:,2),'LineStyle','--','DisplayName',"S_{q3}", ...
    'LineWidth',1);
in_point = plot(0.022,0.004,'x','MarkerSize',10,'DisplayName', ...
    "Initial Point x_q");
grid
legend([a,b,c, in_point]);

%end 