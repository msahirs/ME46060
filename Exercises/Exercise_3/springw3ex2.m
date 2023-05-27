% Two variable valve spring problem - Exercise 3.2
% Line searches using the line search algorithm fminbnd 
opt = optimset('TolX',1e-8,'Display','iter')
% Initialization
% clf, hold off, clear

w=1;
ktarget=10000; 
frtarget=300;

xq = [0.022 0.004];

S_q1 = [0.002 0.0];
S_q2 = [0.0 -0.0005];
S_q3 = [0.002, -0.0005];


optimal_alpha_1 = fminbnd(@(alpha) ...
    springobjw3(alpha,xq,S_q1,ktarget,frtarget,w), ...
    0 , 10,opt)

optimal_alpha_2 = fminbnd(@(alpha) ...
    springobjw3(alpha,xq,S_q2,ktarget,frtarget,w), ...
    0 , 10,opt)

optimal_alpha_3 = fminbnd(@(alpha) ...
    springobjw3(alpha,xq,S_q3,ktarget,frtarget,w), ...
    0 , 10,opt)

