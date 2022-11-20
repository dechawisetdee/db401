import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6Ijg5MjU0ZTQzMGU0MmRlYmYxYWM2YTY1M2FmNzJmYmUwZWVmOTc5ZjFkODljZDFjYzQ5OTdkNzM5OWZkMDk2MzdiM2I5MWQ5MjMzMWExZmQ2In0.eyJhdWQiOiIyIiwianRpIjoiODkyNTRlNDMwZTQyZGViZjFhYzZhNjUzYWY3MmZiZTBlZWY5NzlmMWQ4OWNkMWNjNDk5N2Q3Mzk5ZmQwOTYzN2IzYjkxZDkyMzMxYTFmZDYiLCJpYXQiOjE2Njg5Mzg2MDgsIm5iZiI6MTY2ODkzODYwOCwiZXhwIjoxNzAwNDc0NjA4LCJzdWIiOiIyMjY5Iiwic2NvcGVzIjpbXX0.gWIgYHuZ28lgl5lLo24deCfMn-gKo4Kv9oLE12sADuhBc2ec_b1VLyTsiyKvYT1NnvlARo4Aw80ZJn-zeacBtRwDfsXl9CuhvWAmS3jTeRwtdQ7luMJ3O6UFH-Oq9U9IQLPkDF9Ivt_3Y5urOqZVJzLSlGlo0ikaUFlclEsOJlcUyiSH_bDOCBIHHdxJYjQVG2SLerUxZVRe2P0Ge7jKViHAVfhFoYZ4GBh1J3DrSBKgRkocWoM33_bb5NCLqsmI-1WQz-C4Dnq_J0yfbfW1Cj9fPsVs7j-R_aevGRegy3_aiY4CHmWhzXBJeM_7uNfdQti47HqtoupHlyPgorSnH9Cs6IE-KgSlgafwg4_kzcng_cY6pfTZbZ4bMZFg3WrEkd1m49Fxf_tElINvlaxMrV6ovBWxuDzf7WFbNc3PTS095-28rXcC42Jdhwb7hFhddNHOT3EPzRM4CP_WoaTu0Xd8H9gXOxvVtXz-E01AmtugFSjxtAAjU17ztmNfa0wp5IT27lV7f52AM_8BLCmY9EURnK2_iSk_0xc3DSD2n_Sy3UiBNNR3cD4Li0JTz4PiH-3gkyQkBVjEHxURT58kwL5x5osc-MMFw6tAQxpkPI7cZ-7F_EwSfklVVa3ULhkCS76tpmoNnXhnAeR7jNg2eKWfU8V6b46IB_aNRIw7lmg';

 try {
   Position location = await getCurrentLocation();
   http.Response response = await http.get(
  Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
  headers: {
    'accept': 'application/json',
    'authorization': 'Bearer $token',
  }
);
if(response.statusCode == 200) {
  var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
  Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
  return Weather(
  address: '${address.subLocality}\n${address.administrativeArea}',
  temperature: result['tc'],
  cond: result['cond'],
);
 } else {
  return Future.error(response.statusCode); 
 }
} catch (e) {
  return Future.error(e);
}

}