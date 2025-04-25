import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:quickoo/Utills/app_color.dart';
import 'package:quickoo/Utills/route_screen.dart';
import 'drop_of_screen.dart';
import 'route_selection_screen.dart';
import '../Controller/route_selection_controller.dart';

class MapScreen extends StatefulWidget {
  final Position initialPosition;
  final String screenType;
  final String? previousAddress;
  final bool? returnToSearchScreen; // Add this parameter

  const MapScreen({
    Key? key,
    required this.initialPosition,
    required this.screenType,
    this.previousAddress,
    this.returnToSearchScreen, // Initialize the parameter
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLatLng;
  TextEditingController addressController = TextEditingController();
  bool isLoadingAddress = false;

  // Get instance of RouteController
  final RouteController routeController = Get.find<RouteController>();

  @override
  void initState() {
    super.initState();
    _selectedLatLng = LatLng(
      widget.initialPosition.latitude,
      widget.initialPosition.longitude,
    );
    _getAddressFromLatLng(_selectedLatLng!);
  }

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      _selectedLatLng = tappedPoint;
      isLoadingAddress = true;
    });
    _getAddressFromLatLng(tappedPoint);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placemarks.first;
      String address =
          "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
      setState(() {
        addressController.text = address;
        isLoadingAddress = false;
      });
    } catch (e) {
      setState(() {
        addressController.text = "Unable to get address";
        isLoadingAddress = false;
      });
    }
  }

  void _proceedWithLocation() {
    if (addressController.text.isEmpty || addressController.text == "Unable to get address") return;

    // Save the selected address in RouteController
    routeController.selectedLatLng.value = _selectedLatLng!;
    routeController.selectedAddress.value = addressController.text;

    // Check if we should return to SearchScreen
    if (widget.returnToSearchScreen == true) {
      Navigator.pop(context, addressController.text);
      return;
    }

    // Original navigation logic
    if (widget.screenType == 'pickup') {
      // Navigate to DropoffScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DropoffScreen(pickup: addressController.text),
        ),
      );
    } else if (widget.screenType == 'dropoff') {
      // Navigate to RouteSelectionScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapRouteScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _proceedWithLocation,
        backgroundColor: AppColor.bottomcurveColor,
        child: const Icon(Icons.arrow_forward,color: Colors.white,),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLatLng!,
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTapped,
            markers: _selectedLatLng != null
                ? {
              Marker(
                markerId: const MarkerId("selected"),
                position: _selectedLatLng!,
              ),
            }
                : {},
          ),

          // Address input box
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: addressController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: isLoadingAddress
                            ? 'Fetching address...'
                            : 'Selected Location',
                        suffixIcon: isLoadingAddress
                            ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          ),
                        )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
