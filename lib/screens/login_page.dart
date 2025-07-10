// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://YOUR-PROJECT.supabase.co',
//     anonKey: 'YOUR-ANON-KEY',
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Champion Registration',
//       theme: ThemeData(primarySwatch: Colors.purple),
//       home: LoginPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class CreateAccountPage extends StatefulWidget {
//   @override
//   _CreateAccountPageState createState() => _CreateAccountPageState();
// }

// class _CreateAccountPageState extends State<CreateAccountPage> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _pinCodeController = TextEditingController();

//   // Map state
//   GoogleMapController? _mapController;
//   LatLng _initialPosition = LatLng(20.5937, 78.9629); // center of India
//   LatLng? _selectedLocation;
//   final Set<Marker> _markers = {};

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _pinCodeController.dispose();
//     super.dispose();
//   }

//   /// Geocode the address string into LatLng and move camera
//   Future<void> _moveCameraToAddress() async {
//     final address = _addressController.text;
//     if (address.isEmpty) return;
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         final loc = locations.first;
//         final target = LatLng(loc.latitude, loc.longitude);
//         _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
//       }
//     } catch (e) {
//       // Handle geocoding errors
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Could not find location: $e')));
//     }
//   }

//   /// Save form + location to Supabase
//   Future<void> _saveToSupabase() async {
//     final supabase = Supabase.instance.client;
//     if (_selectedLocation == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please tap on the map to select your home location'),
//         ),
//       );
//       return;
//     }

//     final response = await supabase.from('champions').insert({
//       'full_name': _fullNameController.text,
//       'email': _emailController.text,
//       'phone': _phoneController.text,
//       'address': _addressController.text,
//       'pin_code': _pinCodeController.text,
//       'latitude': _selectedLocation!.latitude,
//       'longitude': _selectedLocation!.longitude,
//     }).execute();

//     if (response.error != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving: ${response.error!.message}')),
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Champion registered!')));
//       Navigator.pop(context);
//     }
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     VoidCallback? onSubmitted,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         onSubmitted: (_) => onSubmitted?.call(),
//         decoration: InputDecoration(
//           hintText: hintText,
//           prefixIcon: Icon(icon, color: Colors.grey),
//           suffixIcon: hintText == 'Address'
//               ? IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: _moveCameraToAddress,
//                 )
//               : null,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B5CF6),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: BackButton(color: Colors.white),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Icon(Icons.person_add, size: 50, color: Color(0xFF8B5CF6)),
//                 SizedBox(height: 16),
//                 Text(
//                   'Create Account',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 32),

//                 _buildInputField(
//                   controller: _fullNameController,
//                   hintText: 'Full Name',
//                   icon: Icons.person_outline,
//                 ),
//                 _buildInputField(
//                   controller: _emailController,
//                   hintText: 'Email',
//                   icon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 _buildInputField(
//                   controller: _phoneController,
//                   hintText: 'Phone Number',
//                   icon: Icons.phone_outlined,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 _buildInputField(
//                   controller: _addressController,
//                   hintText: 'Address',
//                   icon: Icons.location_on_outlined,
//                   maxLines: 2,
//                   onSubmitted: _moveCameraToAddress,
//                 ),
//                 _buildInputField(
//                   controller: _pinCodeController,
//                   hintText: 'Pin Code',
//                   icon: Icons.pin_drop_outlined,
//                   keyboardType: TextInputType.number,
//                 ),

