//
//  DataModelUtils.swift
//  SmartAlertAction
//
//  Created by Paul Yuan on 2014-09-08.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

class DataModelUtils
{
    //convert a json object to a [String:[ClientModel]] object
    class func getClientsFromJSON(json:NSArray) -> [String:[ClientModel]]
    {
        var clients:[String:[ClientModel]] = [String:[ClientModel]]()
        for i in 0..<json.count {
            var data:NSDictionary = json[i] as NSDictionary
            
            var initial:String = data.valueForKey("initial") as String
            var list:[ClientModel] = [ClientModel]()
            if data.objectForKey("clients") != nil
            {
                var arr:NSArray = data.valueForKey("clients") as NSArray
                for j in 0..<arr.count {
                    var clientData:NSDictionary = arr[j] as NSDictionary
                    var client:ClientModel = self.getClientFromJSON(clientData)
                    list.append(client)
                }
            }
            clients[initial] = list
        }
        return clients
    }

    //convert a json object to a ClientModel object
    class func getClientFromJSON(json:NSDictionary) -> ClientModel
    {
        var id:Int = json.valueForKey("id") as Int
        var fName:String = json.valueForKey("fName") as String
        var lName:String = json.valueForKey("lName") as String
        var displayName:String = json.valueForKey("displayName") as String
        var clientSince:String = json.objectForKey("clientSince") != nil ? json.valueForKey("clientSince") as String : ""
        var birthDate:String = json.objectForKey("birthDate") != nil ? json.valueForKey("birthDate") as String : ""
        var phone:String = json.objectForKey("phone") != nil ? json.valueForKey("phone") as String : ""
        var email:String = json.objectForKey("email") != nil ? json.valueForKey("email") as String : ""
        var address:String = json.objectForKey("address") != nil ? json.valueForKey("address") as String : ""
        var mobile:String = json.objectForKey("mobile") != nil ? json.valueForKey("mobile") as String : ""
        var gender:GenderModel? = json.objectForKey("gender") != nil ? self.getGenderFromJSON(json.valueForKey("gender") as NSDictionary) : nil
      
        //  getRationaleFromJSON
        var rationaleModel:RationaleModel? = json.objectForKey("rationale") != nil ? self.getRationaleFromJSON(json.valueForKey("rationale") as NSDictionary) : nil
        
        var account:AccountModel? = json.objectForKey("account") != nil ? self.getAccountFromJSON(json.valueForKey("account") as NSDictionary) : nil

        
        var products:[PolicyModel] = [PolicyModel]()
        if json.objectForKey("products") != nil {
            var arr:NSArray = json.valueForKey("products") as NSArray
            for i in 0..<arr.count {
                var policyData:NSDictionary = arr[i] as NSDictionary
                var policy:PolicyModel = self.getPolicyFromJSON(policyData)
                products.append(policy)
            }
        }
        
        var settings:ClientSettingsModel? = json.objectForKey("settings") != nil ? self.getClientSettingsFromJSON(json.valueForKey("settings") as NSDictionary) : nil
        
        var notes:[AccountNoteModel] = [AccountNoteModel]()
        if json.objectForKey("notes") != nil {
            var arr:NSArray = json.valueForKey("notes") as NSArray
            for i in 0..<arr.count {
                var noteData:NSDictionary = arr[i] as NSDictionary
                var note:AccountNoteModel = self.getAccountNoteFromJSON(noteData)
                notes.append(note)
            }
        }
        
        var retentionRiskScore:Int = json.objectForKey("retentionRiskScore") != nil ? json.valueForKey("retentionRiskScore") as Int : -1
        
        
        
        var maritalStatus:ClientAttributeModel? = json.objectForKey("marital status") != nil ? self.getClientAttributeFromJSON(json.valueForKey("marital status") as NSDictionary) : nil
        var annualizedPremium:AnnualizedPremiumModel? = json.objectForKey("annualized premium") != nil ? self.getAnnualizedPremiumFromJSON(json.valueForKey("annualized premium") as NSDictionary) : nil
        
        
        var client:ClientModel = ClientModel(id: id, fName: fName, lName: lName, displayName: displayName, birthDateString: birthDate, phone: phone, email: email, address: address, mobile: mobile, gender: gender, account: account,products: products, settings: settings, notes: notes, retentionRiskScore: retentionRiskScore,rationaleModel: rationaleModel)

