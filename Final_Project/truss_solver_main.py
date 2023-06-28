import numpy as np

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.patches import FancyArrowPatch
from mpl_toolkits.mplot3d import proj3d

# Path handling for saving and acessing
from pathlib import Path
parent_dir = Path(__file__).parent.resolve()


# Arrow class for force plotting
class Arrow3D(FancyArrowPatch):
    def __init__(self, xs, ys, zs, *args, **kwargs):
        super().__init__((0,0), (0,0), *args, **kwargs)
        self._verts3d = xs, ys, zs

    def do_3d_projection(self, renderer=None):
        xs3d, ys3d, zs3d = self._verts3d
        xs, ys, zs = proj3d.proj_transform(xs3d, ys3d, zs3d, self.axes.M)
        self.set_positions((xs[0],ys[0]),(xs[1],ys[1]))

        return np.min(zs)
    
arrow_prop_dict = dict(mutation_scale=10,
                       arrowstyle='-|>', color='k',
                       shrinkA=0, shrinkB=0)


nodes = []
bars = []

# SETUP! Will move to separate input file at some point
nodes.append([-1.03,0, 5.5])
nodes.append([1.03,0, 5.5])
nodes.append([-1.03,1.03,2.75])
nodes.append([1.03,1.03,2.75])
nodes.append([1.03,- 1.03,2.75])
nodes.append([-1.03, -1.03,2.75])
nodes.append([-2.75, 2.75, 0])
nodes.append([2.75,2.75,0])
nodes.append([2.75, -2.75,0])
nodes.append ([-2.75, -2.75,0])

bars.append([0,1])
bars.append([3,0])
bars.append([2,1])
bars.append([4,0])
bars.append([5,1])
bars.append([3,1])
bars.append([4,1])
bars.append([2,0])
bars.append([5,0])
bars.append([5,2])
bars.append([4,3])
bars.append([2,3])
bars.append([5,4])
bars.append([9,2])
bars.append([6,5])
bars.append([8,3])
bars.append([7,4])
bars.append([6,3])
bars.append([7,2])
bars.append([9,4])
bars.append([8,5])
bars.append([9,5])
bars.append([6,2])
bars.append([7,3])
bars.append([8,4])

nodes = np.array(nodes).astype(float)
bars = np.array(bars)

P = np.zeros_like(nodes)

# P[0,0] = 1
# P[0,1] = -30
# P[0,2] = -30

# P[1,1] = -10 
# P[1,2] = -10 

# P[2,0] = 0.5
# P[5,0] = 0.6

landing_upward = 10e1
landing_side = 0
P[6:10,2] = landing_upward
P[6:10,0] = landing_side




# FOrced Displacement
# list of size DIM * No. support nodes
Ur = np.zeros(6)


DOFCON = np.ones_like(nodes).astype(int)

# Degrees of freedom setting
DOFCON[0,:] = 0
DOFCON[1,:] = 0


E=71.7e9 * np.ones(len(bars))
A=0.0706 * np.ones(len(bars))


#%% Truss structural analysis
def TrussAnalysis():

    NN = len(nodes)
    NE = len(bars)
    DOF = 3

    NDOF = DOF*NN

    #structural analysis
    d = nodes[bars[:,1],:] - nodes[bars[:,0],:]
    L = np.sqrt((d**2).sum(axis=1))
    angle = d.T/L
    a = np.concatenate((-angle.T,angle.T), axis=1)
    K = np.zeros([NDOF,NDOF])
    for k in range(NE):
        aux = DOF*bars[k,:]
        index = np.r_[aux[0]:aux[0]+DOF,aux[1]:aux[1]+DOF]

        ES = np.dot(a[k][np.newaxis].T*E[k]*A[k],a[k][np.newaxis])/L[k]
        K[np.ix_(index,index)] += ES

    freeDOF = DOFCON.flatten().nonzero()[0]
    supportDOF = (DOFCON.flatten() == 0).nonzero()[0]
    Kff = K[np.ix_(freeDOF,freeDOF)]

    Kfr = K[np.ix_(freeDOF, supportDOF)]

    Krf = Kfr.T

    Krr = K[np.ix_(supportDOF, supportDOF)]
    Pf = P.flatten()[freeDOF]
    

    Uf = np.linalg.solve(Kff,Pf)
    
    # print("EigenValues:")
    # print(np.linalg.eig(Kff)[0]**0.5)

    U = DOFCON.astype(float).flatten()
    U[freeDOF] = Uf

    U[supportDOF] = Ur
    U = U.reshape(NN,DOF)
    u = np.concatenate((U[bars[:,0]], U[bars[:,1]]), axis = 1)

    N = E*A/L*(a*u).sum(axis = 1)

    R = (Krf*Uf).sum(axis = 1) + (Krr*Ur).sum(axis = 1)
    R = R.reshape(2,DOF)

    return np.array(N), np.array(R), U

def plot_(nodes, c, lt, lw, lg, ax, force_vec = False):

    arrow_scale = 3
    text_offset = 0.2
    for i in range(nodes.shape[0]):

        ax.text(*nodes[i], f"{i}, {lg[0]}", color='red')

        if force_vec is True and np.abs(np.sum(P[i],axis = 0)) > 1e-5:
            # print(i)
            scaled_P = P[i]/np.linalg.norm(P[i])
            # raise "error"  
            x_a = Arrow3D([nodes[i,0], scaled_P[0]*arrow_scale + nodes[i,0]],
                        [nodes[i,1], nodes[i,1]],
                        [nodes[i,2], nodes[i,2]],
                        **arrow_prop_dict)
            
            y_a = Arrow3D([nodes[i,0], nodes[i,0]],
                        [nodes[i,1], scaled_P[1]*arrow_scale + nodes[i,1]],
                        [nodes[i,2], nodes[i,2]],
                        **arrow_prop_dict)
            
            z_a = Arrow3D([nodes[i,0], nodes[i,0]],
                        [nodes[i,1], nodes[i,1]],
                        [nodes[i,2], scaled_P[2]*arrow_scale + nodes[i,2]],
                        **arrow_prop_dict)
            
            
            ax.add_artist(x_a)
            ax.add_artist(y_a)
            ax.add_artist(z_a)

            ax.text(*(nodes[i] + text_offset),
                    f"({P[i,0]},{P[i,1]},{P[i,2]})",
                    color='k')
                

    for i in range(len(bars)):
        xi, xf = nodes[bars[i,0],0], nodes[bars[i,1],0]
        yi, yf = nodes[bars[i,0],1], nodes[bars[i,1],1]
        zi, zf = nodes[bars[i,0],2], nodes[bars[i,1],2]

        line, = ax.plot([xi,xf],[yi,yf],[zi,zf], 
                        color = c,
                        linestyle = lt,
                        linewidth = lw,
                        marker = 'o')
        
    line.set_label(lg)
    plt.legend(prop ={'size':8})
    

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
N, R, U = TrussAnalysis()

print('Axial Forces (positive = tension, negative = compression)')
# print(N[np.newaxis].T)

print('Reaction Forces (positive = upward, negative = downward')
# print(R)

print('Deformation at nodes')
# print(U)

plot_(nodes, 'gray', '--',1, 'Undeformed', ax,force_vec= True)

# Displaced nodes
scale = 1
Dnodes = U*scale + nodes
plot_(Dnodes, 'royalblue', '-', 2, 'Deformed', ax)


plt.show()

# Save figure in specified folder with specified name
out_dir = "figs"
out_name = 'fig-1.png'
print(parent_dir)
plt.savefig(parent_dir/out_dir/out_name, dpi=300)