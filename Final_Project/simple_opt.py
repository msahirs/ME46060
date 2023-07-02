from utils.truss_obj import Truss
import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as scop

#Init structure arrays

bars = []

#create links
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

bars.append([1,8])
bars.append([1,7])

bars.append([0,6])
bars.append([0,9])

#Make them numpy

bars = np.array(bars)

#Init arrays for rod properties
E = 69e9* np.ones(len(bars))
A = 0.0806 * np.ones(len(bars))

up_sq = 0.3
mid_sq = 1.03
low_sq = 1
height = 2.75
mid_h = 2.75

# #Solve
# lander_output = Truss(nodes,bars,P,E,A,DOFCON)

L1_range = np.linspace(0.1,5,1000)

up_forces = 10e5
lat_forces = 10e2


no_exceptions = 0

def opt_call_func(x):

    penalty = 0

    for i in x[:3]:
        if i < 0.5: penalty+=1000

    for i in x[3:]:
        if 2>i or i>3: penalty+=1000

    nodes = []
      
    low_sq = x[0]
    mid_sq = x[1]
    up_sq = x[2]
    height = x[3]
    mid_h = x[4]
    

    #Add nodes
    nodes.append([-up_sq,0, height+mid_h])
    nodes.append([up_sq,0, height+mid_h])
    nodes.append([-mid_sq,mid_sq,mid_h])
    nodes.append([mid_sq,mid_sq,mid_h])
    nodes.append([mid_sq,-mid_sq,mid_h])
    nodes.append([-mid_sq, -mid_sq,mid_h])
    nodes.append([-low_sq, low_sq, 0])
    nodes.append([low_sq,low_sq,0])
    nodes.append([low_sq, -low_sq,0])
    nodes.append([-low_sq, -low_sq,0])
    
    nodes = np.array(nodes).astype(float)
    P = np.zeros_like(nodes)
    
    #Create forces
    P[6:10,2] = up_forces
    P[6:10,0] = lat_forces

    #Create degree of freedom array
    DOFCON = np.ones_like(nodes).astype(int)
    # Set top nodes
    DOFCON[2,:] = 0
    DOFCON[3,:] = 0
    DOFCON[4,:] = 0
    DOFCON[5,:] = 0

    lander_output = Truss(nodes,bars,P,E,A,DOFCON)


    
    deform_val = np.abs(lander_output.get_deformed_nodes() - lander_output.nodes)
    deform_val = np.sqrt((deform_val**2).sum(axis=1))
    
    max_def = np.max(deform_val)
    mass = lander_output.get_tot_mass()
    axial_stress = np.max(np.abs(lander_output.get_axial_stress()))/lander_output.fail_stress
    
    buck_crit_i = np.argmin(lander_output.get_axial_stress())
    b_val = lander_output.get_axial_stress()/lander_output.get_crit_buckling_stress()
    buck_stress = b_val[buck_crit_i]

    return max_def + penalty
    # plt.show()


a = scop.minimize(opt_call_func, [1,1,1,2.5,2.5], method='Nelder-Mead', tol=1e-6)

print(a)
# print("Number of exceptions raised: ", no_exceptions)


# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')    

# plot_(lander_output.nodes, lander_output.bars,
#       'gray', '-',1, 'Undeformed', ax,
#       force_vec= True, P=lander_output.forces,
#       arrow_scale = 3, text_offset = 0.2,)
# plt.show()

# plt.plot(L1_used,max_def,'-')

# plt.show()

# plt.plot(L1_used,mass)
# plt.show()
# plt.plot(L1_used,axial_stress,label = "material failure factor")
# plt.plot(L1_used,np.abs(buck_stress), label = "buckling factor")
# plt.legend()
# plt.show()