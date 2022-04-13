import Foundation
import ARKit
import SceneKit

@objc(OSARAndroidExample)
class OSARAndroidExample: CordovaImplementation, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var callbackId:String=""
    // convenience
    private var view: UIView {
        self.viewController.view
    }

    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        sceneView = ARSCNView()
        self.view.addSubview(sceneView)

        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        // Create a new scene
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        // Gestures
        let tapGesure = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGesure)
        
        addLight()
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration)
    }
    
    // MARK: - Gesture Recognizers
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        guard let hitTestResult = sceneView.hitTest(location, types: .existingPlane).first else { return }
        let position = SCNVector3Make(hitTestResult.worldTransform.columns.3.x,
                                      hitTestResult.worldTransform.columns.3.y,
                                      hitTestResult.worldTransform.columns.3.z)
        addTeddyBearModelTo(position: position)
    }
    
    func addTeddyBearModelTo(position: SCNVector3) {
        guard let teddyBearScene = SCNScene(named: "www/teddyBear.obj") else {
            fatalError("Unable to find teddyBearScene.obj")
        }
        guard let baseNode = teddyBearScene.rootNode.childNode(withName: "teddy", recursively: true) else {
            fatalError("Unable to find baseNode")
        }
        baseNode.position = position
        baseNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        let cakeMaterial = SCNMaterial()
        cakeMaterial.lightingModel = .physicallyBased
        cakeMaterial.diffuse.contents = UIImage(named: "www/bear.jpeg")
        cakeMaterial.normal.intensity = 0.5
        baseNode.geometry?.firstMaterial = cakeMaterial
        
        sceneView.scene.rootNode.addChildNode(baseNode)
    }
    
    func addLight() {
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 0
        directionalLight.castsShadow = true
        directionalLight.shadowMode = .deferred
        directionalLight.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        directionalLight.shadowSampleCount = 10
        
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 3)
        sceneView.scene.rootNode.addChildNode(directionalLightNode)
    }

}