//                 // Google Map
//                 Container(
//                   height: 200,
//                   margin: const EdgeInsets.only(bottom: 24),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: GoogleMap(
//                       initialCameraPosition: CameraPosition(
//                         target: _initialPosition,
//                         zoom: 5,
//                       ),
//                       onMapCreated: (ctrl) => _mapController = ctrl,
//                       markers: _markers,
//                       onTap: (latLng) {
//                         setState(() {
//                           _markers
//                             ..clear()
//                             ..add(
//                               Marker(
//                                 markerId: MarkerId('home'),
//                                 position: latLng,
//                               ),
//                             );
//                           _selectedLocation = latLng;
//                         });
//                       },
//                     ),
//                   ),
//                 ),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _saveToSupabase,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF8B5CF6),
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       'Save',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// 2) BELOW is your already‑existing LoginPage — leave it exactly as you wrote it:
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B5CF6), // Purple background
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//               width: double.infinity,
//               constraints: const BoxConstraints(maxWidth: 400),
//               padding: const EdgeInsets.all(32.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Welcome Champion Title
//                   const Text(
//                     'Welcome Champion',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   // Email Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     child: TextField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: const InputDecoration(
//                         hintText: 'Email',
//                         prefixIcon: Icon(
//                           Icons.email_outlined,
//                           color: Colors.grey,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Password Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     child: TextField(
//                       controller: _passwordController,
//                       obscureText: !_isPasswordVisible,
//                       decoration: InputDecoration(
//                         hintText: 'Password',
//                         prefixIcon: const Icon(
//                           Icons.lock_outline,
//                           color: Colors.grey,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility_outlined
//                                 : Icons.visibility_off_outlined,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),

//                   // Login Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle login logic here
//                         print('Email: ${_emailController.text}');
//                         print('Password: ${_passwordController.text}');

//                         // You can add your login logic here
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Login button pressed!'),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF8B5CF6),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(Icons.arrow_forward, size: 18),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // New Account Text
//                   GestureDetector(
//                     onTap: () {
//                       // Navigate to create account page
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CreateAccountPage(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'New account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF8B5CF6),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dcjdlufuwoxtoliwnedy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjamRsdWZ1d294dG9saXduZWR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5MjQ2MjAsImV4cCI6MjA2NjUwMDYyMH0.cJg6_pJu0U37APHhtX9lks5h69ZlBdRGbfS3Q5FFzcU',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Champion App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _pinCodeController = TextEditingController();

  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  CameraPosition _initialCamera = CameraPosition(
    target: LatLng(20.5937, 78.9629), // India center
    zoom: 5,
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  Future<void> _geocodeAddress() async {
    final address = _addressController.text;
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final position = LatLng(loc.latitude, loc.longitude);
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: position, zoom: 14),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Geocoding failed: \$e')));
    }
  }

  void _onMapTap(LatLng pos) {
    setState(() {
      _pickedLocation = pos;
    });
  }

  Future<void> _saveChampion() async {
    if (_pickedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please pick a location on the map.')),
      );
      return;
    }
    final supabase = Supabase.instance.client;
    try {
      final res = await Supabase.instance.client
          .from('DEMO_CHAMPION')
          .insert({
            'name': _fullNameController.text,
            'Email': _emailController.text,
            'Phone': _phoneController.text,
            'address': _addressController.text,
            'Pin code': _pinCodeController.text,
            'Latitude': _pickedLocation!.latitude,
            'Longitude': _pickedLocation!.longitude,
          })
          // if you want the new row returned you can add .select() here
          .execute();

      // no exception = success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Supabase/PostgREST exception
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving account: $e')));
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B5CF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.person_add,
                  size: 50,
                  color: Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                _buildInputField(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  icon: Icons.person_outline,
                ),
                _buildInputField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildInputField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                _buildInputField(
                  controller: _addressController,
                  hintText: 'Address',
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                ),
                _buildInputField(
                  controller: _pinCodeController,
                  hintText: 'Pin Code',
                  icon: Icons.pin_drop_outlined,
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _geocodeAddress,
                  child: Text('Locate on Map'),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: GoogleMap(
                    initialCameraPosition: _initialCamera,
                    onMapCreated: (ctrl) => _mapController = ctrl,
                    onTap: _onMapTap,
                    markers: _pickedLocation != null
                        ? {
                            Marker(
                              markerId: MarkerId('picked'),
                              position: _pickedLocation!,
                            ),
                          }
                        : {},
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveChampion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final supabase = Supabase.instance.client;
    try {
      final res = await Supabase.instance.client
          .from('DEMO_CHAMPION')
          .select()
          .eq('Email', _emailController.text)
          .eq('Pin code', _passwordController.text)
          .maybeSingle() // returns at most one row
          .execute();

      if (res.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No account found. Please create an account.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful!')));
        // navigate on success…
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B5CF6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome Champion',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password (Pin Code)',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAccountPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'New account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
