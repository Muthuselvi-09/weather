import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(const WeatherVibeApp());

class WeatherVibeApp extends StatelessWidget {
  const WeatherVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Vibe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const WeatherHome(),
    );
  }
}

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _weather = '';
  String _cityName = '';
  bool _loading = false;

  // Animated background colors
  Color _bgColor1 = Colors.blue;
  Color _bgColor2 = Colors.indigo;

  IconData _weatherIcon = Icons.wb_sunny_rounded;

  Future<void> _getWeather(String city) async {
    const String apiKey = 'ab0e1193e9c58c894d60a11af4103258'; // 🔑 Add your API key here
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    setState(() => _loading = true);

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final temp = data['main']['temp'].toString();
        final desc = data['weather'][0]['main'];
        final name = data['name'];

        setState(() {
          _temperature = '$temp °C';
          _weather = desc;
          _cityName = name;
          _updateBackground(desc);
          _loading = false;
        });
      } else {
        setState(() {
          _temperature = 'City not found';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _temperature = 'Error loading weather';
        _loading = false;
      });
    }
  }

  void _updateBackground(String weather) {
    setState(() {
      switch (weather.toLowerCase()) {
        case 'rain':
        case 'drizzle':
          _bgColor1 = Colors.blueGrey.shade800;
          _bgColor2 = Colors.indigo.shade900;
          _weatherIcon = Icons.water_drop_rounded;
          break;
        case 'clouds':
          _bgColor1 = Colors.grey.shade700;
          _bgColor2 = Colors.blueGrey.shade800;
          _weatherIcon = Icons.cloud_rounded;
          break;
        case 'clear':
          _bgColor1 = Colors.orangeAccent.shade200;
          _bgColor2 = Colors.deepOrange.shade400;
          _weatherIcon = Icons.wb_sunny_rounded;
          break;
        case 'snow':
          _bgColor1 = Colors.lightBlue.shade100;
          _bgColor2 = Colors.blue.shade200;
          _weatherIcon = Icons.ac_unit_rounded;
          break;
        case 'thunderstorm':
          _bgColor1 = Colors.deepPurple.shade800;
          _bgColor2 = Colors.black87;
          _weatherIcon = Icons.flash_on_rounded;
          break;
        default:
          _bgColor1 = Colors.blue;
          _bgColor2 = Colors.indigo;
          _weatherIcon = Icons.wb_sunny_rounded;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String date =
        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgColor1, _bgColor2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Weather Vibe ☁️",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _cityController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        // ignore: deprecated_member_use
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_cityController.text.isNotEmpty) {
                          _getWeather(_cityController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        // ignore: deprecated_member_use
                        backgroundColor: Colors.white.withOpacity(0.25),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Get Weather",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_loading)
                      const CircularProgressIndicator(color: Colors.white)
                    else if (_temperature.isNotEmpty)
                      Column(
                        children: [
                          Icon(
                            _weatherIcon,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _cityName,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _temperature,
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _weather,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
