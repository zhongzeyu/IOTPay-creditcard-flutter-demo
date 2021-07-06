# IOTPay-flutter
###### IOTPay credit plugin for flutter
<br />    


IOTPayCreditCard is a flutter plugin called in merchant app to collect consumer's credit/debit card information.
<br /> 
[For the whole business picture please refer the '2.3 Event Flow and Options'](https://github.com/IOTPaySDK/IOTPay-iOS/blob/main/README.md)<br /> <br />
1 Embed a credit entry GUI into a ViewGroup to collect consumer’s credit/debit card information:
<br /> card number, holder name, expiry date, CVV/CVC
<br /> 
2 provide add card, payment methods
![alt text](https://github.com/zhongzeyu/IOTPay-creditcard-flutter-demo/blob/master/demo.png ) 
<br />      




## Step 1: Install 

(1) add iotpaycreditcard dependency in pubspec.yaml.

```java
   iotpaycreditcard: ^0.0.4
```
(2) make sure provider and flutter localization dependencies are added.

```java
  provider: ^5.0.0
  flutter_localizations:
    sdk: flutter
```



## Step 2: Setup Widgets

Import some packages.
```java
import 'package:flutter/material.dart';
import 'package:iotpaycreditcard/config/IOTPayConfig.dart';
import 'package:iotpaycreditcard/generated/l10n.dart';
import 'package:iotpaycreditcard/iotpaycreditcard.dart';
import 'package:iotpaycreditcard/providers/dataProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
```

Initial localizaion in MaterialApp
```java
runApp(MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: S.delegate.supportedLocales,
    home:...
```

Add provider DataProvider
```java
body: MultiProvider(
          providers: [
            ChangeNotifierProvider<DataProvider>(
              create: (context) => DataProvider(),
            ),
          ],
          child:
              Consumer<DataProvider>(builder: (context, dataProvider, child) {
            return ...
```

- creditCardStyle:
Select a style as triple lines form or single line form
```java
dataProvider.isTripleLine = true
```
![alt text](https://github.com/zhongzeyu/IOTPay-creditcard-flutter-demo/blob/master/triple.png ) 
```java
dataProvider.isTripleLine = false
```
![alt text](https://github.com/zhongzeyu/IOTPay-creditcard-flutter-demo/blob/master/single.png ) 


Embed the credit card widget in right place.

- Example:
```java
  CardWidget(),
```


## Step 3: Send the Request
pay or add card

- Example:

(2.1) pay:

 Make sure secureID for payment has been retrieved from context<br />
 [About the secureID please refer the '4 Temporary secureID'](https://github.com/IOTPaySDK/IOTPay-iOS/blob/main/README.md)<br /> 
```java
 dataProvider.sendRequest(
    PaySecureID,IOTPayConfig.SimplePurchase,(dynamic result) {


            //please process result in your own way, Ex: as following;
	    /*
	     if retCode == FAIL
	       go to failure page with retMsg,
	         Ex: order payment failed, reason: ....., please retry....
	     else if  retCode == SUCCESS
	        check retData.status
		  if status in(2,3)
		    go to success page,
		      Ex: Order payment successfull....
		  else
		     means order status is unknow, go to Order status Unknow page, and involve in 
		     the support team for order final result.
		       Ex: Order is processing, please call (xxx)xxx xxx for order[xxxxxxxxx] payment result.
	    */
        
      });
```

(2.2) Add card: binding the card to a consumer

  Make sure secureID for payment has been retrieved from context<br />
 [About the secureID please refer the '4 Temporary secureID'](https://github.com/IOTPaySDK/IOTPay-iOS/blob/main/README.md)<br /> 
```java
  dataProvider.sendRequest(
	AddCardSecureID,IOTPayConfig.AddCard,(String result) {

          //please process result in your own way, ex: showMsg("Payment Result:" + result);
        }
      });
```

## Step 4: Debug or Release
  an additional option is need as following: --no-sound-null-safety 
  - Example:
    Debug
```java
  flutter run  --no-sound-null-safety
```
    Release
```java
  flutter run --release  --no-sound-null-safety
```
...