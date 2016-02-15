//
//  ListCandidateTopView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/14/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class ListCandidateTopView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view : UIView!
    private var nibName : String = "ListCandidateTopView"
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var subView: ListCandidateSubView!
    
    @IBOutlet weak var nextStepButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    var parentVC : UIViewController? {
        didSet {
            self.subView.parentVC = parentVC
        }
    }
    
    var context : ListCandidateContext? {
        didSet {
            self.subView.context = context
        }
    }
    
    
    var contentViewCollapsed = false
    
    var subViewTopToHeaderViewBottom : NSLayoutConstraint!
    
//    var submitButton : UIButton {
//        return self.subView.submitButton
//    }
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var restaurants : [Restaurant] = [Restaurant]()
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    var currentSelectedCell : UITableViewCell?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    @IBAction func tap(sender: AnyObject) {
        expand()
    }
    
    func expand() {
        if contentViewCollapsed {
            self.subViewTopToHeaderViewBottom.active = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { (success) -> Void in
                    self.contentViewCollapsed = false
            }
        }
    }
    
    private func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        UISetup()
    }
    
    private func UISetup() {
        subViewTopToHeaderViewBottom = NSLayoutConstraint(item: self.subView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.headerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        subViewTopToHeaderViewBottom.priority = 1000
        subViewTopToHeaderViewBottom.active = false
        subView.layer.cornerRadius = 15
        subView.layer.borderWidth = 1.5
        subView.layer.borderColor = UIColor.lightGrayColor().CGColor
        nextStepButton.layer.cornerRadius = 5
        searchResultsTable.hidden = true
        disableNextButton()
        self.subView.previousView = self
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func toNextStep(sender: AnyObject) {
        self.subViewTopToHeaderViewBottom.active = true
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (success) -> Void in
                self.contentViewCollapsed = true
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        if let keyword = textField.text {
            
            if keyword == "" {
                self.restaurants.removeAll()
                self.searchResultsTable.reloadData()
            } else {
                searchRestaurant(keyword: keyword)
            }
        }
        
    }
    
    func searchRestaurant(keyword keyword : String) {
        cleanStates()
        let request : RestaurantSearchRequest = RestaurantSearchRequest()
        request.keyword = keyword
        print(keyword)
        //TODO : get range from list properties and set in the request.
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.cleanStates()
                    self.restaurants += results
                    self.searchResultsTable.hidden = false
                    self.searchResultsTable.reloadData()
//                    self.adjustSearchResultsTableHeight()
                }
                
            })
        }
    }
    
    func cleanStates() {
        self.restaurants.removeAll()
    }
    
//    func adjustSearchResultsTableHeight() {
//        let originalFrame : CGRect = self.searchResultsTable.frame
//        self.searchResultsTable.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, self.searchResultsTable.contentSize.height)
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RestaurantNameAddressTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameAddressRestaurantCell") as? RestaurantNameAddressTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NameAddressRestaurantCell", bundle: nil), forCellReuseIdentifier: "nameAddressRestaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("nameAddressRestaurantCell") as? RestaurantNameAddressTableViewCell
        }
        let restaurant : Restaurant = self.restaurants[indexPath.row]
        cell?.setUp(restaurant: restaurant)
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantNameAddressTableViewCell.height
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell != nil {
            if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
                cell!.accessoryType = UITableViewCellAccessoryType.None
                currentSelectedCell = nil
                restaurantNameLabel.text = ""
                self.subView.cleanStates()
                disableNextButton()
            } else {
                restaurantNameLabel.text = restaurants[indexPath.row].name
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                self.subView.cleanStates()
                self.subView.restaurantId = restaurants[indexPath.row].id
                currentSelectedCell?.accessoryType = UITableViewCellAccessoryType.None
                currentSelectedCell = cell
                enableNextButton()
                textField.resignFirstResponder()
            }
            
        }
        
    }
    
    func enableNextButton() {
        nextStepButton.enabled = true
        nextStepButton.backgroundColor = UIColor(red: 26/255, green: 99/255, blue: 223/255, alpha: 1.0)
    }
    
    func disableNextButton() {
        nextStepButton.enabled = false
        nextStepButton.backgroundColor = UIColor.grayColor()
    }

}