        client.clientSince = clientSince
        client.maritalStatus = maritalStatus
        client.annualizedPremium = annualizedPremium
        return client
    }
    
    //convert a json object to a AnnualizedPremiumModel object
    class func getAnnualizedPremiumFromJSON(json:NSDictionary) -> AnnualizedPremiumModel
    {
        var id:Int = json.valueForKey("id") as Int
        var type:NSDictionary = json.valueForKey("type") as NSDictionary
        var typeId:Int = type.valueForKey("id") as Int
        var code:String = type.valueForKey("code") as String
        var title:String = type.valueForKey("title") as String
        var value:String = type.valueForKey("value") as String
        
        var annualizedPremium:AnnualizedPremiumModel = AnnualizedPremiumModel(id: id, typeId: typeId, code: code, title: title, value: value)
        return annualizedPremium
    }
    
    //convert a json object to a ClientAttributeModel object
    class func getClientAttributeFromJSON(json:NSDictionary) -> ClientAttributeModel
    {
        var id:Int = json.valueForKey("id") as Int
        var title:String = json.valueForKey("title") as String
        
        var attribute:ClientAttributeModel = ClientAttributeModel(id: id, title: title)
        return attribute
    }
    
    //convert a json object to a AlertModel object
    class func getAlertFromJSON(json:NSDictionary) -> AlertModel
    {
        var id:Int = json.valueForKey("id") as Int
        var category:AlertCategoryModel = self.getAlertCategoryFromJSON(json.valueForKey("type") as NSDictionary,alertId: id)
        var message:String = json.valueForKey("message") as String
        var actions:[ActionModel] = self.getActionsFromJSON(json.valueForKey("actions") as NSArray)
        var isCompleted:Bool = json.valueForKey("isCompleted") as Bool
        var date:String = json.valueForKey("date") as String
        var time:String = json.valueForKey("time") as String
        var client:ClientModel? = json.objectForKey("client") != nil ? self.getClientFromJSON(json.valueForKey("client") as NSDictionary) : nil
        var policy:PolicyModel? = json.objectForKey("policy") != nil ? self.getPolicyFromJSON(json.valueForKey("policy") as NSDictionary) : nil
        var rank:Int? = json.objectForKey("rank") as Int?
        
        var alertRecommendation:RecommendationModel? = self.getRecommendationFromJSON(json.valueForKey("alertRecommendation") as NSDictionary?)
        var salesRecommendation:RecommendationModel? = self.getRecommendationFromJSON(json.valueForKey("salesRecommendation") as NSDictionary?)
        
        var policyPremium:AlertAttributeModel? = self.getAlertAttributeFromJSON(json.valueForKey("policyPremium") as NSDictionary?)
        var policiesInHousehold:AlertAttributeModel? = self.getAlertAttributeFromJSON(json.valueForKey("policiesInHousehold") as NSDictionary?)
        var yearsAsClient:AlertAttributeModel? = self.getAlertAttributeFromJSON(json.valueForKey("yearsAsClient") as NSDictionary?)
        
        var alert:AlertModel = AlertModel(id: id, category: category, message: message, actions: actions, dateString: date, timeString: time, isCompleted: isCompleted, client: client, policy: policy)
        alert.rank = rank
        alert.alertRecommendation = alertRecommendation
        alert.salesRecommendation = salesRecommendation
        alert.policyPremium = policyPremium
        alert.policiesInHousehold = policiesInHousehold
        alert.yearsAsClient = yearsAsClient
        return alert
    }
    
