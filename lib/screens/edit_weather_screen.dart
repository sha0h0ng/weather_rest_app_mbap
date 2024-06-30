import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_rest_app/models/weather.dart';
import 'package:weather_rest_app/services/weather_service.dart';

class EditWeatherForm extends StatelessWidget {
  WeatherService weatherService = GetIt.instance<WeatherService>();
  static String routeName = '/edit-weather';

  var form = GlobalKey<FormState>();

  String? weatherCondition;
  double? weatherTemp;

  saveForm(id, context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      weatherService
          .updateWeather(id, weatherCondition!, weatherTemp!)
          .then((value) {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Weather updated successfully!'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Weather selectedWeather =
        ModalRoute.of(context)?.settings.arguments as Weather;
    weatherCondition = selectedWeather.weatherCondition;
    weatherTemp = selectedWeather.weatherTemp;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Edit Weather'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField(
                  value: weatherCondition,
                  decoration: const InputDecoration(
                    label: Text('Weather Condition'),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Sunny', child: Text('Sunny')),
                    DropdownMenuItem(value: 'Rainy', child: Text('Rainy')),
                    DropdownMenuItem(value: 'Cloudy', child: Text('Cloudy')),
                  ],
                  validator: (value) {
                    if (value == null)
                      return "Please provide the weather condition.";
                    else
                      return null;
                  },
                  onChanged: (value) {
                    weatherCondition = value as String;
                  },
                  onSaved: (value) {
                    weatherCondition = value as String;
                  },
                ),
                TextFormField(
                  initialValue: weatherTemp!.toStringAsFixed(1),
                  decoration:
                      const InputDecoration(label: Text('Weather Temperature')),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null)
                      return "Please provide a temperature.";
                    else if (double.tryParse(value) == null)
                      return "Please provide a valid tiemperature.";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    weatherTemp = double.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      saveForm(selectedWeather.weatherID, context);
                    },
                    child: const Text('Update Weather'))
              ],
            ),
          ),
        ));
  }
}
