import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String _startMeasure = 'meters';
  late String _resultsMessage = '';
  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];
  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };
  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 5280, 1, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.028495, 3.28084, 0, 0.0625, 1]
  };
  void conversion(double value, String from, String to) {
    int? nFrom = _measuresMap[from];
    int? nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = multiplier * value;

    if (result == 0) {
      _resultsMessage = "This conversion is not possible";
    } else {
      _resultsMessage =
          "$value $_startMeasure are ${result.toString()} $_convertedMeasure";
    }
    setState(() {
      _resultsMessage = _resultsMessage;
    });
  }

  late double _numberFrom;
  late String _convertedMeasure;
  // This widget is the root of your application.
  @override
  void initState() {
    _numberFrom = 0;
    _convertedMeasure = _measures[0];
    super.initState();
  }

  final TextStyle inputStyle = TextStyle(fontSize: 20, color: Colors.blue[900]);
  final TextStyle labelStyle = TextStyle(fontSize: 24, color: Colors.grey[700]);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Measurements Converter',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Measurements Converter'),
              centerTitle: true,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Spacer(),
                  Text('Value', style: labelStyle),
                  const Spacer(),
                  TextField(
                    style: inputStyle,
                    decoration: const InputDecoration(
                        hintText: "Insert the measure to be converted"),
                    onChanged: (text) {
                      var vr = double.tryParse(text);
                      if (vr != null) {
                        setState(() => {_numberFrom = vr});
                      }
                    },
                  ),
                  const Spacer(),
                  Text(
                    'From',
                    style: labelStyle,
                  ),
                  DropdownButton<String>(
                      isExpanded: true,
                      value: _startMeasure,
                      onChanged: (value) {
                        setState(() {
                          _startMeasure = value!;
                        });
                      },
                      items: _measures.map((String value) {
                        return DropdownMenuItem<String>(
                          key: ValueKey(value),
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  Text('To', style: labelStyle),
                  DropdownButton<String>(
                      onChanged: (value) {
                        setState(() {
                          _convertedMeasure = value!;
                        });
                      },
                      isExpanded: true,
                      value: _convertedMeasure,
                      items: _measures.map((String value) {
                        return DropdownMenuItem<String>(
                          key: ValueKey(value),
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  const Spacer(flex: 2),
                  ElevatedButton(
                      onPressed: () {
                        if (_startMeasure.isEmpty ||
                            _convertedMeasure.isEmpty ||
                            _numberFrom == 0) {
                          return;
                        } else {
                          conversion(
                              _numberFrom, _startMeasure, _convertedMeasure);
                        }
                      },
                      child: Text('Convert', style: inputStyle)),
                  const Spacer(flex: 2),
                  Text(
                    (_resultsMessage == null) ? '' : _resultsMessage,
                    style: labelStyle,
                  ),
                  const Spacer(flex: 8)
                ],
              ),
            )));
  }
}