    //convert a json array to a AlertModel array
    class func getAllAlertFromJSON(jsonArray:NSArray) -> [AlertModel]
    {
        var alerts:[AlertModel] = [AlertModel]()
        for json in jsonArray {
        
            var id:Int = json.valueForKey("id") as Int
            var category:AlertCategoryModel = self.getAlertCategoryFromJSON(json.valueForKey("type") as NSDictionary,alertId: id)
            var message:String = json.valueForKey("message") as String
            var actions:[ActionModel] = self.getActionsFromJSON(json.valueForKey("actions") as NSArray)
            var isCompleted:Bool = json.valueForKey("isCompleted") as Bool
            var date:String = json.valueForKey("date") as String
            var time:String = json.valueForKey("time") as String
            var client:ClientModel? = json.objectForKey("client") != nil ? self.getClientFromJSON(json.valueForKey("client") as NSDictionary) : nil
            var policy:PolicyModel? = json.objectForKey("policy") != nil ? self.getPolicyFromJSON(json.valueForKey("policy") as NSDictionary) : nil
            var rank:Int? = json.objectForKey("rank") as Int?
            
            var alertRecommendation:RecommendationModel? = self.getRecommendationFromJSON(json.valueForKey("alertRecommendation") as NSDictionary?)
            var salesRecommendation:RecommendationModel? = self.getRecommendationFromJSON(json.valueForKey("salesRecommendation") as NSDictionary?)
            
            var policyPremium:AlertAttributeModel? = self.getAlertAttributeFromJSON(json.valueForKey("policyPremium") as NSDictionary?)
            var policiesInHousehold:AlertAttributeModel? = self.getAlertAttributeFromJSON(json.valueForKey("policiesInHousehold") as NSDictionary?)
            var yearsAsClient:AlertAttributeModel? = self.getAlertAttributeFromJSON(json.valueForKey("yearsAsClient") as NSDictionary?)
            
            var alert:AlertModel = AlertModel(id: id, category: category, message: message, actions: actions, dateString: date, timeString: time, isCompleted: isCompleted, client: client, policy: policy)
            alert.rank = rank
            alert.alertRecommendation = alertRecommendation
            alert.salesRecommendation = salesRecommendation
            alert.policyPremium = policyPremium
            alert.policiesInHousehold = policiesInHousehold
            alert.yearsAsClient = yearsAsClient
            
            alerts.append(alert)
        }

        return alerts
    }
    
    //convert a json object to a RecommendationModel object
    class func getRecommendationFromJSON(json:NSDictionary?) -> RecommendationModel?
    {
        if json == nil {
            return nil
        }
        
        var title:String = json!.valueForKey("title") as String
        var detail:String = json!.valueForKey("detail") as String
        
        var recommendation:RecommendationModel = RecommendationModel(title: title, detail: detail)
        return recommendation
    }
    
    //convert a json object to a AlertAttributeModel object
    class func getAlertAttributeFromJSON(json:NSDictionary?) -> AlertAttributeModel?
    {
        if json == nil {
            return nil
        }
        
        var title:String = json!.valueForKey("title") as String
        var value:String = ""
        if let v = json!.valueForKey("value") as? Int {
            value = String(v)
        } else if let v = json!.valueForKey("value") as? String {
            value = v
        }
        
        var attribute:AlertAttributeModel = AlertAttributeModel(title: title, value: value)
        return attribute
    }
    
    //convert a json object to a [String:[AgentModel]] object
    class func getAgentsFromJSON(json:NSArray) -> [String:[AgentModel]]
    {
        var agents:[String:[AgentModel]] = [String:[AgentModel]]()
        for i in 0..<json.count {
            var data:NSDictionary = json[i] as NSDictionary
            
            var initial:String = data.valueForKey("initial") as String
            var list:[AgentModel] = [AgentModel]()
            
            if data.objectForKey("agents") != nil
            {
                var arr:NSArray = data.valueForKey("agents") as NSArray
                for j in 0..<arr.count {
                    var agentData:NSDictionary = arr[j] as NSDictionary
                    var agent:AgentModel = self.getAgentFromJSON(agentData)
                    list.append(agent)
                }
            }
            agents[initial] = list
        }
        return agents
    }
    
    //convert a json object to a [String:[AgentModel]] object
    class func getAllAgentsFromJSON(json:NSArray) -> [AgentModel]
    {
        var agents:[AgentModel] = [AgentModel]()
        for i in 0..<json.count {
            var data:NSDictionary = json[i] as NSDictionary
            
            if data.objectForKey("agents") != nil
            {
                var arr:NSArray = data.valueForKey("agents") as NSArray
                for j in 0..<arr.count {
                    var agentData:NSDictionary = arr[j] as NSDictionary
                    var agent:AgentModel = self.getAgentFromJSON(agentData)
                    agents.append(agent)
                }
            }
        }
        
        //sort agents alphabetically
        agents = self.sortAgents(agents)
        
        return agents
    }
    
