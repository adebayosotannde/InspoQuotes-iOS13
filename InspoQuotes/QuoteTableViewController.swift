//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Adebayo on 09/18/2022
//  Copyright © 2021 Phone Village. All rights reserved.
//

import UIKit
import StoreKit //Used to implement in app purchases for virtual products.
class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver
{
    
    
    
    let productID = "com.adebayosotannde.InspoQuotes.PremiumQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        if isPurchased()
        {
            showPremiumQuotes()
        }

       
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isPurchased()
        {
            return quotesToShow.count
        }
        else
        {
            return quotesToShow.count + 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < quotesToShow.count
        {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 //Allows label to take up as many lines as is reqired.
            cell.textLabel?.textColor = UIColor.black

        }else
        {
            if isPurchased()
            {
                
            }
            else
            {
                cell.textLabel?.text = "Get More Quotes"
                cell.textLabel?.textColor = UIColor.blue
                cell.accessoryType = . disclosureIndicator
            }
            
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        if indexPath.row == quotesToShow.count
        {
            buyPremiumQuotes()
            print("Buy Quotes Clicked.")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - In-App Purchase Methods
    func buyPremiumQuotes()
    {
        //Check 1: Can user actually make a purchase?
       if  SKPaymentQueue.canMakePayments()
        {
           //USer can make payment.
           
           //Propmt the user to pay.
           let paymentRequest = SKMutablePayment()
           paymentRequest.productIdentifier = productID
           SKPaymentQueue.default().add(paymentRequest)
       }
        else
        {
           //User cannot make payment.
       }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        
    
        for transaction in transactions
        {
            if transaction.transactionState == .purchased
            {
                //User Payment was successful
                print("Transaction Successful")
                
                showPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transaction) //End the transaction
        
            }else if transaction.transactionState == .failed
            {
                //Payment Failed
                print("Transaction Failed")
                
                if let error = transaction.error
                {
                    let errorDescription = error.localizedDescription
                    
                        print("Transaction failed due to error \(errorDescription)")
                    
                }
                SKPaymentQueue.default().finishTransaction(transaction) //End the transaction
                
            }else if transaction.transactionState == .restored
            {
                //Restore User Purchase
                showPremiumQuotes()
                print("Transaction Restored")
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
                              }
    
    func showPremiumQuotes()
    {
        navigationItem.setRightBarButton(nil, animated: true)
        UserDefaults.standard.set(true, forKey: productID)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool
    {
        let purchasedStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchasedStatus
        {
            print("Previousley Purchased")
            return true
        }else
        {
            print("Never Purchased")
            return false
        }
    }
    
    
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem)
    {
        SKPaymentQueue.default().restoreCompletedTransactions() //Triggers SKpaymentQue Function
    }


}
