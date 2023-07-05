//
//  ViewController.swift
//  EnginePJ
//
//  Created by 王维一 on 2023/7/4.
//

import UIKit

class ViewController: UIViewController, DataModelObserver {
    
    private var countView: UILabel?
    private var hintView: UILabel?
    private var nextButton: UIButton?
    private var countButton: UIButton?
 
    
    func onCountUpdate(newCount: Int64) {
        self.countView?.text =  String(format: "%d", newCount); //flutter 一侧没有解码实现，channel dcode 实现
    }
    
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.countView = UILabel.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 30)))
        self.countView?.center = self.view.center
        self.view.addSubview(self.countView!)
        

        self.hintView = UILabel.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 30)))
        self.hintView?.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 30)
        self.hintView?.text = "you have pushed the button this many times"
        self.view.addSubview(self.hintView!)
        
        
        self.countButton = UIButton.init(frame: CGRect(origin:CGPoint(x: self.view.bounds.width - 80, y: self.view.bounds.height - 80), size: CGSize(width: 50, height: 50)))
        self.countButton?.layer.cornerRadius = 25
        self.countButton?.addTarget(self, action: #selector(onAddCount), for: .touchDown)
        self.countButton?.backgroundColor = UIColor.red
        self.countButton?.setTitle("+", for: .normal)
        self.countButton?.titleLabel?.textColor = UIColor.white
        self.view.addSubview(self.countButton!)

        
        self.nextButton  = UIButton.init(frame: CGRect(origin:CGPoint.zero, size: CGSize(width: 100, height: 30)))
        self.nextButton?.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 80)
        self.nextButton?.addTarget(self , action: #selector(action), for: .touchDown)
        self.nextButton?.backgroundColor = UIColor.green
        self.nextButton?.setTitle("跳转", for: .normal)
        self.nextButton?.titleLabel?.textColor = UIColor.white
        self.view.addSubview(self.nextButton!)
        
        
        DataModel.shared.addObserver(observer: self)
        onCountUpdate(newCount: DataModel.shared.count)
    }
    
    deinit {
        DataModel.shared.removeObserver(observer: self)
    }
    
    
    
    
    @objc func onAddCount() {
      DataModel.shared.count = DataModel.shared.count + 1
    }
    
    @objc func action() {
        // 模拟混合栈路由处理逻辑
        let navController = self.navigationController!
          if DataModel.shared.count % 3 == 1 {
            let vc = SingleFlutterViewController(withEntrypoint: "main")
            navController.pushViewController(vc, animated: true)
          } else {
            let vc = ViewController()
            navController.pushViewController(vc, animated: true)
          }
    }


}

