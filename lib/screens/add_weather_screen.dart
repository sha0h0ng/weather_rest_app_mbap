import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_rest_app/services/weather_service.dart';

class AddWeatherForm extends StatelessWidget {
  WeatherService weatherService = GetIt.instance<WeatherService>();
  static String routeName = '/add-weather';

  var form = GlobalKey<FormState>();

  String? weatherCondition;
  double? weatherTemp;

  saveForm(context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      weatherService.addWeather(weatherCondition!, weatherTemp!).then((value) {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Weather added successfully!'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add Weather'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField(
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
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text('Weather Temperature')),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null)
                      return "Please provide a temperature.";
                    else if (double.tryParse(value) == null)
                      return "Please provide a valid temperature.";
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
                      saveForm(context);
                    },
                    child: const Text('Add Weather'))
              ],
            ),
          ),
        ));
  }
}
