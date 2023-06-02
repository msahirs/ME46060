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


point = x_star;
% Forward finite diffence gradients of objective function and constraints

% Finite diffence step
hxi = 1e-8;


% Setup RHS (objective gradient)
fx = springobj1(point);

fx1plush = springobj1([x(1)+hxi, x(2)]);
fx2plush = springobj1([x(1), x(2)+hxi]);

dfdx1= (fx1plush - fx)/hxi;
dfdx2= (fx2plush - fx)/hxi;

grad_f = [dfdx1 dfdx2]';


% Setup RHS (constraint gradient collection)

gx = springcon1(point)
inact_con = [1,2,5]
gx(inact_con) = [];

gx1plush = springcon1([x(1)+hxi, x(2)]);
gx1plush(inact_con) = [];
gx2plush = springcon1([x(1), x(2)+hxi]);
gx2plush(inact_con) = [];
dgdx1 = (gx1plush - gx)./hxi;
dgdx2= (gx2plush - gx)./hxi;

grad_g_vec = [dgdx1' dgdx2'];

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



