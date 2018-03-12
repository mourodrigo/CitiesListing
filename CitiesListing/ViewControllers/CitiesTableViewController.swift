//
//  CitiesTableViewController.swift
//  CitiesListing
//
//  Created by Rodrigo Bueno Tomiosso on 12/03/2018.
//  Copyright © 2018 mourodrigo. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {

    var allCities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllCities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        allCities.removeAll()
    }

    // MARK: - Table view data source
    func loadAllCities() {
        // this structure provides the possibility to continuously add cities from more json files, for instance from a paginated API
        allCities.removeAll()
        allCities.append(contentsOf: getCities(from: CitiesData.contentString))
    }
    
    func getCities(from jsonString:String) -> Array<City> {
        if let data: Data = jsonString.data(using: String.Encoding.utf8) as Data? {
            let jsonObject = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return self.parseJson(anyObj: jsonObject)
        }
        return Array<City>()
    }
    
    func parseJson(anyObj:Any) -> Array<City> {
        var list:Array<City> = []
        if  anyObj is Array<AnyObject> {
            for json in anyObj as! Array<AnyObject>{
                guard let coord = json["coord"] as? Dictionary<AnyHashable,Double> else { break }
                let newCity = City(id: (json["_id"]  as AnyObject? as? Int) ?? 0,
                                     name: (json["name"] as AnyObject? as? String) ?? "",
                                     country: (json["country"] as AnyObject? as? String) ?? "",
                                     latitude: coord["lat"] ?? 0.00,
                                     longitude: coord["lon"] ?? 0.00
                )
                list.append(newCity)
            }
        }
        return list
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
