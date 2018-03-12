//
//  CitiesTableViewController.swift
//  CitiesListing
//
//  Created by Rodrigo Bueno Tomiosso on 12/03/2018.
//  Copyright © 2018 mourodrigo. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var allCities = [City]()
    var filteredCities = [City]()

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
        filteredCities.removeAll()
        allCities.append(contentsOf: getCities(from: CitiesData.contentString))
    }
    
    func getCities(from jsonString:String) -> Array<City> {
        if let data: Data = jsonString.data(using: String.Encoding.utf8) as Data? {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                return self.parseJson(anyObj: jsonObject)
            } catch {
                print("json error: \(error.localizedDescription)")
            }
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

    func dataSource() -> Array<City> {
        return searchBar.text == "" ? allCities : filteredCities
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseidentifier") ??
            UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: UIFontDescriptor.FeatureKey.typeIdentifier.rawValue)
        
        let city = dataSource()[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country

        return cell
    }
    
    func applySearch(with text:String) {
        filteredCities = allCities.filter({ (city) -> Bool in
            city.name.lowercased().contains(text.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySearch(with: searchText)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
