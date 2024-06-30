import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:weather_rest_app/models/weather.dart';

class WeatherService {
  StreamController<List<Weather>> weatherStreamController =
      StreamController<List<Weather>>.broadcast();
  Stream<List<Weather>> getWeatherStream() {
    return weatherStreamController.stream;
  }

  Future<void> getWeather() {
    List<Weather> weatherData = [];
    Uri url = Uri.parse(
        'https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers');
    return get(url).then((value) {
      var extractedData = json.decode(value.body) as List<dynamic>;
      weatherData = [];
      extractedData.forEach((value) {
        weatherData.add(Weather(
            value['myWeatherID'],
            value['myWeatherCondition'],
            value['myWeatherTemp'].toDouble(),
            DateTime.parse(value['myWeatherDateTime'])));
      });
      weatherStreamController.add(weatherData);
    }).catchError((error) {
      throw error;
    });
  }

  Future<Null> removeWeather(String id) {
    Uri url = Uri.parse(
        'https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers/$id');
    return delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw Exception();
      }
      getWeather();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> addWeather(String weatherCondition, double weatherTemp) {
    Uri url = Uri.parse(
        'https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers');
    return post(url,
        body: jsonEncode({
          'myWeatherTemp': weatherTemp,
          'myWeatherCondition': weatherCondition
        })).then((value) {
      getWeather();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateWeather(id, weatherCondition, weatherTemp) {
    Uri url = Uri.parse(
        'https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers/$id');
    return put(url,
        body: jsonEncode({
          'myWeatherTemp': weatherTemp,
          'myWeatherCondition': weatherCondition
        })).then((value) {
      getWeather();
    }).catchError((error) {
      throw error;
    });
  }
}
