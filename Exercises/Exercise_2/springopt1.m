% Two variable valve spring problem - Exercise 2.2
%Constrained optimisation of smass
Tau2max = 600E6;
springparams1;

% Matrix of output values for combinations of design variables D and d 
D = [0.020:0.001:0.040];
d = [0.002:0.0002:0.005];

% Nested For-loop to iterate over input design variables
for j=1:1:length(d)
  for i=1:1:length(D)
%   Analysis of valve spring.
    [svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1,F1min,F2min]=...
    springanalysis1(D(i),d(j),L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp);
    
    %Calculate lower bound for first eigenfreq
    freq1b = 0.5 * nm * ncamfac;
    
    % Calculate objective function
    obj(j,i) = smass;
    
    % Calculate Constraint Functions
    cons_L2(j,i) = 1-L2/Lmin;
    cons_F1(j,i) = 1-F1/F1min;
    cons_F2(j,i) = 1- F2/F2min;
    cons_T2(j,i) = Tau2/Tau2max-1;
    cons_freq1(j,i) = freq1/freq1b - 1;

    % Calculate set Constraint Function for D
    D_bound_1(j,i) = 1- D(i)/0.02;
    D_bound_2(j,i) = D(i)/ 0.04 -1;
    
    % Calculate set Constraint Function for d
    d_bound_1(j,i) = 1- d(j)/0.002;
    d_bound_2(j,i) = d(j)/0.005 -1;
    
  end
end

%Plotting stacked contours with various colours to aid user
plot(1)
contour(D, d, cons_L2, [0. 0.],'r-')
hold on
contour(D, d, cons_F1, [0. 0.],'g-')
hold on
contour(D, d, cons_F2, [0. 0.],'b-')
hold on
contour(D, d, cons_T2, [0. 0.],'r--')
hold on
contour(D, d, cons_freq1, [0. 0.],'g--')
hold on
contour(D, d, d_bound_1, [0. 0.]','k-')
hold on
contour(D, d, d_bound_2, [0. 0.],'k-')
hold on
contour(D, d, D_bound_1, [0. 0.],'k-')
hold on
contour(D, d, D_bound_2, [0. 0.],'k-')
hold on
contour(D, d, obj, [0.032 0.034 0.036 0.038 0.040 0.042 0.044 0.046],ShowText="on")
xlabel('D (m)'), ylabel('d (m)'), title('Contours of spring mass(kg) with scaled constraints')
grid

