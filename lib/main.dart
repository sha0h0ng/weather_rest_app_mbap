import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:weather_rest_app/models/weather.dart';
import 'package:weather_rest_app/screens/add_weather_screen.dart';
import 'package:weather_rest_app/screens/edit_weather_screen.dart';
import 'package:weather_rest_app/services/weather_service.dart';

void main() {
  runApp(MyApp()); // You can change the class name from MyApp to something else
  GetIt.instance.registerLazySingleton(() => WeatherService());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainScreen(),
      routes: {
        AddWeatherForm.routeName: (_) {
          return AddWeatherForm();
        },
        EditWeatherForm.routeName: (_) {
          return EditWeatherForm();
        },
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  WeatherService weatherService = GetIt.instance<WeatherService>();

  @override
  Widget build(BuildContext context) {
    weatherService.getWeather();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('RESTful App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddWeatherForm.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<List<Weather>>(
        stream: weatherService.getWeatherStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemBuilder: (ctx, i) {
              Weather currentWeather = snapshot.data![i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: currentWeather.weatherCondition == 'Sunny'
                      ? Colors.yellowAccent
                      : currentWeather.weatherCondition == 'Rainy'
                          ? Colors.grey
                          : Colors.lightBlueAccent,
                ),
                title: Text(DateFormat('dd MMM yyyy')
                    .format(currentWeather.weatherDate)),
                subtitle: Text(currentWeather.weatherTemp.toStringAsFixed(1) +
                    ' degree celcius'),
                trailing: IconButton(
                  onPressed: () {
                    weatherService.removeWeather(currentWeather.weatherID);
                  },
                  icon: Icon(Icons.delete),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(EditWeatherForm.routeName,
                      arguments: currentWeather);
                },
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
