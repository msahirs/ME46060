import numpy as np

from matplotlib.patches import FancyArrowPatch
from mpl_toolkits.mplot3d import proj3d


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



def plot_(nodes, bars, c, lt, lw, lg, ax,
          force_vec = False, P = [], arrow_scale = 3,
          text_offset = 0.2, node_num = True):

    for i in range(nodes.shape[0]):

        if node_num:
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
                    f"({P[i,0]:.3},{P[i,1]:.3},{P[i,2]:.3})",
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
    ax.legend(prop ={'size':8})