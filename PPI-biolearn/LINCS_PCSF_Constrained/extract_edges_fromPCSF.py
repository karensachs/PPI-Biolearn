#Karen Sachs with Clinton Mielke 
#Extracting nodes and edges from the PCSF file provided by Johnny Li, 'W_1.00_B_2.00_G_4.50.robust_network.graphml'



# Author: Aric Hagberg (hagberg@lanl.gov)

#    Copyright (C) 2004-2019 by
#    Aric Hagberg <hagberg@lanl.gov>
#    Dan Schult <dschult@colgate.edu>
#    Pieter Swart <swart@lanl.gov>
#    All rights reserved.
#    BSD license. 



import sys

import matplotlib.pyplot as plt
import networkx as nx

#G = nx.grid_2d_graph(5, 5)  # 5x5 grid
H='W_1.00_B_2.00_G_4.50.robust_network.graphml'
G=nx.read_graphml(H)
# print the adjacency list
#for line in nx.generate_adjlist(G):
    #print(line)
# write edgelist to grid.edgelist
#nx.write_edgelist(G, path="grid.edgelist", delimiter=":")
# read edgelist from grid.edgelist
#H = nx.read_edgelist(path="grid.edgelist", delimiter=":")

nx.draw(G)
#plt.show()

# write_edgelist method : https://networkx.github.io/documentation/networkx-1.10/reference/generated/networkx.readwrite.edgelist.write_edgelist.html#networkx.readwrite.edgelist.write_edgelist
nx.write_edgelist(G, 'edges.txt')
# the same without the extra columns : 
nx.write_edgelist(G,'justEdges.txt', data=False)
nx.write_edgelist(G,'justEdges.csv', data=False, delimiter=',')

# in a terminal : 
# cat justEdges.txt | tr ' ' ',' > justEdges.csv

# G.nodes is a funky object that appears to give a "python dictionary" api
# python dictionaries map D[keys]->values
# so G.nodes.keys() gives a list of node names, and putting list() around it makes a python list
nodeNames = list(G.nodes.keys())

print(nodeNames[0:5])     # first 5

with open('nodes.txt', 'w') as fileHandle:
  fileHandle.write('\n'.join(nodeNames))
