from utils.truss_obj import Truss
import numpy as np
from utils.plotting import plot_
import matplotlib.pyplot as plt

#Init structure arrays

bars = []

#Add nodes



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

#Make them numpy

bars = np.array(bars)

#Init arrays for rod properties
E = 69e1 * np.ones(len(bars))
A = 0.0406 * np.ones(len(bars))

# #Solve
# lander_output = Truss(nodes,bars,P,E,A,DOFCON)

L1_range = np.linspace(0.05,1,100)

max_def = []
L1_used = []
mass = []
axial_stress = []
no_exceptions = 0
for i in range(L1_range.size):
      
      try:
      
            nodes = []
            
            L1 = L1_range[i]
            L1_used.append(L1_range[i])

            nodes.append([-1.03,0, 5.5])
            nodes.append([1.03,0, 5.5])
            nodes.append([-L1,L1,2.75])
            nodes.append([L1,L1,2.75])
            nodes.append([L1,-L1,2.75])
            nodes.append([-L1, -L1,2.75])
            nodes.append([-2.75, 2.75, 0])
            nodes.append([2.75,2.75,0])
            nodes.append([2.75, -2.75,0])
            nodes.append ([-2.75, -2.75,0])

            nodes = np.array(nodes).astype(float)
            P = np.zeros_like(nodes)
            
            #Create forces
            up_forces = 10e1
            lat_forces = 10e4
            P[6:10,2] = up_forces
            P[6:10,0] = lat_forces

            #Create degree of freedom array
            DOFCON = np.ones_like(nodes).astype(int)
            # Set top nodes
            DOFCON[0,:] = 0
            DOFCON[1,:] = 0

            lander_output = Truss(nodes,bars,P,E,A,DOFCON)


            
            deform_val = np.abs(lander_output.get_deformed_nodes() - lander_output.nodes)
            deform_val = np.sqrt((deform_val**2).sum(axis=1))
            
            max_def.append(deform_val[6])
            mass.append(lander_output.get_tot_mass())
            axial_stress.append(lander_output.get_axial_stress()[-1])
            # plt.show()

      except:
            print(f"Warning! Exception raised for L1 = {L1_range[i]}.\nSkipping area value...\n")
            L1_used.pop()
            no_exceptions+=1
            continue

print("Number of Skipped values: ", no_exceptions)



fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')    

plot_(lander_output.nodes, lander_output.bars,
      'gray', '--',1, 'Undeformed', ax,
      force_vec= True, P=lander_output.forces,
      arrow_scale = 3, text_offset = 0.2,)
plt.show()

plt.plot(L1_used,max_def,'-o')
plt.show()

plt.plot(L1_used,mass)
plt.show()
plt.plot(L1_used,axial_stress)
plt.show()
# print(max_def)

# #Init Plot
# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')

# #Plot undeformed
# plot_(lander_output.nodes, lander_output.bars,
#       'gray', '--',1, 'Undeformed', ax,
#       force_vec= True, P=lander_output.forces,
#       arrow_scale = 3, text_offset = 0.2,)

# #Plot deformed
# plot_(lander_output.get_deformed_nodes(), lander_output.bars,
#       'blue', '-',1, 'Deformed', ax,
#       force_vec= False, node_num = False)

#Show Plot
# plt.show()

# lander_output.pprint()

# # Used for time benchmarking
# import time; counts = 1000

# start = time.time()

# for i in range(counts):
#     lander_output = Truss(nodes,bars,P,E,A,DOFCON)

# end = time.time()
# diff = end-start

# print(f"Total time taken for {counts} iterations: {diff}")
# print(f"In {counts} iterations, average of {diff/counts} per iteration")

