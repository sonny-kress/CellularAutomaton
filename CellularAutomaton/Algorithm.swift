//
//  Algorithm.swift
//  CellularAutomaton
//
//  Created by Sonny Kress on 09.12.2023.
//

import Foundation

func create_world (axis_x: Int, axis_y: Int, cell_count: Int) -> ([[Bool]], [String]) {
    var world = Array(repeating: Array(repeating: false, count: axis_x), count: axis_y)
    var world_str = Array(repeating: "", count: axis_y)
    
    var cell = 0
    repeat {
        let x = Int.random(in: 0..<axis_y)
        let y = Int.random(in: 0..<axis_x)
        if (!world[x][y]) {
            world[x][y] = true
            cell += 1
        }
    } while (cell < cell_count)
    
    for i in 0..<axis_y {
        for j in 0..<axis_x {
            world_str[i].append(world[i][j] ? "." : " ")
        }
    }
    
    return (world, world_str)
}

func calc_neighbors_Moore(world: [[Bool]], axis_x: Int, axis_y: Int, i: Int, j: Int) -> Int {
    let n1: Int = world[(axis_x + i - 1)%axis_x][(axis_x+j-1)%axis_x] ? 1 : 0
    let n2: Int = world[(axis_x + i - 1)%axis_x][j] ? 1 : 0
    let n3: Int = world[(axis_x + i - 1)%axis_x][(j+1)%axis_x] ? 1 : 0
    let n4: Int = world[i][(axis_x+j-1)%axis_x] ? 1 : 0
    let n5: Int = world[i][(j+1)%axis_x] ? 1 : 0
    let n6: Int = world[(i + 1)%axis_x][(axis_x+j-1)%axis_x] ? 1 : 0
    let n7: Int = world[(i + 1)%axis_x][j] ? 1 : 0
    let n8: Int = world[(i + 1)%axis_x][(j+1)%axis_x] ? 1 : 0
    
    return n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8
}

//func calc_neighbors_Neumann(world: [[Bool]], axis_x: Int, axis_y: Int, i: Int, j: Int) {
//    return world[(axis_x + i - 1)%axis_x][j] + world[i][(axis_x+j-1)%axis_x] +
//           world[i][(j+1)%axis_x] + world[(i + 1)%axis_x][j]
//}

func sum_cell(world: [[Bool]], axis_x: Int, axis_y: Int) -> Int {
    var sum: Int = 0
    for i in 0..<axis_x {
        for j in 0..<axis_y {
            sum += world[i][j] ? 1 : 0
        }
    }
    return sum
}

func change_world (world: [[Bool]], axis_x: Int, axis_y: Int) -> ([[Bool]], [String]) {
    var mutateWorld = world
    var mutateWorld_str = Array(repeating: "", count: axis_y)
    
    for i in 0..<axis_x {
        for j in 0..<axis_y {
            let sum_neighbors = calc_neighbors_Moore(world: world, axis_x: axis_x, axis_y: axis_y, i: i, j: j)
            if ((!world[i][j] && sum_neighbors == 3) || (world[i][j] && (sum_neighbors == 2 || sum_neighbors == 3))) {
                mutateWorld[i][j] = true;
            }
            else {
                mutateWorld[i][j] = false;
            }
        }
    }
    
    for i in 0..<axis_y {
        for j in 0..<axis_x {
            mutateWorld_str[i].append(mutateWorld[i][j] ? "." : " ")
        }
    }
    
    
    return (mutateWorld, mutateWorld_str)
}
