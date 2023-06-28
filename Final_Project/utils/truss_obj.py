import numpy as np
from matplotlib import pyplot as plt
from pathlib import Path
parent_dir = Path(__file__).parent.resolve()

DOF = 3

class Truss():

    def __init__(self,nodes,bars, forces, E, A, BCs, rho = []) -> None:

        self.nodes = nodes
        self.bars = bars
        self.forces = forces
        self.E = E
        self.A = A
        self.BCs = BCs

        self.axial_loads = np.array([])
        self.reac_loads = np.array([])
        self.deformation = np.array([])
        self.n_freqs = np.array([])

        self.TrussAnalysis()

    def TrussAnalysis(self, evaluate_eigs = False):

        Ur = np.zeros(self.BCs.size - np.count_nonzero(self.BCs))

        NN = len(self.nodes)
        NE = len(self.bars)


        NDOF = DOF*NN

        #structural analysis
        d = self.nodes[self.bars[:,1],:] - self.nodes[self.bars[:,0],:]
        L = np.sqrt((d**2).sum(axis=1))
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
        R = R.reshape(2,DOF)

        self.axial_loads = np.array(N)
        self.reac_loads = np.array(R)
        self.deformation = U

    def get_deformed_nodes(self,scale=1):
        return scale * self.deformation + self.nodes

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