% Valve spring design  - Exercise 5.2

% Checking of KKt conditions for selected points

% Initialization
% clf, hold off, clear


% Design point for which gradients are computed ([D d])
% D is Coil diameter, d is wire thickness


%Points to investigate KKT conditions

% Constraint Optimum
x_star = [0.020522 0.003520];
%The intersection of constraints g2 (and g3) and g1
x_g2_and_g1 = [0.02462 0.004035];
% The intersection of constraints g4 and g1
x_g4_and_g1 = [0.022251 0.004075];

x_point = x_g4_and_g1;
% Forward finite diffence gradients of objective function and constraints

% Finite diffence step
hxi = 1e-8;


% Setup RHS (objective gradient)
fx = springobj1(x_point)

fx1plush = springobj1([x_point(1)+hxi, x_point(2)]);
fx2plush = springobj1([x_point(1), x_point(2)+hxi]);

dfdx1= (fx1plush - fx)/hxi;
dfdx2= (fx2plush - fx)/hxi;

grad_f = [dfdx1 dfdx2]'


% Setup LHS (constraint gradient collection)

%Specify g_3 as a dependent constraint, along with g_2
dep_con = 3;

% Remove dependent constraint
gx = springcon1(x_point)
gx(dep_con) = [];

% Find inactive constraints, with numerical leeway
inact_con = find(abs(gx) > 0.001)
gx(inact_con) = [];


gx1plush = springcon1([x_point(1)+hxi, x_point(2)]);
gx1plush(dep_con) = [];
gx1plush(inact_con) = [];

gx2plush = springcon1([x_point(1), x_point(2)+hxi]);
gx2plush(dep_con) = [];
gx2plush(inact_con) = [];

dgdx1 = (gx1plush - gx)./hxi;
dgdx2= (gx2plush - gx)./hxi;

grad_g_vec = [dgdx1' dgdx2']

sol = -grad_g_vec \ grad_f

% Plotting finite difference gradients

% subplot(221)
% plot(hx,dfdx1)
% xlabel('Difference step hx'), ylabel('df/dx1'), title('Spring mass')
% 
% subplot(222)
% plot(hx,dfdx2)
% xlabel('Difference step hx'), ylabel('df/dx2'), title('Spring mass')
% 
% subplot(223)
% plot(hx,dgdx1(:,1)')
% xlabel('Difference step hx'), ylabel('dg1/dx1'), title('Length constraint') 
% 
% subplot(224)
% plot(hx,dgdx2(:,1)')
% xlabel('Difference step hx'), ylabel('dg1/dx2'), title('Length constraint') 



