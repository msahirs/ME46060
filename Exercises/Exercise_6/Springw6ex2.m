% Two variable valve spring problem - Exercise 6.1
% Visualization of spring mass optimization problem,
% using springobj2.m (objective function) and springcon2.m (constraints).

% Initialization
clf, hold off, clear


% Combinations of design variables D and d 
D = [0.020:0.001:0.040];
d = [0.002:0.0002:0.005];

% Matrix of output values for combinations of design variables D and d: 
for j=1:1:length(d)
  for i=1:1:length(D)
    % Assignment of design variables:
    x(1) = D(i);
    x(2) = d(j);
 	 % Objective function
    f = springobj2(x);
    % Grid value of objective function:
    fobj(j,i) = f; 
     
    % Scaled constraints:
    g = springcon2(x);
    % Grid values of constraints:
    g1(j,i) = g(1);    % Scaled length constraint
    g2(j,i) = g(2);    % Scaled lowest force constraint
    g3(j,i) = g(3);    % Scaled highest force constraint
    g4(j,i) = g(4);    % Scaled shear stress constraint
    g5(j,i) = g(5);    % Scaled frequency constraint

  end
end

x0 = [0.034, 0.0045];
A = [];

b = [];
Aeq = [];
beq =[];
lb = [0.02, 0.002];
ub = [0.04,0.005];

[c, ceq] = springcon3(x);
nonlcon = @springcon3;
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
[z, fval, exitflag, output, lambda] = fmincon(@(x) springobj2(x), x0, A, b, Aeq,beq, lb, ub, nonlcon, options );

disp(z )
disp(fval)

% Contour plot of scaled spring problem
contour(D, d, fobj)
xlabel('Coil diameter D (m)'), ylabel('Wire diameter d (m)'), ...
   title('Figure 1: Spring mass optimization problem (Exercise 6.1)')
hold on
contour(D, d, g1, [0.0 0.0])
contour(D, d, g1, [0.005 0.005],'--') % Infeasible region

contour(D, d, g2, [0.0 0.0])
contour(D, d, g2, [0.02 0.02],'--')   % Infeasible region

contour(D, d, g3, [0.0 0.0])
contour(D, d, g3, [0.02 0.02],'--')   % Infeasible region

contour(D, d, g4, [0.0 0.0])
contour(D, d, g4, [0.01 0.01],'--')   % Infeasible region

contour(D, d, g5, [0.0 0.0])
contour(D, d, g5, [0.01 0.01],'--')   % Infeasible region

plot([z(1) x0(1)],[z(2) x0(2)],z(1),z(2),'o')

grid

%end 