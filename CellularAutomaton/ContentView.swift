//
//  ContentView.swift
//  CellularAutomaton
//
//  Created by Sonny Kress on 09.12.2023.
//

import SwiftUI


struct ContentView: View {
//    @State var axis_x: Int = 255
//    @State var axis_y: Int = 255
//    @State var cells_count: Int = 15000
    @State private var isError = false
    @State private var showWorld = false
    @State private var start_isDisabled = false
    @State private var stop_isDisabled = true
    @ObservedObject var worldModel = WorldViewModel(x: 255, y: 255, c: 2000, world: ([[]], []))
    
    var body: some View {
        HStack () {
            if (self.showWorld) {
                GeometryReader { geo in
                    ScrollView (.vertical) {
                        ScrollView (.horizontal) {
                            VStack (spacing: 0){
                                ForEach (0..<worldModel.y, id: \.self) { i in
                                    Text(worldModel.world.1[i]).frame(height: 2).kerning(-1)
                                }
                            }
                            .frame(
                                minWidth: geo.size.width,
                                minHeight: geo.size.height
                            )
                        }
                    }
                }
            }
            
            
            VStack {
                Text("Input data")
                VStack {
                    HStack {
                        Text("x: ")
                        TextField("axis x", value: $worldModel.x, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("y: ")
                        TextField("axis y", value: $worldModel.y, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("cells: ")
                        TextField("Cells count", value: $worldModel.c, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                }.frame(width: 150)
                
            
                Button("Start") {
//                    if (self.axis_x == 0 || self.axis_y == 0 || self.cells_count == 0) {
//                        self.isError = true
//                    }
//                    else {
                        worldModel.newWorld()
                        self.showWorld = true
                        start_isDisabled = true
                        stop_isDisabled = false
//                    }
                }.alert(isPresented: $isError, content: {
                    Alert(title: Text("One of the input fields is empty!"))
                })
                .disabled(stop_isDisabled ? false : true)
                
                Button("Stop") {
                    worldModel.newWorld()
                    stop_isDisabled = true
                    showWorld = false
                }.disabled(start_isDisabled ? false : true)
                
                Button {
                    worldModel.updateWorld()
                } label: {
                    Text("Update")
                }
            }
            .padding(5)
            .frame(maxWidth: 160, alignment: .trailing)
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

class WorldViewModel: ObservableObject {
    @Published var x: Int = 255
    @Published var y: Int = 255
    @Published var c: Int = 2000
    @Published var world: ([[Bool]], [String]) = ([[]], [])
    init(x: Int, y: Int, c: Int, world: ([[Bool]], [String])) {
        self.x = x
        self.y = y
        self.c = c
        self.world = world
    }
    
    
    func updateWorld() {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.world = change_world(world: self.world.0, axis_x: self.x, axis_y: self.y)
            })
    }
    
    func newWorld() {
        self.world = create_world(axis_x: self.x, axis_y: self.y, cell_count: self.c)
    }
}


#Preview {
    ContentView()
}
