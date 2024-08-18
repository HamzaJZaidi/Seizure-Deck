  import 'package:flutter/material.dart';
  import 'package:noise_meter/noise_meter.dart';
  import 'dart:async';
  import 'package:fl_chart/fl_chart.dart';


  class NoiseChecker extends StatefulWidget {
    const NoiseChecker({super.key});

    @override
    State<NoiseChecker> createState() => _NoiseCheckerState();
  }

  class _NoiseCheckerState extends State<NoiseChecker> {
    bool _isRecording = false;
    NoiseReading _latestReading = NoiseReading([0, 0]);
    StreamSubscription<NoiseReading>? _noiseSubscription;
    late NoiseMeter _noiseMeter;

    // List to store noise level readings
    List<_NoiseData> noiseData = [];

    @override
    void initState() {
      super.initState();
      _noiseMeter = NoiseMeter(onError);
      start(); // Start listening to noise when the screen opens
    }

    @override
    void dispose() {
      _noiseSubscription?.cancel();
      super.dispose();
    }

    void onData(NoiseReading noiseReading) {
      setState(() {
        _latestReading = noiseReading;
        if (!_isRecording) _isRecording = true;

        // Store the noise level and current time
        noiseData.add(
          _NoiseData(DateTime.now(), noiseReading.meanDecibel),
        );
      });
    }

    void onError(Object error) {
      print(error.toString());
      setState(() {
        _isRecording = false;
      });
    }

    void start() {
      try {
        _noiseSubscription = _noiseMeter.noise.listen(onData);
      } catch (err) {
        print(err);
      }
    }

    void stop() {
      try {
        _noiseSubscription?.cancel();
        setState(() {
          _isRecording = false;
        });
      } catch (err) {
        print(err);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              stop(); // Stop listening to noise when the screen is popped
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Noise Checker",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Text(
                    "${_latestReading.meanDecibel.toStringAsFixed(1)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "dB",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Container(
                height: 190,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: noiseData
                            .asMap()
                            .entries
                            .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.decibel))
                            .toList(),
                        isCurved: true,
                        // colors: [Colors.blue],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    lineTouchData: LineTouchData(enabled: true),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Class to store noise level and corresponding time
  class _NoiseData {
    _NoiseData(this.time, this.decibel);

    final DateTime time;
    final double decibel;
  }
