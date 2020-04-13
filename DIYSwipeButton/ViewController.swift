//
//  ViewController.swift
//  DIYSwipeButton
//
//  Created by Mac on 2020/4/13.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbView: UITableView!
    var dataArray: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.rowHeight = 120
        for i in 0..<20 {
            dataArray.append(i)
        }
    }
    
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "TestCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        //这里通过tag 取值，实际开发建议自定义
        let lb: UILabel = cell?.viewWithTag(1000) as! UILabel
        lb.text = "第\(indexPath.row)行"
        let subContentView: UIView = (cell?.viewWithTag(1001)!)!
        subContentView.backgroundColor = UIColor(red: CGFloat(Double(arc4random_uniform(255))/255.0), green: CGFloat(Double(arc4random_uniform(255))/255.0), blue: CGFloat(Double(arc4random_uniform(255))/255.0), alpha: 1.0)
        subContentView.layer.cornerRadius = 10
        return cell ?? UITableViewCell()
    }

    //MARK: 滑动删除
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        DispatchQueue.main.async {
            let cell = tableView.cellForRow(at: indexPath)
            if cell != nil {
                let subContentView: UIView = (cell?.viewWithTag(1001)!)!
                subContentView.layer.cornerRadius = 0
            }
            
            #warning("这里是主要代码")
            for av in tableView.subviews {
                let avCls = type(of: av)
                if NSStringFromClass(avCls) == "_UITableViewCellSwipeContainerView" {
                    av.layer.cornerRadius = 10
                    for bv in av.subviews {
                        if NSStringFromClass(type(of: bv)) == "UISwipeActionPullView" {
                            for cv in bv.subviews {
                                if NSStringFromClass(type(of: cv)) == "UISwipeActionStandardButton" {
                                    NSLog("cv = \(cv)")
                                    let swipeButton: UIButton = cv as! UIButton
                                    swipeButton.setTitle("啦啦", for: .normal)
                                    swipeButton.setImage(UIImage(named: "icon_delete"), for: .normal)
                                    swipeButton.backgroundColor = UIColor.blue
                                    let cH = bv.frame.size.height
                                    swipeButton.frame = CGRect(x: 0, y: 6, width: cv.frame.size.width, height: cH - 12)
                                    swipeButton.layer.cornerRadius = 5
                                    swipeButton.layer.masksToBounds = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    // 进入编辑模式，按下出现的编辑按钮后,进行删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "删除"
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        NSLog("编辑完成")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = tableView.cellForRow(at: indexPath!)
            if cell != nil {
                let subContentView: UIView = (cell?.viewWithTag(1001)!)!
                subContentView.layer.cornerRadius = 10
            }
        }
    }
}

