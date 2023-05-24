D=20e-3
d=2e-3
L0=5e-2
L1=3e-2
n = 10
n = 8
E = 210e9
G = E/(2*(1+.3))
rho = 8000
Dv = 30e-3
h = 5e-3
p1 = 90000
p2 = 1000
p2 = 10000
nm = 5000/60
ncamfac = 1.3
nm = 6500/60
nne = 2
matp = .25
matp = .25*2.21
matp = .25/2.21
matp = .25/2.21
bldp = 1000000

[svol,smass,bvol,matc,manc,Lmin,L2,k,F1,F2,Tau1,Tau2,freq1]=...
springanalysis1(D,d,L0,L1,n,E,G,rho,Dv,h,p1,p2,nm,ncamfac,nne,matp,bldp)