    //convert a json object to a [String:[AgentModel]] object from "all_agents.json"
    class func getAllAgentsFromJSON2(json:NSArray) -> [String:[AgentModel]]
    {
        //create agent models from json
        var sortedAgents:[AgentModel] = [AgentModel]()
        for i in 0..<json.count
        {
            let data:NSDictionary = json[i] as NSDictionary
            let agent:AgentModel = self.getAgentFromJSON(data)
            sortedAgents.append(agent)
        }
        
        //sort array of agent models based on name
        sortedAgents = self.sortAgents(sortedAgents)
        
        //create all letters in collection, key should be in lowercase
        var agents:[String:[AgentModel]] = [String:[AgentModel]]()
        for i in 0..<Constants.ALPHABETS.count
        {
            let letter:String = Constants.ALPHABETS[i].lowercaseString
            agents[letter] = [AgentModel]()
        }
        
        //sort agents into appropriate letter
        for i in 0..<sortedAgents.count
        {
            let agent:AgentModel = sortedAgents[i]
            let lname:NSString = agent.lName as NSString
            let letter = lname.substringToIndex(1).lowercaseString
            agents[letter]!.append(agent)
        }
        
        return agents
    }
    
    //convert a json object to a AgentModel object
    class func getAgentFromJSON(json:NSDictionary!) -> AgentModel!
    {
        if json == nil
        {
            return nil
        }
        
        var id:Int = json.valueForKey("id") as Int
        var fName:String = json.valueForKey("fName") as String
        var lName:String = json.valueForKey("lName") as String
        var displayName:String = json.valueForKey("displayName") as String
        var imageName:String = json.valueForKey("imageName") as String
        
        var delegates:[AgentModel] = [AgentModel]()
        if json.objectForKey("delegates") != nil
        {
            var arr:NSArray = json.valueForKey("delegates") as NSArray
            for i in 0..<arr.count {
                var data:NSDictionary = arr[i] as NSDictionary
                var delegate:AgentModel = self.getAgentFromJSON(data)
                delegates.append(delegate)
            }
        }
        
        var settings:AlertSettingsModel?
        if json.objectForKey("alertSettings") != nil {
            settings = self.getAgentAlertSettingsFromJSON(json.valueForKey("alertSettings") as NSDictionary)
        }
        
        var book:AgentBookModel?
        if json.objectForKey("book") != nil {
            book = self.getAgentBookFromJSON(json.valueForKey("book") as NSDictionary)
        }
        
        var alerts:[AlertModel] = [AlertModel]()
        if json.objectForKey("alerts") != nil {
            
        }
        
        var agent:AgentModel = AgentModel(id: id, fName: fName, lName: lName, displayName: displayName, imageName: imageName,delegates: delegates, alertSettings: settings, book: book, alerts: alerts)
        return agent
    }
    
    //convert a json object to a AgentBookModel object
    class func getAgentBookFromJSON(json:NSDictionary) -> AgentBookModel
    {
        var alertToActionRate:Float = json.valueForKey("alertToActionRate") as Float
        var alertsPerDay:Int = json.valueForKey("alertsPerDay") as Int
        var mostActiveAgent:Int = json.valueForKey("mostActiveAgent") as Int
        
        var taskTypes:[AgentBookTaskTypeModel] = [AgentBookTaskTypeModel]()
        var arr:NSArray = json.valueForKey("taskTypes") as NSArray
        for i in 0..<arr.count {
            var data:NSDictionary = arr[i] as NSDictionary
            var taskType:AgentBookTaskTypeModel = self.getAgentBookTaskTypeFromJSON(data)
            taskTypes.append(taskType)
        }
        
        var productTypes:[AgentBookProductTypeModel] = [AgentBookProductTypeModel]()
        arr = json.valueForKey("productTypes") as NSArray
        for i in 0..<arr.count {
            var data:NSDictionary = arr[i] as NSDictionary
            var productType:AgentBookProductTypeModel = self.getAgentBookProductTypeFromJSON(data)
            productTypes.append(productType)
        }
        
        var book:AgentBookModel = AgentBookModel(alertToActionRate: alertToActionRate, alertsPerDay: alertsPerDay, mostActiveAgent: mostActiveAgent, taskTypes: taskTypes, productTypes: productTypes)
        return book
    }
    
