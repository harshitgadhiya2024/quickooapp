import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickoo/Controller/route_selection_controller.dart';
import 'package:quickoo/Utills/map_screen.dart';
import 'app_color.dart';
import 'drop_of_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickupLocationScreen extends StatefulWidget {
  final bool isFromSearchScreen;

  const PickupLocationScreen({
    super.key,
    this.isFromSearchScreen = false
  });

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  final TextEditingController addressController = TextEditingController();
  final RouteController routeController = Get.put(RouteController());
  late GooglePlace googlePlace;

  List<Map<String, dynamic>> searchResults = [];
  String selectedAddress = '';
  List<String> searchHistory = [];
  static const int maxHistoryItems = 5;

  int? selectedLoadingIndex;
  int? selectedHistoryIndex;
  bool isCurrentLocationLoading = false;

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyB-Z1yfO79TH2uuDT9-fu-0YmHCRL_B9IA");

    addressController.addListener(() {
      if (addressController.text.isEmpty) {
        setState(() {
          searchResults.clear();
          selectedAddress = '';
        });
      } else {
        _searchLocation(addressController.text);
        setState(() {
          selectedAddress = addressController.text;
        });
      }
    });

    _loadSearchHistory();
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      searchHistory = history;
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', searchHistory);
  }

  void _addToSearchHistory(String address) {
    if (searchHistory.contains(address)) {
      searchHistory.remove(address);
    }
    searchHistory.insert(0, address);
    if (searchHistory.length > maxHistoryItems) {
      searchHistory = searchHistory.sublist(0, maxHistoryItems);
    }
    _saveSearchHistory();
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults.clear());
      return;
    }

    var result = await googlePlace.autocomplete.get(query);
    if (result != null && result.predictions != null) {
      List<Map<String, dynamic>> results = result.predictions!.map((p) {
        return {
          'address': p.description ?? '',
          'placeId': p.placeId,
        };
      }).toList();

      setState(() {
        searchResults = results;
      });
    }
  }

  Future<void> _selectLocation(String placeId, String address, int index) async {

    setState(() {
      selectedLoadingIndex = index;
    });
    var details = await googlePlace.details.get(placeId);

    if (details != null && details.result != null) {
      setState(() {
        selectedAddress = address;
        addressController.text = selectedAddress;
        searchResults.clear();
        _addToSearchHistory(address);
      });
      routeController.setPickupAddress(selectedAddress);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      // Check if we're coming from SearchScreen
      if (widget.isFromSearchScreen) {
        Navigator.of(context).pop(selectedAddress);
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (e) => DropoffScreen(pickup: selectedAddress)));
      }
    }
    setState(() {
      selectedLoadingIndex = null;
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      isCurrentLocationLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      setState(() => isCurrentLocationLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission is required")),
      );
      setState(() => isCurrentLocationLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialPosition: position,
          screenType: 'pickup',
          returnToSearchScreen: widget.isFromSearchScreen, // Pass the flag here
        ),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        selectedAddress = result;
        addressController.text = selectedAddress;
        _addToSearchHistory(selectedAddress);
      });
      routeController.setPickupAddress(selectedAddress);
      // If coming from SearchScreen, return the result directly
      if (widget.isFromSearchScreen) {
        Navigator.of(context).pop(selectedAddress);
      }
    }

    setState(() {
      isCurrentLocationLoading = false;
    });
  }
  void _selectFromHistory(String address) {
    setState(() {
      selectedAddress = address;
      addressController.text = address;
      _addToSearchHistory(address);
    });
    routeController.setPickupAddress(selectedAddress);
    // Check if we're coming from SearchScreen
    if (widget.isFromSearchScreen) {
      Navigator.of(context).pop(selectedAddress);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DropoffScreen(pickup: selectedAddress),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showClearIcon = addressController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select your pick-up ride",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
            const SizedBox(height: 40),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "Search location",
                fillColor: Colors.grey.shade200,
                filled: true,
                border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: showClearIcon
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    addressController.clear();
                    setState(() {
                      searchResults.clear();
                      selectedAddress = '';
                    });
                  },
                )
                    : null,
              ),
              onChanged: _searchLocation,
            ),
            const SizedBox(height: 20),
            if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(thickness: 1),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.location_on,
                          color: AppColor.bottomcurveColor),
                      title: Text(searchResults[index]['address']),
                      trailing: selectedLoadingIndex == index
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: () => _selectLocation(
                        searchResults[index]['placeId'],
                        searchResults[index]['address'],
                        index,
                      ),
                    );
                  },
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _useCurrentLocation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.my_location, color: Colors.blue),
                            const SizedBox(width: 15),
                            const Text(
                              "Use Current Location",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                            ),
                            const Spacer(),
                            isCurrentLocationLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Icon(Icons.arrow_forward_ios_rounded,
                                size: 17, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 3),
                    if (searchHistory.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          itemCount: searchHistory.length,
                          separatorBuilder: (context, index) =>
                          const Divider(thickness: 1),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  selectedHistoryIndex = index;
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 400));
                                _selectFromHistory(searchHistory[index]);
                                setState(() {
                                  selectedHistoryIndex = null;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.history,
                                        color: AppColor.bottomcurveColor,
                                        size: 25),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        searchHistory[index],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    selectedHistoryIndex == index
                                        ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                        : const Icon(Icons.chevron_right,
                                        color: Colors.black, size: 30),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}