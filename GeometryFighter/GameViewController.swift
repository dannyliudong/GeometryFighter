//
//  GameViewController.swift
//  GeometryFighter
//
//  Created by Liudong on 16/5/28.
//  Copyright (c) 2016年 Liudong. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var myscnView: SCNView!
    var myscene: SCNScene!
    var cameraNode: SCNNode!
    
    var spawnTime: NSTimeInterval = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupScene()
        self.setupCamera()
//        self.spawnShape()

    }
    
    func setupView() {
        myscnView = self.view as! SCNView
        
        myscnView.showsStatistics = true
        myscnView.allowsCameraControl = true
        myscnView.autoenablesDefaultLighting = true
        
        myscnView.delegate = self
        myscnView.playing = true
    }
    
    func setupScene() {
        myscene = SCNScene()
        myscnView.scene = myscene
        
        myscene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    
    func setupCamera() {
        self.cameraNode = SCNNode()
        self.cameraNode.camera = SCNCamera()
        self.cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        
        myscene.rootNode.addChildNode(self.cameraNode)
    }
    
    func spawnShape() {
        var geometry: SCNGeometry
        
        switch ShapeType.random() {
            
        case .Box:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        case .Capsule:
            geometry = SCNCapsule(capRadius: 0.5, height: 3.0)
        case .Cone:
            geometry = SCNCone(topRadius: 0.0, bottomRadius: 0.5, height: 2.0)
    
        default:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
            
        }
        
        geometry.materials.first?.diffuse.contents = UIColor.random() //几何体颜色
        
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        
        let randomX = Float.random(min: -2, max: 2)
        let randomY = Float.random(min: 10, max: 18)
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        geometryNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)
        
        self.myscene.rootNode.addChildNode(geometryNode)
    }
    
    func cleanScene() {
        for node in myscene.rootNode.childNodes {
            if node.presentationNode.position.y < -10 {
                node.removeFromParentNode()
            }
        }
    }
    
    func createTrail(color: UIColor, geometry: SCNGeometry) ->SCNParticleSystem {
        let trail = SCNParticleSystem(named: "", inDirectory: nil)!
        trail.particleColor = color
        trail.emitterShape = geometry
        
        return trail
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

extension GameViewController: SCNSceneRendererDelegate {
    // 2
    func renderer(renderer: SCNSceneRenderer, updateAtTime time:NSTimeInterval) {
        // 1
        if time > spawnTime {
            spawnShape()
            // 2
            spawnTime = time + NSTimeInterval(Float.random(min: 0.2, max: 1.5))
        }
        cleanScene()
    }
    
}