    //convert a json object to a AgentBookTaskTypeModel object
    class func getAgentBookTaskTypeFromJSON(json:NSDictionary) -> AgentBookTaskTypeModel
    {
        var id:Int = json.valueForKey("id") as Int
        var title:String = json.valueForKey("title") as String
        var pct:Float = json.valueForKey("pct") as Float
        var task:AgentBookTaskTypeModel = AgentBookTaskTypeModel(id: id, title: title, pct: pct)
        return task
    }
    
    //convert a json object to a AgentBookProductTypeModel object
    class func getAgentBookProductTypeFromJSON(json:NSDictionary) -> AgentBookProductTypeModel
    {
        var id:Int = json.valueForKey("id") as Int
        var title:String = json.valueForKey("title") as String
        var value:Float = json.valueForKey("value") as Float
        var numAccounts:Int = json.valueForKey("numAccounts") as Int
        var type:AgentBookProductTypeModel = AgentBookProductTypeModel(id: id, title: title, value: value, numAccounts: numAccounts)
        return type
    }
    
    //convert a json object to a AlertSettingsModel object
    class func getAgentAlertSettingsFromJSON(json:NSDictionary) -> AlertSettingsModel
    {
        var allowNotification:Bool = json.valueForKey("allowNotification") as Bool
        var showInNotificationCenter:Bool = json.valueForKey("showInNotificationCenter") as Bool
        var notificationSoundId:Int = json.valueForKey("notificationSoundId") as Int
        var badgeAppIcon:Bool = json.valueForKey("badgeAppIcon") as Bool
        var showOnLockScreen:Bool = json.valueForKey("showOnLockScreen") as Bool
        var showActNowAlerts:Bool = json.valueForKey("showActNowAlerts") as Bool
        var showFollowUpAlerts:Bool = json.valueForKey("showFollowUpAlerts") as Bool
        var repeatAlerts:Bool = json.valueForKey("repeatAlerts") as Bool
        var settings:AlertSettingsModel = AlertSettingsModel(allowNotification: allowNotification, showInNotificationCenter: showInNotificationCenter, notificationSoundId: notificationSoundId, badgeAppIcon: badgeAppIcon, showOnLockScreen: showOnLockScreen, showActNowAlerts: showActNowAlerts, showFollowUpAlerts: showFollowUpAlerts, repeatAlerts: repeatAlerts)
        return settings
    }
    
    //convert a json object to a AccountNoteModel object
    class func getAccountNoteFromJSON(json:NSDictionary) -> AccountNoteModel
    {
        var id:Int = json.valueForKey("id") as Int
        var dateString:String = json.valueForKey("date") as String
        var timeString:String = json.valueForKey("time") as String
        var text:String = json.valueForKey("text") as String
        var author:AgentModel = self.getAgentFromJSON(json.valueForKey("author") as NSDictionary)
        var note:AccountNoteModel = AccountNoteModel(id: id, dateString: dateString, timeString: timeString, text: text, author: author)
        return note
    }
    
    //convert a json object to a ClientSettingsModel object
    class func getClientSettingsFromJSON(json:NSDictionary) -> ClientSettingsModel
    {
        var showAlert:Bool = json.objectForKey("showAlert") != nil ? json.valueForKey("showAlert") as Bool : false
        var settings:ClientSettingsModel = ClientSettingsModel(showAlert: showAlert)
        return settings
    }
    
    //convert a json object to a PolicyModel object
    class func getPolicyFromJSON(json:NSDictionary) -> PolicyModel
    {
        var id:Int = json.valueForKey("id") as Int
        var policyId:String = json.valueForKey("policyId") as String
        var type:PolicyTypeModel = self.getPolicyTypeFromJSON(json.valueForKey("type") as NSDictionary)
        var details:[PolicyDetailsGroupModel] = json.objectForKey("details") != nil ? self.getPolicyDetailsFromJSON(json.valueForKey("details") as NSArray) : [PolicyDetailsGroupModel]()
        
        var policy:PolicyModel = PolicyModel(id: id, policyId: policyId, type: type, details: details)
        return policy
    }
    
