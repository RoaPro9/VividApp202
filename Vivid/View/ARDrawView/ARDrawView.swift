import ARKit
import SceneKit
import SwiftUI
import Combine

class ARDrawViewModel: ObservableObject {
    @Published var drawingArray: [Data] = [Data]()
    @Published var eraseDrawing: Bool = false
    @Published var nodeToDraw: [(data: [Data], location: CLLocation)] = []
    
}

class ARDrawView: ARSCNView {
    
    
    var hexColor: String = ""
    var lastPoint: SCNVector3?
    var lineWidth: CGFloat = 10
    @ObservedObject var viewModel: ARDrawViewModel
    var drawingArray = [Data]()
    var shouldClear: Bool = false {
        didSet {
            if shouldClear {
                self.clearAll()
            }
        }
    }
    private var currentColor: UIColor = .white
    weak var drawerDelegate: ARDrawerViewDelegate?
    private var cancellabel = Set<AnyCancellable>()
    init(frame: CGRect, options: [String: Any]? = nil, viewModel: ARDrawViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, options: options)
        
        let config = ARWorldTrackingConfiguration()
        session.run(config)
        delegate = self
        setupObserver()
    }
    
    func setupObserver() {
        viewModel.objectWillChange.sink { [weak self] (value)  in
            print(value)
        }.store(in: &cancellabel)
        
        viewModel.$eraseDrawing.sink { shouldDelete in
            
            self.clearAll()
        }.store(in: &cancellabel)
        
        viewModel.$nodeToDraw.sink { allData in
            self.drawFromArray(allData)
        }.store(in: &cancellabel)
    }
    
    deinit {
        print("DEBUG: is called")
        session.pause()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        lastPoint = unprojectPoint(SCNVector3(point.x, point.y, 0.997))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self), let lastPoint = lastPoint else { return }
        let currentPoint = unprojectPoint(SCNVector3(point.x, point.y, 0.997))
        addLine(from: lastPoint, to: currentPoint)
        self.lastPoint = currentPoint
    }
    
    private func addLine(from startPoint: SCNVector3, to endPoint: SCNVector3) {
        let lineNode = line_3(positionA: startPoint, positionB: endPoint)
        scene.rootNode.addChildNode(lineNode)
        print(">> \(lineNode)")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: lineNode, requiringSecureCoding: true)
            drawingArray.append(data)
            viewModel.drawingArray = drawingArray
        } catch {
            print("Failed to archive SCNNode: \(error)")
        }
    }
    
    func line_3(positionA: SCNVector3, positionB: SCNVector3  ) -> SCNNode
    {
        let vector = SCNVector3(positionA.x - positionB.x, positionA.y - positionB.y, positionA.z - positionB.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        let midPosition = SCNVector3 (x:(positionA.x + positionB.x) / 2, y:(positionA.y + positionB.y) / 2, z:(positionA.z + positionB.z) / 2)
        
        let lineGeometry = SCNCylinder()
        lineGeometry.radius = 0.002
        lineGeometry.height = CGFloat(distance)
        lineGeometry.radialSegmentCount = 50
        lineGeometry.firstMaterial!.diffuse.contents = currentColor
        
        let lineNode = SCNNode(geometry: lineGeometry)
        lineNode.position = midPosition
        lineNode.look (at: positionB, up: scene.rootNode.worldUp, localFront: lineNode.worldUp)
        
        return lineNode;
    }
    
    func clearAll() {
        
        let nodes = scene.rootNode.childNodes
        
        for node in nodes {
            node.removeFromParentNode()
            
        }
        drawingArray.removeAll()
        
    }
    // [(data: [Data], location: CLLocation)]
    // array: [Data]
    func drawFromArray(_ allDrawing: [(data: [Data], location: CLLocation)]) {
        clearAll()
        
    
        for drawingInfo in allDrawing {

            for item in drawingInfo.data {
                if let node = try? NSKeyedUnarchiver.unarchivedObject(ofClass: SCNNode.self, from: item) {
                    scene.rootNode.addChildNode(node)
                    drawingArray.append(item)
                    viewModel.drawingArray = drawingArray
                    print(">>>> \(node)")
                } else {
                    print("Failed to unarchive SCNNode from data: \(item)")
                }
                
            }
            
        }
    }
}

extension ARDrawView: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("#") {
            guard let startPoint = node.childNodes.first?.position else { return }
            let endPoint = node.position
            addLine(from: startPoint, to: endPoint)
        }
    }
}

protocol ARDrawerViewDelegate: AnyObject {
    func get(drawings: [Data])
}

