# FatsharkWorksample

Alfons Hedström

Task is to create a dungeon generator similar to rogue with rooms, pathways between and doors that seperates pathways. Written in Lua.

I start with a grid array that represents different symbols. I calculate the max room size in that area with empty spaces between. With the map in grids I spawn the room with random sizes and positions within that grid. To create pathways I take the middle position of each room and iterates to try to find another room. If it finds an empty spot, it places a dot that represents floors, and if it's a hashtag, its a wall, if it's a sign, it is a door. Then to make sure everything is walled off, it will check every position for dots (represents open space) and see if it is surrounded by either wall or door, if it isnt, place walls there.

Now the map is ready to be printed, so we just iterate through all positions and print it into the console.