    //convert a json object to a collection of PolicyDetailsGroupModel objects
    class func getPolicyDetailsFromJSON(json:NSArray) -> [PolicyDetailsGroupModel]
    {
        var details:[PolicyDetailsGroupModel] = [PolicyDetailsGroupModel]()
        for i in 0..<json.count
        {
            var groupData:NSDictionary = json[i] as NSDictionary
            var title:String = groupData.valueForKey("title") as String
            var twoColumns:Bool = groupData.valueForKey("twoColumns") as Bool
            var itemsData:NSArray = groupData.valueForKey("items") as NSArray
            var items:[PolicyDetailsItemModel] = [PolicyDetailsItemModel]()
            
            for j in 0..<itemsData.count {
                var itemData:NSDictionary = itemsData[j] as NSDictionary
                var name:String = itemData.valueForKey("name") as String
                var value:String = itemData.valueForKey("value") as String
                var iPadOnly:Bool? = itemData.valueForKey("iPadOnly") as Bool?
                iPadOnly = iPadOnly == nil ? false : iPadOnly
                var item:PolicyDetailsItemModel = PolicyDetailsItemModel(name: name, value: value, iPadOnly: iPadOnly!)
                items.append(item)
            }
            
            var group:PolicyDetailsGroupModel = PolicyDetailsGroupModel(title: title, items: items, twoColumns: twoColumns)
            details.append(group)
        }
        return details
    }
    
    //convert a json object to a PolicyInsuredClientModel object
    class func getPolicyInsuredClientFromJSON(json:NSDictionary) -> PolicyInsuredClientModel
    {
        var client:ClientModel = self.getClientFromJSON(json.valueForKey("client") as NSDictionary)
        
        var types:[PolicyInsuredTypeModel] = [PolicyInsuredTypeModel]()
        var arr:NSArray = json.valueForKey("insuredTypes") as NSArray
        for i in 0..<arr.count {
            var data:NSDictionary = arr[i] as NSDictionary
            var type:PolicyInsuredTypeModel = self.getPolicyInsuredTypeFromJSON(data)
            types.append(type)
        }
        
        var insuredClient:PolicyInsuredClientModel = PolicyInsuredClientModel(client: client, insuredTypes: types)
        return insuredClient
    }
    
    //convert a json object to a PolicyInsuredTypeModel object
    class func getPolicyInsuredTypeFromJSON(json:NSDictionary) -> PolicyInsuredTypeModel
    {
        var id:Int = json.valueForKey("id") as Int
        var title:String = json.valueForKey("title") as String
        var type:PolicyInsuredTypeModel = PolicyInsuredTypeModel(id: id, title: title)
        return type
    }
    
    //convert a json object to a UnderWritingClassModel object
    class func getUnderWritingClassFromJSON(json:NSDictionary) -> UnderWritingClassModel
    {
        var id:Int = json.valueForKey("id") as Int
        var title:String = json.valueForKey("title") as String
        var underWritingClass:UnderWritingClassModel = UnderWritingClassModel(id: id, title: title)
        return underWritingClass
    }
    
    //convert a json object to a USStateModel object
    class func getUSStateFromJSON(json:NSDictionary) -> USStateModel
    {
        var id:Int = json.valueForKey("id") as Int
        var fullName:String = json.valueForKey("fullName") as String
        var state:USStateModel = USStateModel(id: id, fullName: fullName)
        return state
    }
    
    //convert a json object to a PolicyCompanyModel object
    class func getPolicyCompanyFromJSON(json:NSDictionary) -> PolicyCompanyModel
    {
        var id:Int = json.valueForKey("id") as Int
        var name:String = json.valueForKey("name") as String
        var company:PolicyCompanyModel = PolicyCompanyModel(id: id, name: name)
        return company
    }
    
    //convert a json object to a PolicyStatusModel object
    class func getPolicyStatusFromJSON(json:NSDictionary) -> PolicyStatusModel
    {
        var id:Int = json.valueForKey("id") as Int
        var title:String = json.valueForKey("title") as String
        var status:PolicyStatusModel = PolicyStatusModel(id: id, title: title)
        return status
    }
    
    //convert a json object to a PolicyTypeModel object
    class func getPolicyTypeFromJSON(json:NSDictionary) -> PolicyTypeModel
    {
        var id:Int = json.valueForKey("id") as Int
        var code:String = json.valueForKey("code") as String
        var title:String = json.valueForKey("title") as String
        var subTitle:String = json.valueForKey("subTitle") as String
        var type:PolicyTypeModel = PolicyTypeModel(id: id, code: code, title: title, subTitle: subTitle)
        return type
    }
    
