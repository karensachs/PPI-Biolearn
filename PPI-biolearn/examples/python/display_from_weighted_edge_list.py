from webweb import Web

# edge weights are the third element in the edge
edge_list = [[0, 1, .1], [1, 2, .5], [2, 3, 1], [3, 4, 2]]

# create the web
web = Web(edge_list)

# we'll scale edge widths by weight to create a visual difference
web.display.scaleLinkWidth = True

# show the visualization
web.show()
