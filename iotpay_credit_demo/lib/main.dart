import 'package:flutter/material.dart';
import 'package:iotpaycreditcard/config/IOTPayConfig.dart';
import 'package:iotpaycreditcard/generated/l10n.dart';
import 'package:iotpaycreditcard/iotpaycreditcard.dart';
import 'package:iotpaycreditcard/providers/dataProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  final controllerPaySecureID = TextEditingController();
  final controllerAddCardSecureID = TextEditingController();

  @override
  void dispose() {
    controllerPaySecureID.dispose();
    controllerAddCardSecureID.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _showMsg(String result) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: Text(
                result,
                style: TextStyle(fontSize: 15),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('IOTPay - Credit Demo'),
      ),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider<DataProvider>(
              create: (context) => DataProvider(),
            ),
          ],
          child:
              Consumer<DataProvider>(builder: (context, dataProvider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text("Style: Triple Lines"),
                        margin: EdgeInsets.all(25.0),
                      ),
                      Switch(
                        value: dataProvider.isTripleLine,
                        onChanged: (newvalue) {
                          dataProvider.isTripleLine = newvalue;
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  CardWidget(),
                  Container(
                    height: dataProvider.isTripleLine
                        ? MediaQuery.of(context).size.height -
                            120 -
                            (MediaQuery.of(context).size.width - 40) * 5 / 8
                        : MediaQuery.of(context).size.height - 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 2,
                          ),
                        ),
                        Form(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  ...[
                                    TextFormField(
                                      controller: controllerPaySecureID,
                                      autofocus: true,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Enter SecureID',
                                        labelText: 'Pay',
                                        suffix: ElevatedButton(
                                          child: const Text('SIMPLE PURCHASE'),
                                          onPressed: () {
                                            try {
                                              print("====== purchase pressed");
                                              dataProvider.sendRequest(
                                                  controllerPaySecureID.text,
                                                  IOTPayConfig.SimplePurchase,
                                                  (dynamic result) {
                                                print(
                                                    "=====call back result for simple purchase is :" +
                                                        result);
                                                _showMsg(result);
                                              });
                                            } catch (e) {
                                              print("Error:" + e.toString());
                                            }
                                          },
                                        ),
                                      ),
                                      onChanged: (value) {
                                        //_secureIdPay = value;
                                      },
                                    ),
                                    TextFormField(
                                      controller: controllerAddCardSecureID,
                                      autofocus: true,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Enter SecureID',
                                        labelText: 'Add card',
                                        suffix: ElevatedButton(
                                          child: const Text('ADD CARD'),
                                          onPressed: () {
                                            try {
                                              dataProvider.sendRequest(
                                                  controllerAddCardSecureID
                                                      .text,
                                                  IOTPayConfig.AddCard,
                                                  (String result) {
                                                print(
                                                    "=====call back result for add card is :" +
                                                        result);
                                                _showMsg(result);
                                              });
                                            } catch (e) {
                                              print("Error:" + e.toString());
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ].expand(
                                    (widget) => [
                                      widget,
                                      const SizedBox(
                                        height: 24,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