    //convert a json obejct to a PolicyBillingModel object
    class func getPolicyBillingFromJSON(json:NSDictionary) -> PolicyBillingModel
    {
        var id:Int = json.valueForKey("id") as Int
        var billingDate:String = json.valueForKey("billingDate") as String
        var amount:Float = json.valueForKey("amount") as Float
        var dueDate:String = json.valueForKey("dueDate") as String
        var payment:Float = json.valueForKey("payment") as Float
        var receivedDate:String = json.valueForKey("receivedDate") as String
        var billing:PolicyBillingModel = PolicyBillingModel(id: id, billingDate: billingDate, amount: amount, dueDate: dueDate, payment: payment, receivedDate: receivedDate)
        return billing
    }
    
    //convert a json object to a GenderModel object
    class func getGenderFromJSON(json:NSDictionary) -> GenderModel
    {
        var id:Int = json.valueForKey("id") as Int
        var title:String = json.valueForKey("title") as String
        var gender:GenderModel = GenderModel(id: id, title: title)
        return gender
    }
    
    
    //convert a json object to a RationaleModel object
    class func getRationaleFromJSON(json:NSDictionary) -> RationaleModel
    {
        var id:Int = json.valueForKey("id") as Int
        var text:String = json.valueForKey("text") as String
        var rationaleModel:RationaleModel = RationaleModel(id: id, text: text)
        return rationaleModel
    }
    
    //convert a json object to a AccountModel object
    class func getAccountFromJSON(json:NSDictionary) -> AccountModel
    {
        var amountDue:Double = json.valueForKey("amountDue") as Double
        var remainingBalance:Double = json.valueForKey("remainingBalance") as Double
        var currency:String = json.valueForKey("currency") as String
        var account:AccountModel = AccountModel(amountDue: amountDue, remainingBalance: remainingBalance, currency: currency)
        return account
    }
    //convert a json object to a AlertCategoryModel object
    class func getAlertCategoryFromJSON(json:NSDictionary,alertId:Int) -> AlertCategoryModel
    {
        var id:Int = json.valueForKey("id") as Int
        var code:String = json.valueForKey("code") as String
        var title:String = json.valueForKey("title") as String
        var subTitle:String = json.valueForKey("subTitle") as String
        var policyType:String? = json.valueForKey("policyType") as String?
        
        var note = ""
        //Check from DB any note was added previously for this alert
        let alertAdapter = CommonFunc.sharedInstanceAlert as AlertAdapter
        var alert:Alert!
        alert = alertAdapter.getAlertDetailStatus(alertId, categoryId: id, status:"NotCompleted")
        if let alertObj = alert {
            //If it comes here, that means alert with alertId exists in DB and has some notes
            note = alert.finishNote
        }
        else {
            note = ""
        }
        
        var category:AlertCategoryModel = AlertCategoryModel(id: id, code: code, title: title, subTitle: subTitle, policyType: policyType, note: note, settings: nil)
        return category
    }
    
    //convert a json array to a collection of ActionModel objects
    class func getActionsFromJSON(json:NSArray) -> [ActionModel]
    {
        var actions:[ActionModel] = [ActionModel]()
        for i in 0..<json.count
        {
            var data:NSDictionary = json[i] as NSDictionary
            var id:Int = data.valueForKey("id") as Int
            var title:String = data.valueForKey("title") as String
            var platforms:[Int]? = data.valueForKey("platforms") as [Int]?
            var action:ActionModel = ActionModel(id: id, title: title, platforms: platforms)
            actions.append(action)
        }
        return actions
    }
    
    //Get
    class func getDelegateArray(json:NSDictionary) -> [DelegateModel] {
        
        var delegates:[DelegateModel] = [DelegateModel]()
        
        var jsonArray = json.valueForKey("delegate") as NSArray
        for i in 0..<jsonArray.count {
            var delegate:DelegateModel = getDelegateFromJSON(jsonArray[i] as NSDictionary)
            delegates.append(delegate)
            
        }
        return delegates
    }
    class func getDelegateFromJSON(json:NSDictionary) -> DelegateModel
    {
        var name:String = json.valueForKey("name") as String
        var details:[DelegateDetailModel] = json.objectForKey("detail") != nil ? self.getDelegateDetailsFromJSON(json.valueForKey("detail") as NSArray) : [DelegateDetailModel]()
        
