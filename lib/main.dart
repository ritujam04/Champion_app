import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // << GoogleMap, CameraPosition, Marker, MarkerId, LatLng
import 'package:geocoding/geocoding.dart'; // << locationFromAddress
import 'package:supabase_flutter/supabase_flutter.dart'; // << Supabase

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
