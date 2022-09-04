//
//  MyFoldersTableViewController.swift
//  FileManagerIB
//
//  Created by Мария Межова on 04.09.2022.
//

import UIKit

class MyFoldersTableViewController: UITableViewController {
    
    private var fileManager = FileManager.default
    private lazy var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var listOfContents: [URL] {
        return ( try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)) ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addNewFolder(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter folder name"
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            
            if let folderName = alertController.textFields?[0].text,
               folderName != "" {
                let newURL = self.url.appendingPathComponent(folderName)
                do {
                    try self.fileManager.createDirectory(at: newURL, withIntermediateDirectories: false)
                } catch {
                    self.showErrorAlert(text: "Unable to create new folder")
                }
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func addNewFile(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new text file", message: nil, preferredStyle: .alert)
                alertController.addTextField { textfield in
                    textfield.placeholder = "Enter file name"
                }
                alertController.addTextField { textfield2 in
                    textfield2.placeholder = "Write something"
                }
                let createAction = UIAlertAction(title: "Create", style: .default) { action in
                    
                    if let fileName = alertController.textFields?[0].text,
                       let fileContents = alertController.textFields?[1].text,
                       let data = fileContents.data(using: .utf8),
                       fileName != "" {
                        let newURL = self.url.appendingPathComponent(fileName)
                        self.fileManager.createFile(
                            atPath: newURL.path,
                            contents: data,
                            attributes: [:])
                        self.tableView.reloadData()
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertController.addAction(createAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
    }
    
    @IBAction func addNewImage(_ sender: Any) {
    }
    
    private func showErrorAlert(text: String) {
            let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
 
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfContents.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                let item = listOfContents[indexPath.row]
                
                var isFolder: ObjCBool = false
                fileManager.fileExists(atPath: item.path, isDirectory: &isFolder)
                if isFolder.boolValue {
                    cell.detailTextLabel?.text = "Folder"
           //         cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                } else {
                    cell.detailTextLabel?.text = ""
                }
                cell.textLabel?.text = item.lastPathComponent
                
                return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let item = listOfContents[indexPath.row]
            
            var isFolder: ObjCBool = false
            fileManager.fileExists(atPath: item.path, isDirectory: &isFolder)
            if isFolder.boolValue {
                let tvc = storyboard?.instantiateViewController(withIdentifier: "TableVC") as! MyFoldersTableViewController
                tvc.url = item
                navigationController?.pushViewController(tvc, animated: true)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
  
}

