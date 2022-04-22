import Foundation
import ARKit
import SceneKit

@objc(ARPlugin)
class ARPlugin: CordovaImplementation, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var callbackId: String=""
    var folderName: String=""
    var nodeName: String=""
    var materialPath: String=""
    
    lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100.00))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close Screen", for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    // convenience
    private var view: UIView {
        self.viewController.view
    }

    @objc(openARView:)
    func openARView(command: CDVInvokedUrlCommand) {
        self.callbackId = command.callbackId
        self.folderName = command.arguments[0] as? String ?? ""
        
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
        
        self.view.addSubview(closeButton)
        
        closeButton.topAnchor.constraint(equalTo: sceneView.topAnchor, constant: 30).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        
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
    
    @objc
    func closeAction(sender: UIButton!) {
        self.sendResult(result: nil, error: nil, callBackID: self.callbackId)
        sceneView.session.pause()
        
        sceneView.removeFromSuperview()
        self.closeButton.removeFromSuperview()
        
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Gesture Recognizers
    @objc
    func handleTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        guard let hitTestResult = sceneView.hitTest(location, types: .existingPlane).first else { return }
        let position = SCNVector3Make(hitTestResult.worldTransform.columns.3.x,
                                      hitTestResult.worldTransform.columns.3.y,
                                      hitTestResult.worldTransform.columns.3.z)
        addObjectModelTo(position: position)
    }
    
    func addObjectModelTo(position: SCNVector3) {
        let folder = folderName + "/"
        let folderCompletePath = "www/\(folder)mesh.obj"
        let textureCompletePath = "www/\(folder)diffuse.png"
        
        guard let objectScene = SCNScene(named: folderCompletePath) else {
            fatalError("Unable to find \(folderCompletePath)")
        }
        
        guard let baseNode = objectScene.rootNode.childNode(withName: "mesh", recursively: true) else {
            let alert = UIAlertController(title: "Unable to find base node", message: "Please, rename base node mesh.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.viewController.present(alert, animated: true)
            return
        }
        
        baseNode.position = position
//        baseNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        let cakeMaterial = SCNMaterial()
        cakeMaterial.lightingModel = .physicallyBased
        cakeMaterial.diffuse.contents = UIImage(named: textureCompletePath)
        
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
