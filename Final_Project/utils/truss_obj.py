import numpy as np

from pathlib import Path


parent_dir = Path(__file__).parent.resolve()


# CONSTANTS
DOF = 3

class Truss():

    def __init__(self,nodes,bars, forces, E, A, BCs,
                 rho = np.array([2710])) -> None:

        self.nodes = nodes
        self.bars = bars
        self.forces = forces
        self.E = E
        self.A = A
        self.BCs = BCs
        self.rho = rho

        self.axial_loads = np.array([])
        self.reac_loads = np.array([])
        self.deformation = np.array([])
        self.n_freqs = np.array([])
        self.bar_mass = np.array([])

        self.TrussAnalysis()

    def TrussAnalysis(self, evaluate_eigs = False):
        fix_dof = self.BCs.size - np.count_nonzero(self.BCs)
        Ur = np.zeros(fix_dof)

        NN = len(self.nodes)
        NE = len(self.bars)
        NDOF = DOF*NN

        d = self.nodes[self.bars[:,1],:] - self.nodes[self.bars[:,0],:]
        L = np.sqrt((d**2).sum(axis=1))

        self.bar_mass = L * self.rho * self.A

        angle = d.T/L
        a = np.concatenate((-angle.T,angle.T), axis=1)
        K = np.zeros([NDOF,NDOF])

        for k in range(NE):
            aux = DOF*self.bars[k,:]
            index = np.r_[aux[0]:aux[0]+DOF,aux[1]:aux[1]+DOF]

            ES = np.dot(a[k][np.newaxis].T*self.E[k]*self.A[k],a[k][np.newaxis])/L[k]
            K[np.ix_(index,index)] += ES

        freeDOF = self.BCs.flatten().nonzero()[0]
        supportDOF = (self.BCs.flatten() == 0).nonzero()[0]
        
        Kff = K[np.ix_(freeDOF,freeDOF)]
        Kfr = K[np.ix_(freeDOF, supportDOF)]
        Krf = Kfr.T
        Krr = K[np.ix_(supportDOF, supportDOF)]

        Pf = self.forces.flatten()[freeDOF]

        if evaluate_eigs:
            self.n_freqs = np.linalg.eigvals(Kff)

        Uf = np.linalg.solve(Kff,Pf)

        # print("EigenValues:")
        # print(np.linalg.eig(Kff)[0]**0.5)

        U = self.BCs.astype(float).flatten()
        U[freeDOF] = Uf
        U[supportDOF] = Ur
        U = U.reshape(NN,DOF)
        u = np.concatenate((U[self.bars[:,0]], U[self.bars[:,1]]), axis = 1)

        N = self.E*self.A/L*(a*u).sum(axis = 1)

        R = (Krf*Uf).sum(axis = 1) + (Krr*Ur).sum(axis = 1)
        R = R.reshape(fix_dof//DOF,DOF)

        self.axial_loads = np.array(N)
        self.reac_loads = np.array(R)
        self.deformation = U

    def get_deformed_nodes(self,scale=1):
        return scale * self.deformation + self.nodes
    
    def get_tot_mass(self):
        return np.sum(self.bar_mass)
    
    def get_axial_stress(self):
        return self.axial_loads / self.A
    
    def get_crit_buckling_stress(self, K = 2):

        d = self.nodes[self.bars[:,1],:] - self.nodes[self.bars[:,0],:]
        L = np.sqrt((d**2).sum(axis=1))

        r = (self.A/np.pi)**0.5

        return (np.pi/K)**2 * self.E/(L/r)**2


    def pprint(self):

        print('Axial Forces (positive = tension, negative = compression)')
        print(self.axial_loads[np.newaxis].T)
        print()
        print('Reaction Forces (positive = upward, negative = downward')
        print(self.reac_loads)
        print()
        print('Deformation at nodes')
        print(self.deformation)




def main():
    print("NOTE: Running as script!")

if __name__ == '__main__':
    main()