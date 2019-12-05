//
//  Todoview.swift
//  To-do
//
//  Created by Hemanth Kotla on 2019-12-04.
//  Copyright © 2019 Hemanth Kotla. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct todo
{
    var isChecked: Bool
    var todoname : String
}

class Todoview: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var todos : [todo] = [ ]
    var userID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  welcomelabel()
        
        

        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 70
        
      
        
        loadTodos()
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        try!Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
/*    func welcomelabel()
    {
        let userRef = Database.database().reference(withPath: "users").child(userID!)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
           let value = snapshot.value as? NSDictionary
            let email = value!["email"] as? String
            self.welcome.text = email! + "'s" + " Todo's"
        }
        
    } */
    
    
    
    
    @IBAction func add(_ sender: Any) {
        
        let todoAlert = UIAlertController(title:"new to do", message: "Add a todo", preferredStyle: .alert)
        
        todoAlert.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let todoText = todoAlert.textFields![0].text
            
            self.todos.append(todo(isChecked: false, todoname: todoText!))
            let ref = Database.database().reference(withPath: "users").child(self.userID!).child("todos")
            
            ref.child(todoText!).setValue(["isChecked":false])
            self.tableview.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        todoAlert.addAction(addAction)
        todoAlert.addAction(cancelAction)
        
        present(todoAlert, animated: true, completion: nil)
        
    }
    
    
    
    func loadTodos()
    {
        let ref = Database.database().reference(withPath: "users").child(userID!).child("todos")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]
            {
                let todoname = child.key
                 
                let todoRef = ref.child(todoname)
                
                todoRef.observeSingleEvent(of: .value) { (todoSnapshot) in
                    let value = todoSnapshot.value as? NSDictionary
                    let isChecked = value!["isChecked"] as? Bool
                    self.todos.append(todo(isChecked: isChecked!, todoname: todoname))
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! todoTableViewCell
        
        cell.todoname.text = todos[indexPath.row].todoname
        
        if todos[indexPath.row].isChecked{
            cell.check.image = UIImage(named: "checkdone.png")
        }
        else
        {
              cell.check.image = nil
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ref = Database.database().reference(withPath: "users").child(userID!).child(todos[indexPath.row].todoname)

        if todos[indexPath.row].isChecked
        {
            todos[indexPath.row].isChecked = false
            
            
            ref.updateChildValues(["isChecked": false])
        }
        
        else
        {
            todos[indexPath.row].isChecked = true
                      
                      
                      ref.updateChildValues(["isChecked": true])
            
        }
        
        tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let ref = Database.database().reference(withPath: "users").child(userID!).child(todos[indexPath.row].todoname)

            ref.removeValue()
            todos.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    

   

}
