//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
import Spring
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}
class HomeViewController: UIViewController {
 
    @IBOutlet weak var panle: SpringView!
    @IBOutlet weak var logInStatus: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    let transition = FadeInTransitionAnimator()
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        if (PFUser.currentUser() == nil) {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                delay(seconds: 1.5, completion: { () -> () in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                    //viewController.view.backgroundColor = UIColor.whiteColor()
                    self.navigationController?.view.backgroundColor = UIColor.whiteColor()
                    self.navigationController?.pushViewController(viewController, animated: true)
                    //self.presentViewController(viewController, animated: true, completion: nil)
                    
                })
                
            })
        }else{
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.width/2 - 25,100, 50, 50)) as UIActivityIndicatorView
            spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            
            self.view.addSubview(spinner)
            spinner.startAnimating()
            if let name = PFUser.currentUser()?.username{
              self.usernameLabel.text = "@" + name
            }
            
            delay(seconds: 1.5, completion: { () -> () in
                let ChatVC = ChatViewController()
               
               spinner.stopAnimating()
                self.navigationController?.pushViewController(ChatVC, animated: true)
                
                //self.presentViewController(naviVC, animated:true, completion: nil)
            })
        
        }
    }
    
    @IBAction func logOutAction(sender: UIButton) {
        PFUser.logOut()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        navigationController?.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeViewController:UINavigationControllerDelegate{
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if var _ = toVC as? ChatViewController{
        transition.operation = operation
        
            return transition
        }
        else{
        return nil
        }
        
    }
    
}
