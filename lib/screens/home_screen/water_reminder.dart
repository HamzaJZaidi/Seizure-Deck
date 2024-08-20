import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

void main() {
  tz.initializeTimeZones();
  runApp(const WaterReminderApp());
}

class WaterReminderApp extends StatelessWidget {
  const WaterReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WaterReminderScreen(),
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({super.key});

  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> with SingleTickerProviderStateMixin {
  int goal = 8;
  int currentIntake = 2; // Number of glasses already drunk
  late AnimationController _controller;
  late Animation<double> _animation;
  String _description = 'Sunny';
  String _weatherIcon = '';
  double _temperature = 0.0;
  String _cityName = '';
  double _feelsLike = 0.0;
  int _humidity = 0;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String get goalString => 'Goal: $goal glasses';

   @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _fetchWeather();
  }

   

  Future<void> _fetchWeather() async {
    const apiKey = '8d94ec4aab9d73fb91a2056d77be8d71'; // Replace with your OpenWeatherMap API key
    const city = 'karachi'; // Replace with your city
    const url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);
        setState(() {
          _description = weatherData['weather'][0]['description'];
          _weatherIcon = weatherData['weather'][0]['icon'];
          _temperature = weatherData['main']['temp'];
          _cityName = weatherData['name'];
          _feelsLike = weatherData['main']['feels_like'];
          _humidity = weatherData['main']['humidity'];
        });
      } else {
        setState(() {
          _description = 'Failed to load weather';
        });
      }
    } catch (e) {
      setState(() {
        _description = 'Failed to load weather';
      });
    }
  }

  void _addWater(int amount) {
    setState(() {
      currentIntake += amount;
      _controller.forward(from: 0); // Reset and start animation
      if (currentIntake >= goal) {
        _showGoalAchievedDialog();
      }
    });
  }

  void _showGoalAchievedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You have achieved your water intake goal for today! 🏆'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                currentIntake = 0;
              });
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentIntake / goal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Reminder'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              'Goal: $goal glasses',
              style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 14, 153, 218)),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 100,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  width: 100,
                  height: 300 * progress,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  width: 100,
                  height: 300,
                  alignment: Alignment.center,
                  child: Text(
                    '${goal - currentIntake} glasses\nleft to drink',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _weatherIcon.isNotEmpty
                        ? Image.network(
                            'https://openweathermap.org/img/wn/$_weatherIcon@2x.png',
                            width: 100,
                            height: 100,
                          )
                        : Container(),
                    const SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _description,
                          style: const TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$_temperature°C',
                          style: const TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        Text(
                          _cityName,
                          style: const TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Feels Like: $_feelsLike°C',
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Humidity: $_humidity%',
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addWaterButton', // Unique tag to avoid hero conflict
            onPressed: () {
              _addWater(1); // Add one glass of water
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'setTimerButton', // Unique tag to avoid hero conflict
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetTimerScreen()),
              );
            },
            child: const Icon(Icons.timer),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SetTimerScreen extends StatefulWidget {
  const SetTimerScreen({super.key});

  @override
  _SetTimerScreenState createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {

  DateTime? time;
  Future<void> _scheduleNotification(DateTime scheduledTime) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    tz.initializeTimeZones();
    var scheduledTimeZone = tz.local;
    var scheduledDateTime = tz.TZDateTime.from(
      scheduledTime,
      scheduledTimeZone,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Water Reminder',
      "It's time to drink water!",
      scheduledDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder to Drink Water'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
  onPressed: () async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      
      await _scheduleNotification(scheduledDateTime);
    }
    if (selectedTime != null) {
      setState(() {
        if (time != null) {
          time = DateTime(
            time!.year,
            time!.month,
            time!.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        }
        print('selected time: $selectedTime, $time');
      });
    }
  },
  child: const Text('Set Timer'),

),
          ],
        ),
      ),
    );
  }

  Future<void> _setReminderNotification(int hours, dynamic selectedTime) async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(hours: hours));
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
String formattedTime = DateFormat('HH:mm').format(time!);
                                    NotificationService().showNotification(
                                      title: 'Notification',
                                      body:
                                          'Time to Drink Water at $formattedTime $selectedTime',
                                    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Water Reminder',
      'It\'s time to drink water!',
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
