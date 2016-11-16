//
//  StatePickerViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/15/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class StatePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var states: [String] = []
    var stateView : LegStateViewController? = nil
    var current_state : Int = 0
    var rightButton : UIBarButtonItem = UIBarButtonItem()
    
    @IBOutlet var picker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.selectRow(self.current_state, inComponent: 0, animated: false)
        
        self.rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.done))
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationItem.leftBarButtonItem = nil

        // Do any additional setup after loading the view.
    }
    
    func done() {
        if self.current_state == 0 {
            self.stateView?.clearFilterContent()
        }
        else {
            let filterText = states[self.current_state]
            self.stateView?.filteredData = (stateView?.dataSet.filter{ $0.state == filterText })!
            self.stateView?.buildDic()
            self.stateView?.table.reloadData()
        }
        self.stateView?.current_state = self.current_state
        self.navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.current_state = row
    }

}
