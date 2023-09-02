local map = {}


function map:init(x, y)
    -- Settings
    self.width = x or 50
    self.height = y or 50

    for i = 1, self.height do
        self[i] = {}
        for j = 1, self.width do
            self[i][j] = " "
        end
    end
end

function map:generate(roomAmount)
    -- ###############################
    --  Room Creation
    -- ###############################

    local maxWidth = 0
    local maxHeight = 0
    local numOfRooms = 0
    local spaceBetweenRooms = 8

    while maxWidth < 4 or maxHeight < 4 do
        math.randomseed(os.time())
        math.random();
        math.random();
        math.random()
        numOfRooms = math.random(4, roomAmount or 8);

        maxWidth = (self.width - (spaceBetweenRooms * numOfRooms)) / numOfRooms
        maxHeight = (self.height - (spaceBetweenRooms * numOfRooms)) / numOfRooms
        maxWidth = math.floor(maxWidth)
        maxHeight = math.floor(maxHeight)
    end

    local rooms = {}


    for i = 1, numOfRooms / 2 do
        for j = 1, numOfRooms / 2 do
            if i + j % 2 == 0 then goto continue end -- Skips some rooms to give the layout not look as much of a grid

            local tempW = math.random(3, maxWidth) -- Random room width within limits
            local tempH = math.random(3, maxHeight) -- Random room height within limits

            -- Room placement within it's maximum room size
            local padding =
            {
                x = math.floor((maxWidth - (tempW * math.random(0.0, 1.0))) / 2),
                y = math.floor((maxHeight - (tempH * math.random(0.0, 1.0))) / 2)
            }

            -- Placing the room on the matrix and saves the middle position of the room
            self, rooms[#rooms + 1] = RoomCreation(
                self, (i * maxWidth) + padding.x + (spaceBetweenRooms * i), -- X
                (j * maxHeight) + padding.y + (spaceBetweenRooms * j), -- Y
                tempW, tempH) -- Width and height

            ::continue::
        end
    end



    -- ###############################
    --  Path Creation
    -- ###############################
    -- Create paths
    for i = 1, #rooms do
        self = PathFinder(self, rooms, i)
    end

    self = CreateWalls(self);
end

function RoomCreation(matrix, x, y, width, height)
    local roomPos = { x = x + math.floor(width / 2), y = y + math.floor(height / 2) }
    for i = x, x + width do
        for j = y, y + height do
            matrix[i][j] = "#"
        end
    end
    for i = x + 1, x + width - 1 do
        for j = y + 1, y + height - 1 do
            matrix[i][j] = "."
        end
    end
    return matrix, roomPos
end

function PathFinder(matrix, rooms, index)
    local currPos = { x = rooms[index].x, y = rooms[index].y }

    local roomIndexes = {}
    for i = 1, #rooms do
        if i == index then
        else
            roomIndexes[#roomIndexes+1] = i
        end
    end
    local randomRoom = math.random(1, #rooms - 1)
    local targetPos = { x = rooms[roomIndexes[randomRoom]].x, y = rooms[roomIndexes[randomRoom]].y}

    local iterations = 0

    while true do
        if currPos.x == targetPos.x and currPos.y == targetPos.y then break end

        if math.random(1, 2) > 1 then -- So the path aren't completely straight
            if currPos.x > targetPos.x then
                currPos.x = currPos.x - 1
            elseif currPos.x < targetPos.x then
                currPos.x = currPos.x + 1
            elseif currPos.y > targetPos.y then
                currPos.y = currPos.y - 1
            elseif currPos.y < targetPos.y then
                currPos.y = currPos.y + 1
            end
        else
            if currPos.y > targetPos.y then
                currPos.y = currPos.y - 1
            elseif currPos.y < targetPos.y then
                currPos.y = currPos.y + 1
            elseif currPos.x > targetPos.x then
                currPos.x = currPos.x - 1
            elseif currPos.x < targetPos.x then
                currPos.x = currPos.x + 1
            end
        end
        
        -- Stop if run into other path way
        if matrix[currPos.x][currPos.y] == "." and iterations > 10 then break end

        PathCreation(matrix, currPos.x, currPos.y)

        iterations = iterations + 1
    end

    return matrix
end

function PathCreation(matrix, x, y)
    local pos = matrix[x][y]
    if pos == "." then
        return matrix
    elseif pos == "#" then
        matrix[x][y] = "+"
    elseif pos == " " then
        matrix[x][y] = "."
    end

    return matrix
end

function CreateWalls(matrix)
    -- Create walls around the path
    for i = 2, matrix.width - 1 do
        for j = 2, matrix.height - 1 do
            -- check surroundings
            for k = 1, 3 do
                for l = 1, 3 do
                    if matrix[i + k - 2][j + l - 2] == "." and matrix[i][j] == " " then
                        matrix[i][j] = "#"
                        goto next
                    elseif matrix[i + k - 2][j + l - 2] == "+" and matrix[i][j] == " " then
                        matrix[i][j] = "#"
                        goto next
                    end
                end
            end
            ::next::
        end
    end
    return matrix
end

function map:print_map()
    local mapString = ""
    for i = 1, self.height do
        for j = 1, self.width do
            mapString = mapString .. self[i][j]
        end
        mapString = mapString .. "\n"
    end
    print(mapString)
end

return map