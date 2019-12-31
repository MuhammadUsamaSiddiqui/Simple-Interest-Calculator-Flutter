import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simple Interest Calculator App",
      home: SIForm(),
      theme: ThemeData(
          primaryColor: Colors.indigo,
          accentColor: Colors.indigoAccent,
          brightness: Brightness.dark)));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();
  var displayResult = '';
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  var _currentItemSelected = '';
  var _minimumPadding = 5.0;

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principleController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text("Simple Interest Calculator")),
        body: Form(
            key: _formKey,
            // this key is use to identify our form and use to get the status of form
            //margin: EdgeInsets.all(_minimumPadding * 2),
            child: Padding(
                padding: EdgeInsets.all(_minimumPadding * 2),
                child: ListView(children: <Widget>[
                  getImageAsset(),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: principleController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please Enter Principal Amount';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Principal",
                              labelStyle: textStyle,
                              hintText: "Enter Principal e.g. 12000",
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))))),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: TextFormField(
                        style: textStyle,
                        controller: roiController,
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please Enter Rate Of Interest';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Rate of Interest",
                            labelStyle: textStyle,
                            hintText: "In Percent",
                            errorStyle: TextStyle(
                                color: Colors.yellowAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: textStyle,
                              controller: termController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Term Amount';
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: "Term",
                                  labelStyle: textStyle,
                                  hintText: "Time in Years",
                                  errorStyle: TextStyle(
                                      color: Colors.yellowAccent, fontSize: 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0))),
                            )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                                items:
                                _currencies.map((String dropDownMenuItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownMenuItem,
                                    child: Text(dropDownMenuItem),
                                  );
                                }).toList(),
                                value: _currentItemSelected,
                                onChanged: (String newSelectedValue) {
                                  _onDropDownItemSelected(newSelectedValue);
                                }))
                      ])),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              textColor: Theme.of(context).primaryColorDark,
                              child: Text("Calculate", textScaleFactor: 1.5),
                              onPressed: () {
                                setState(() {
                                  if (_formKey.currentState.validate()) {
                                    this.displayResult =
                                        _calculateTotalReturns();
                                  }
                                });
                              }),
                        ),
                        Expanded(
                          child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text("Reset", textScaleFactor: 1.5),
                              onPressed: () {
                                setState(() {
                                  _reset();
                                });
                              }),
                        )
                      ])),
                  Padding(
                      padding: EdgeInsets.all(_minimumPadding * 2),
                      child: Text(displayResult, style: textStyle))
                ]))));
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(image: assetImage, width: 100.0, height: 100.0);
    return Container(child: image, margin: EdgeInsets.all(_minimumPadding * 3));
  }

  void _onDropDownItemSelected(String newSelectedValue) {
    setState(() {
      _currentItemSelected = newSelectedValue;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principleController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';
    return result;
  }

  void _reset() {
    principleController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}
