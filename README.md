# ReceetPOSAddOn

ReceetPOSAddOn is an easy to integrate with add-on which can be installed on any Point of Sale system in the world that runs on iOS and gives it the ability to send digital receipts to customers with minimum integration efforts.

## Installation

### CocoaPods
Check out Get Started tab on [cocoapods.org](https://cocoapods.org). 
To use ReceetPOSAddOn in your iOS Point of Sale project add the following line to your 'Podfile' to your project

```
  use_frameworks!
  pod 'ReceetPOSAddOn'
```
Then run:
```
pod install
```
## Getting Started
First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift
import ReceetPOSAddOn
```
You can turn on or turn off the integration by setting the 'isEnabled' flag 

```swift
ReceetPOS.shared.isEnabled = true // to turn it on
```
You can get Point of Sale Id and virtual beacon Id using 'posID' and 'virtualBeaconID' from the shared instance of ReceetPOS class
```swift
if let posID = ReceetPOS.shared.posID {
            posIDLabel.text = String(posID)
        }
beaconIDLabel.text = ReceetPOS.shared.virtualBeaconID
```

You can always check the status of Receet Point of Sale manager using 'isEnabled' flag

## Example Project
You can check the example project in this repository, download the project then run pod install from the project's directory.

## Step-by-step guide to send digital orders
To send a digital receipt you prepare the purchase order as the following format, you can add any supported fields you want. Check the supported fields in the tables below:
1- you prepare the order details with the following parameters as a dictionary :

```swift
let orderDetails : [String:Any] = [
            "externalId" : "T004-126572",
            "subTotalProduct": 120.0,
            "totalProduct" : 100.0,
            "description" : "Purchase from branch #4",
            "currency" : "USD",
            "timePlaced": Date(),
            "createdBy" : "Amjad",
            "adjustmentDescription":"16% discount"
        ]
```

| Parameter Name  | Type | Description | Required |
| ------------- | ------------- | ------------- | ------------- |
| externalId  | String  | POS Generated Order ID  | Yes  |
| totalProduct  | Double  | Order Total amount  | Yes  |
| totalTax  | Double  | Order Tax amount  | No  |
| totalShipping  | Double | Total shipping amount  | No  |
| totalTaxShipping  | Double  | Shipping tax amount  | No  |
| subTotalProduct  | Double  | Sub-total amount (before tax and discount)  | Yes |
| totalAdjustment  | Double  | Total amount of discounts applied on order  | No  |
| adjustmentDescription  | String  | Order Level Discout description (e.g. 10% Discount) | No |
| description  | String  | Short description of order, if needed  | No |
| currency  | String  | Currency used (USD, ILS, etc....) see [supported currencies](#Supported-currencies) section for more info| Yes |
| timePlaced  | Date | Time and date of when the order was placed | Yes |
| createdBy  | String  | Identifier for the cashier (name or ID)  | No |
| topTextArea  | String  | Free text area shows at the top of the receipt. Can take multiple values (pipe separated, example below). Each value show on a new line  | No |
| bottomTextArea  | String  | value pair will show at the bottom of the receipt. Can take multiple values (pipe separated, example below). Each value show on a new line  | No |


2- you prepare the order items as an array of the purchased items as an array of dictionaries where each dictionary represents an item: 

```swift
        let orderItems : [[String:Any]] = [
            [
                "price" : 60.0,
                "quantity" : 1,
                "description": "Blue Jeans",
                "totalProduct" : 60.0,
                "taxAmount" : 0.0,
                "shipCharge" : 0.0,
                "shipTaxAmount" : 0.0,
                "totalAdjustment" : 0.0,
                "adjustmentDescription" : ""
            ],
            [
                "price" : 30.0,
                "quantity" : 2,
                "description": "Black Shirt XL",
                "totalProduct" : 60.0,
                "taxAmount" : 0.0,
                "shipCharge" : 0.0,
                "shipTaxAmount" : 0.0,
                "totalAdjustment" : 0.0,
                "adjustmentDescription" : ""
            ]
        ]
```
| Parameter Name  | Type | Description | Required |
| ------------- | ------------- | ------------- | ------------- |
| price  | Double  | List item price  | Yes  |
| quantity  | Int  | Quantity of list item | Yes  |
| description  | String  | List item product description, will be shown on digital receipt | Yes  |
| totalProduct  | Double | Total product price (Price X Qty)  | Yes  |
| taxAmount  | Double  | Tax Amount  | No  |
| shipCharge  | Double  | Amount of shipping, if any  | No |
| shipTaxAmount  | Double  | Tax Amount of shipping, if any  | No  |
| totalAdjustment  | Double  | Discount amount of list item | No |
| adjustmentDescription  | String  | Item Level Discout description (e.g. 10% Discount)  | No |
| itemNumber  | String  | Item Number, barcode, etc.. | No |


3- you put all this informatin in a new dictionary in the following format with orderDetails,orderItems ready from the previous section
```swift
        let order : [String:Any] = [
            "media":"digital",
            "languageId":1,
            "order":orderDetails,
            "order_items":orderItems
        ]
```

| Parameter Name  | Type | Description | Required |
| ------------- | ------------- | ------------- | ------------- |
| media  | String  | The type of the receipt media. Values: Digital, DigitalAndPaper, Paper	  | Yes |
| languageId  | Int  | Language used. 1: English 2: Arabic  | Yes |
| order object (details above)  | Dictionary  | Contains order details  | Yes |
| billing_address ojbect (details below)  | Dictionary | Customer Address Information, will be shown in Billed To section on the receipt  | No |
| order_items object (details above)  | array of item object dictionary  | Array of order items  | Yes |

4- you send this dictionary to the Receet Point of Sale manager 

```swift
ReceetPOS.shared.sendDigitalOrder(order: order)// send the digital order To Receet POS
```


### Custom Text

topTextArea show on the top of the receipt. Example:

```
"topTextArea" : "Cash transaction"
```
bottomTextArea show at the bottom of the receipt, below Total. Example:
```
"bottomTextArea": "Paid: $ 100 | Change: $ 60.02 | Points from this sale: 20 | Total points: 100"
```

![](https://www.getreceet.com/docs/images/top-bottom-text-area.png)


### Billing Address Object (Optional)

| Parameter Name  | Type | Description | Required |
| ------------- | ------------- | ------------- | ------------- |
|addressType | String | U: User | Yes |
|memberId	| String |Loyalty Customer Member ID	|No|
|status	| String | Status of address. Value: A |Yes|
|isPrimary| Int	|Value: 1	|Yes|
|address1	| String |Address line 1	|Yes|
|address2	|String| Address line 2|	|No|
|address3	|String|Address line 3	|No|
|city	|String|City	|Yes|
|state	|String|State	|Yes|
|country	|String|Country	|Yes|
|zipCode	|String|Zip Code	|Yes|
|phone1	|String|Phone number 1	|Yes|
|phone2	|String|Phone number 2	|No|
|fax	|String|Fax Number	|No|
|email	|String|Email	|No|


## Supported currencies
The following currencies are supported in Receet system, send the symbol of the wanted currency with the order dictionary as described above.

|Currency|	Currency Symbol	 |Currency full name 
| ------------- | ------------- | ------------- |
|AFN|	؋	|Afghani|
|ALL|	Lek	|Lek|
|ANG|	ƒ	|Netherlands Antillean guilder|
|ARS|	$	|Argentine Peso|
|AUD|	$	|Australian Dollar|
|AWG|	ƒ	|Aruban Florin|
|AZN|	₼	|Azerbaijan Manat|
|BAM|	KM	|Convertible Mark|
|BBD|	$	|Barbados Dollar|
|BGN|	лв	|Bulgarian Lev|
|BMD|	$	|Bermudian Dollar|
|BND|	$	|Brunei Dollar|
|BOB|	$b	|boliviano|
|BRL|	R$	|Brazilian Real|
|BSD|	$	|Bahamian Dollar|
|BTC|	Ƀ	|Bitcoin|
|BWP|	P	|Pula|
|BYN|	Br	|Belarusian Ruble|
|BZD|	BZ$	|Belize Dollar|
|CAD|	$	|Canadian Dollar|
|CHF|	CHF	|Swiss Franc|
|CLP|	$	|Chilean Peso|
|CNY|	¥	|Yuan Renminbi|
|COP|	$	|Colombian Peso|
|CRC|	₡	|Costa Rican Colon|
|CUP|	₱	|Cuban Peso|
|CZK|	Kč	|Czech koruna (pl. koruny)|
|DKK|	kr	|Danish Krone|
|DOP|	RD$	|Dominican peso|
|EGP|	£	|Egyptian Pound|
|EUR|	€	|Euro|
|FJD|	$	|Fiji Dollar|
|FKP|	£	|Falkland Islands pound|
|GBP|	£	|pound sterling|
|GHS|	¢	|Ghana Cedi|
|GIP|	£	|Gibraltar Pound|
|GTQ|	Q	|Quetzal|
|GYD|	$	|Guyana Dollar|
|HKD|	$	|Hong Kong Dollar|
|HNL|	L	|Lempira|
|HRK|	kn	|Kuna|
|HUF|	Ft	|Forint|
|IDR|	Rp	|Rupiah|
|ILS|	₪	|New Israeli Sheqel|
|INR|	₹	|Indian Rupee|
|IRR|	﷼	|Iranian rial|
|ISK|	kr	|Iceland Krona|
|JMD|	J$	|Jamaican Dollar|
|JPY|	¥	|Yen|
|KGS|	лв	|Som|
|KHR|	៛	|Riel|
|KPW|	₩	|North Korean won (inv.)|
|KRW|	₩	|South Korean won (inv.)|
|KYD|	$	|Cayman Islands dollar|
|KZT|	лв	|Tenge|
|LAK|	₭	|kip (inv.)|
|LBP|	£	|Lebanese Pound|
|LKR|	₨	|Sri Lanka Rupee|
|LRD|	$	|Liberian Dollar|
|MKD|	ден	|denar (inv.)|
|MNT|	₮	|Tugrik|
|MUR|	₨	|Mauritius Rupee|
|MXN|	$	|Mexican Peso|
|MYR|	RM	|Malaysian Ringgit|
|MZN|	MT	|Mozambique Metical|
|NAD|	$	|Namibia Dollar|
|NGN|	₦	|Naira|
|NIO|	C$	|Cordoba Oro|
|NOK|	kr	|Norwegian Krone|
|NPR|	₨	|Nepalese Rupee|
|NZD|	$	|New Zealand dollar|
|OMR|	﷼	|Rial Omani|
|PAB|	B/.	|Balboa|
|PEN|	S/.	|Sol|
|PHP|	₱	|Philippine peso|
|PKR|	₨	|Pakistan Rupee|
|PLN|	zł	|Zloty|
|PYG|	Gs	|Guarani|
|QAR|	﷼	|Qatari Rial|
|RON|	lei	|Romanian Leu|
|RSD|	Дин.|Serbian Dinar|
|RUB|	₽	|rouble|
|SAR|	﷼	|Saudi Riyal|
|SBD|	$	|Solomon Islands Dollar|
|SCR|	₨	|Seychelles Rupee|
|SEK|	kr	|Swedish Krona|
|SGD|	$	|Singapore Dollar|
|SHP|	£	|Saint Helena pound|
|SOS|	S	|Somali Shilling|
|SRD|	$	|Surinam Dollar|
|SVC|	$	|El Salvador Colon|
|SYP|	£	|Syrian pound|
|THB|	฿	|Baht|
|TRY|	₺	|Turkish Lira|
|TTD|	TT$	|Trinidad and Tobago Dollar|
|TWD|	NT$	|new Taiwan dollar|
|UAH|	₴	|Hryvnia|
|USD|	$	|US Dollar|
|UYU|	$U	|Peso Uruguayo|
|UZS|	лв	|Uzbekistan Sum|
|VND|	₫	|dong|
|XCD|	$	|East Caribbean Dollar|
|YER|	﷼	|Yemeni Rial|
|ZAR|	R	|Rand|
|NIS|	₪	|Israeli shekel|



## Built With

* [Starscream](https://github.com/daltoniam/Starscream) - The web socket library used
* [ReachabilitySwift](https://github.com/ashleymills/Reachability.swift)
* [lottie-ios](https://github.com/airbnb/lottie-ios) - The animation library

## Authors

* **Amjad Khalil** - *Initial work* - [Receet](https://github.com/receet)
