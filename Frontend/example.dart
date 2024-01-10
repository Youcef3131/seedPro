// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Car {
//   final int id;
//   final String brand;
//   final String model;
//   final int year;

//   Car({required this.id, required this.brand, required this.model, required this.year});

//   factory Car.fromJson(Map<String, dynamic> json) {
//     return Car(
//       id: json['id'],
//       brand: json['brand'],
//       model: json['model'],
//       year: json['year'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'brand': brand,
//       'model': model,
//       'year': year,
//     };
//   }
// }

// class ApiService {
//   final String baseUrl;

//   ApiService(this.baseUrl);

//   Future<Map<String, String>> getHeaders() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? authToken = prefs.getString('authToken');

//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Token $authToken',
//     };
//   }

//   Future<List<Car>> getCars() async {
//     final response = await http.get(Uri.parse('$baseUrl/cars/'), headers: await getHeaders());
//     if (response.statusCode == 200) {
//       Iterable list = json.decode(response.body);
//       return list.map((carJson) => Car.fromJson(carJson)).toList();
//     } else {
//       throw Exception('Failed to load cars');
//     }
//   }

//   Future<Car> getCar(int id) async {
//     final response = await http.get(Uri.parse('$baseUrl/cars/$id/'), headers: await getHeaders());
//     if (response.statusCode == 200) {
//       return Car.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load car');
//     }
//   }

//   Future<Car> createCar(Car car) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/cars/'),
//       headers: await getHeaders(),
//       body: json.encode(car.toJson()),
//     );

//     if (response.statusCode == 201) {
//       return Car.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to create car');
//     }
//   }

//   Future<Car> updateCar(Car car) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/cars/${car.id}/'),
//       headers: await getHeaders(),
//       body: json.encode(car.toJson()),
//     );

//     if (response.statusCode == 200) {
//       return Car.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to update car');
//     }
//   }

//   Future<void> deleteCar(int id) async {
//     final response = await http.delete(Uri.parse('$baseUrl/cars/$id/'), headers: await getHeaders());

//     if (response.statusCode != 204) {
//       throw Exception('Failed to delete car');
//     }
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Car CRUD Example',
//       home: CarListScreen(),
//     );
//   }
// }

// class CarListScreen extends StatefulWidget {
//   @override
//   _CarListScreenState createState() => _CarListScreenState();
// }

// class _CarListScreenState extends State<CarListScreen> {
//   final ApiService apiService = ApiService('http://your-api-base-url');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Car List'),
//       ),
//       body: FutureBuilder<List<Car>>(
//         future: apiService.getCars(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final cars = snapshot.data ?? [];
//             return ListView.builder(
//               itemCount: cars.length,
//               itemBuilder: (context, index) {
//                 final car = cars[index];
//                 return ListTile(
//                   title: Text('${car.brand} ${car.model}'),
//                   subtitle: Text('Year: ${car.year}'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CarDetailScreen(car: car),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddCarScreen(),
//             ),
//           ).then((value) {
//             setState(() {}); // Refresh the car list after adding a new car
//           });
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class CarDetailScreen extends StatelessWidget {
//   final Car car;

//   const CarDetailScreen({Key? key, required this.car}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${car.brand} ${car.model}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Year: ${car.year}'),
//             // Add more details here as needed
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AddCarScreen extends StatefulWidget {
//   @override
//   _AddCarScreenState createState() => _AddCarScreenState();
// }

// class _AddCarScreenState extends State<AddCarScreen> {
//   final ApiService apiService = ApiService('http://your-api-base-url');
//   final TextEditingController brandController = TextEditingController();
//   final TextEditingController modelController = TextEditingController();
//   final TextEditingController yearController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Car'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: brandController,
//               decoration: const InputDecoration(labelText: 'Brand'),
//             ),
//             TextField(
//               controller: modelController,
//               decoration: const InputDecoration(labelText: 'Model'),
//             ),
//             TextField(
//               controller: yearController,
//               decoration: const InputDecoration(labelText: 'Year'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 final newCar = Car(
//                   id: 0, // Set to 0 for now, the actual ID will be assigned by the server
//                   brand: brandController.text,
//                   model: modelController.text,
//                   year: int.tryParse(yearController.text) ?? 0,
//                 );

//                 final createdCar = await apiService.createCar(newCar);
//                 // Handle the response as needed

//                 Navigator.pop(context); // Close the Add Car screen
//               },
//               child: const Text('Add Car'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
