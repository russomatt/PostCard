 import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let APPLICATION_ID = "63E6BEB9-AC2E-0B24-FF2C-F948484DAB00"
    let API_KEY = "2C160E48-1E10-FDA0-FF44-EB006605BF00"
    let SERVER_URL = "https://api.backendless.com"
    let backendless = Backendless.sharedInstance()!
    
    var messagesArray:[String] = [String]()
    
    
    @IBOutlet weak var messageTableView: UITableView!

    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var sendBar: UIView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // add tap gesture recognizer to the tableview
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tableViewTapped))
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        // set self as the delegate for the text field
        self.messageTextField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        backendless.hostURL = SERVER_URL
        backendless.initApp(APPLICATION_ID, apiKey: API_KEY)
        
        sendBar.layer.borderWidth = 1.0
        sendBar.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.25).cgColor

        // retrieve messages from backendless
        self.retrieveMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendButtonIsTapped(_ sender: UIButton) {
        

        // send button is tapped

        self.messageTextField.isEnabled = false
        self.sendButton.isEnabled = false

        // call end editing text field function
        self.messageTextField.endEditing(true)

        // create new message with text
        let newText =  self.messageTextField.text
        let newMessage = ["Text" : newText];
        
        // save object
        let dataStore = backendless.data.ofTable("MessageTable")
        dataStore?.save(newMessage,
                        response: {
                            (result) -> () in
                            // retreive messages and reload table
                            self.retrieveMessages()
                            
                            DispatchQueue.main.async {
                                self.messageTextField.isEnabled = true
                                self.sendButton.isEnabled = true
                                self.messageTextField.text = ""
                            }
        
        },
                        error: {
                            (fault : Fault?) -> () in
                            print("Server reported an error: \(String(describing: fault))")
        })

    }
    
    // MARK: Textfield delegate methods
    
    @objc(textFieldDidBeginEditing:) func textFieldDidBeginEditing(_ textView: UITextField) {

        // updates changes to constraints if needed
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.viewHeightConstraint.constant = 350
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func retrieveMessages() {
        
        // retrieves all MessageTable
        let dataStore = self.backendless.data.ofTable("MessageTable")
        dataStore?.find({
            (array) -> () in
            let MessagesAsArray = array as! [[String : Any]]
            
            // clear messages array
            self.messagesArray = [String]()

            // loop through all objects
            for messageObject in MessagesAsArray {
            
                // retreive Text value in each row
                let messageText:String? = messageObject["Text"] as? String
                
                // assign it to messagesArray
                if (messageText != nil) {
                    self.messagesArray.append(messageText!)
                }
            }
            
            // reload table view
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
            }
        },
                             error: {
                                (fault : Fault?) -> () in
                                print("Server reported an error: \(String(describing: fault))")
        })

    }
    
    func tableViewTapped() {
        
        // force the text field to end editing
        self.messageTextField.endEditing(true)
        
    }
    
    func textFieldDidEndEditing(_ textView: UITextField) {
        // updates changes to constraints if needed
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.35, animations: {
            
            self.viewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    // MARK: Tableview delegate methonds
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // create a table cell
        let cell = self.messageTableView.dequeueReusableCell(withIdentifier: "MessageCell")!
        
        // customize the cell
        cell.textLabel?.text = self.messagesArray[indexPath.row]

        // return the cell
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
    }
 }
        
