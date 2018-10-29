const rows = 7
const columns = 7
const dimensions = rows
const directions = [[-1, 0], [1, 0],[0, -1],[0, 1]]

let map = []
for (let r = 0; r < rows; r++) {
    map[r] = []
    for( let c = 0; c < columns; c++) {
        map[r][c] = 0
    }
}


function randomStartingPositon(map) {
    let availablePositions = []
    for (let r in map) {
        for( let c in map[r]) {
            if (map[r][c] === 0 ) availablePositions.push([Number(r), Number(c)])
        }
    }
    let rn = Math.floor(Math.random() * availablePositions.length)
    let rnd = availablePositions[rn]
    return [rnd[0], rnd[1]]
}


function copyMap(map) {
    let temp = []
    for (let r in map) {
        temp.push([])
        for (let c in map[r]) {
            temp[r].push(map[r][c])
        }
    }
    return temp
}

function createColoredPath(color, maxL) {
    console.log("begin color path for", color)
    let m = 0
    var randomLength = Math.ceil(Math.random() * maxL)
    let storedDir = []
    let mMap = copyMap(map)
    let startingPosition = randomStartingPositon(map)
    let currentRow = startingPosition[0]
    let currentColumn = startingPosition[1]
    mMap[currentRow][currentColumn] = color
    let maxLength = maxL

    let lastDirection = [],
        randomDirection = []
        
        
       

    while(m < maxLength ) {
        console.log("m",m, "maxLength", maxLength)
        let isNotRightDirection = true
        randomDirection = directions[Math.floor(Math.random() * directions.length)];
        let tries = 20;
        let i = 0;
        let breakPath = false
        
        while (isNotRightDirection) {
            i++
            if (i >= tries) {
                console.log("breakPath for color:", color)
                mMap[currentRow][currentColumn] = color
                isNotRightDirection = false

                return
            }
            let tempDir = directions[Math.floor(Math.random() * directions.length)];
            if((i < tries) && (((currentRow === 0) && (tempDir[0] === -1)) ||
            ((currentColumn === 0) && (tempDir[1] === -1)) ||
            ((currentRow === dimensions - 1) && (tempDir[0] === 1)) ||
            ((currentColumn === dimensions - 1) && (tempDir[1] === 1)))) {
                i++
                continue
            } 

            if ((mMap[currentRow + tempDir[0]][currentColumn + tempDir[1]] == 0)) {
                randomDirection = tempDir
                isNotRightDirection = false
                    break;
                }
        }
        if (breakPath) {
            breakPath = false
            return
        }
        if ((mMap[currentRow + randomDirection[0]][currentColumn + randomDirection[1]] !== 0) && (((currentRow === 0) && (randomDirection[0] === -1)) ||
        ((currentColumn === 0) && (randomDirection[1] === -1)) ||
        ((currentRow === dimensions - 1) && (randomDirection[0] === 1)) ||
        ((currentColumn === dimensions - 1) && (randomDirection[1] === 1)))) {

        } else {
            storedDir.push([randomDirection[0], randomDirection[1]])
            currentRow += randomDirection[0]; 
            currentColumn += randomDirection[1];
            mMap[currentRow][currentColumn] = 1;
            m++ 

        }
}
    if(storedDir.length > randomLength) {
        console.log(color,"path made it to cut", storedDir.length)
        mMap[currentRow][currentColumn] = color;
        map = copyMap(mMap)

        return;
        
    } else {
        m++
        randomLength = randomLength - 1 
        lastDirection = [],
        randomDirection = []
        startingPosition = randomStartingPositon(map)
        currentRow = startingPosition[0]
        currentColumn = startingPosition[1]
        storedDir = []
        mMap = copyMap(map)
    }

}

createColoredPath(10, 10)
createColoredPath(20, 6)
createColoredPath(30, 6)
createColoredPath(40, 6)
createColoredPath(50, 6)
createColoredPath(60, 6)
createColoredPath(60, 6)
createColoredPath(30, 8)
createColoredPath(40, 5)
createColoredPath(60, 5)
createColoredPath(20, 6)
createColoredPath(30, 6)
createColoredPath(40, 6)
createColoredPath(50, 6)
createColoredPath(60, 6)
createColoredPath(60, 6)
createColoredPath(30, 8)
createColoredPath(40, 5)
createColoredPath(20, 6)
createColoredPath(30, 3)
createColoredPath(40, 3)
createColoredPath(50, 3)
createColoredPath(60, 3)
createColoredPath(60, 3)
createColoredPath(30, 3)
createColoredPath(40, 3)
createColoredPath(10, 10)
createColoredPath(20, 6)
createColoredPath(30, 6)
createColoredPath(40, 6)
createColoredPath(50, 6)
createColoredPath(60, 6)
createColoredPath(60, 6)
createColoredPath(30, 8)
createColoredPath(40, 5)
createColoredPath(60, 5)
createColoredPath(20, 6)
createColoredPath(30, 6)
createColoredPath(40, 6)
createColoredPath(50, 6)
createColoredPath(60, 6)
createColoredPath(60, 6)
createColoredPath(30, 8)
createColoredPath(40, 5)
createColoredPath(20, 6)
createColoredPath(30, 3)
createColoredPath(40, 3)
createColoredPath(50, 3)
createColoredPath(60, 3)
createColoredPath(60, 3)
createColoredPath(30, 3)
createColoredPath(40, 3)
createColoredPath(60, 5)
createColoredPath(20, 6)
createColoredPath(30, 6)
createColoredPath(40, 6)
createColoredPath(50, 6)
createColoredPath(60, 6)
createColoredPath(60, 6)
createColoredPath(30, 8)
createColoredPath(40, 5)
createColoredPath(20, 6)
createColoredPath(30, 3)
createColoredPath(40, 3)
createColoredPath(50, 3)
createColoredPath(60, 3)
createColoredPath(60, 3)
createColoredPath(30, 3)
createColoredPath(40, 3)
createColoredPath(50, 3)
createColoredPath(60, 3)
createColoredPath(60, 3)
createColoredPath(30, 3)
createColoredPath(40, 3)
createColoredPath(50, 3)
createColoredPath(60, 3)
createColoredPath(60, 2)
createColoredPath(30, 2)
createColoredPath(40, 2)
console.log(map)



