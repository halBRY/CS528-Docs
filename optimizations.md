# Optimization Details

The bulk of the optimization considerations for this project were centered on the shaders. Given the cleaned dataset size of roughly 350,000 points, it is necessary that there are as few GameObjects as possible loaded into the scene. Thus, the stars and constellation lines are each only a single mesh. 

## Stars
Since the stars would need to move over time, change with scale, and update their colors, I first identified what had to be sent to the GPU only once, and what would need to be updated as a uniform. The XYZ, velocity XYZ, and colors for a star are constant, so they are all initialized as vertex data as part of the initial Mesh. For efficient use of storage, the color for the exoplanet scale, as well as the radius of a given star, are stored as Vector4 in the Mesh's UV coordinates. The position of each point is calculated as follows: 
`(position.xyz * _ScaleFactor) + (velocity.xyz * _timeFactor)`
With this calculation, I can update the scale and time uniforms when needed, without needing to re-send any of the star vertex data after it is initialized. 

## Constellations 
The constellation meshes are a lot smaller than the star mesh, rarely having over 1000 point. So, performance optimizations are less crucial. Thus, clearing and redrawing the mesh buffer to update colors or lines for constellations is a common task, with little observed performance cost. Still, the same ideas as with the stars applies, where position and velocity are sent as static vertex data updated by uniforms, and all of the constellation lines are stored within a single Mesh. For this, I take advantage of the alternating pattern of a the OpenGL style "Lines" topology draw call, where each pair of vertices forms their own, discontinous line. This works well with the format of the Stellarium dataset. 