        var delegate:DelegateModel = DelegateModel(name: name, details: details)
        return delegate
    }
    
    class func getDelegateDetailsFromJSON(json:NSArray) -> [DelegateDetailModel]
    {
        var details:[DelegateDetailModel] = [DelegateDetailModel]()
        for i in 0..<json.count
        {
            var groupData:NSDictionary = json[i] as NSDictionary
            var desc:String = groupData.valueForKey("desc") as String
            var clientName:String = groupData.valueForKey("clientName") as String
            var delegateAgent:String = groupData.valueForKey("delegateAgent") as String
            var rank:Int = groupData.valueForKey("rank") as Int
            
            
            var group:DelegateDetailModel = DelegateDetailModel(desc: desc, clientName: clientName, delegateAgent: delegateAgent, rank: rank)
            details.append(group)
        }
        return details
    }
    
    //convert a json object to a [String:[AgentModel]] object
    class func getFinishTitlesFromJSON(json:NSArray) -> [FinishTitlesModel]
    {
        var titles:[FinishTitlesModel] = [FinishTitlesModel]()
        for i in 0..<json.count {
            var data:NSDictionary = json[i] as NSDictionary

            var title:String = data.valueForKey("title") as String
            var level:Int = data.valueForKey("level") as Int
            
            var finishTitle:FinishTitlesModel = FinishTitlesModel(title: title, level: level)
            titles.append(finishTitle)
        }
        return titles
    }

    //convert a json object to a [AlertCategoryModel] object
    class func getCategoriesFromJSON(jsonArray:NSArray) -> [AlertCategoryModel]
    {
        var categories:[AlertCategoryModel] = []
        for i in 0..<jsonArray.count {
            var category:AlertCategoryModel = getCategoryFromJSON(jsonArray[i] as NSDictionary)
            categories.append(category)
        }
        return categories
    }

    //convert a json object to a CategorySettingsModel object
    class func getCategorySettingsFromJSON(json:NSDictionary) -> CategorySettingsModel
    {
        var receiveNotification:Bool = json.objectForKey("receiveNotification") != nil ? json.valueForKey("receiveNotification") as Bool : true
        var settings:CategorySettingsModel = CategorySettingsModel(receiveNotification: receiveNotification)
        return settings
    }

    //convert a json object to a AlertCategoryModel object
    class func getCategoryFromJSON(json:NSDictionary) -> AlertCategoryModel
    {
        var id:Int = json.valueForKey("id") as Int
        var code:String = json.valueForKey("code") as String
        var title:String = json.valueForKey("title") as String
        var subTitle:String = json.valueForKey("subTitle") as String
        var policyType:String? = json.valueForKey("policyType") as String?
        
        var settings:CategorySettingsModel? = json.objectForKey("settings") != nil ? self.getCategorySettingsFromJSON(json.valueForKey("settings") as NSDictionary) : nil

        //Check from DB receive was swith off previously for this category
        let categoryAdapter = CommonFunc.sharedInstanceCategory as CategoryAdapter
        var category:Category! = categoryAdapter.getCategoryDetail(id)
        if category != nil {
            if settings == nil {
                settings = CategorySettingsModel(receiveNotification: true)
            }
            settings?.receiveNotification = category.receiveNotification.boolValue
        }
        
        var categoryModel:AlertCategoryModel = AlertCategoryModel(id: id, code: code, title: title, subTitle: subTitle, policyType: policyType, note: nil, settings: settings)
        return categoryModel
    }
    
    //sort a list of agents based on last names alphabetically than first names, don't modify the original array
    class func sortAgents(agents:[AgentModel]) -> [AgentModel]
    {
        var copy:[AgentModel] = [AgentModel]()
        for agent in agents {
            copy.append(agent)
        }
        
        copy.sort({
            let lname1:String = ($0 as AgentModel).lName
            let lname2:String = ($1 as AgentModel).lName
            if lname1.compare(lname2) == NSComparisonResult.OrderedSame
            {
                let fname1:String = ($0 as AgentModel).fName
                let fname2:String = ($1 as AgentModel).fName
                return fname1.compare(fname2) == NSComparisonResult.OrderedAscending
            }
            
            return lname1.compare(lname2) == NSComparisonResult.OrderedAscending
        })
        
        return copy
    }
    
}