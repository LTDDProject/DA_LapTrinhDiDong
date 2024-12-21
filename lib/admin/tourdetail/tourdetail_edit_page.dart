import 'package:flutter/material.dart';
import '../../services/tour_detail_service.dart';
import '../../models/tourdetail.dart';

class EditTourDetailPage extends StatefulWidget {
  final TourDetail tourDetail;

  EditTourDetailPage({required this.tourDetail});

  @override
  _EditTourDetailPageState createState() => _EditTourDetailPageState();
}

class _EditTourDetailPageState extends State<EditTourDetailPage> {
  final TourDetailApiService apiService = TourDetailApiService();
  final _formKey = GlobalKey<FormState>();

  late TourDetail currentTourDetail;
  List<Tour> tours = [];
  List<Hotel> hotels = [];
  List<Vehicle> vehicles = [];

  @override
  void initState() {
    super.initState();
    currentTourDetail = widget.tourDetail; // Lấy dữ liệu tourDetail từ constructor
    _loadData();
  }

  // Hàm tải dữ liệu cho Dropdowns
  void _loadData() async {
    try {
      // Fetch available data for tours, hotels, and vehicles
      tours = await apiService.fetchTours();
      hotels = await apiService.fetchHotels();
      vehicles = await apiService.fetchVehicles();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load data')));
    }
  }

  // Hàm cập nhật chi tiết tour
  void _updateTourDetail() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        await apiService.updateTourDetail(currentTourDetail);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tour detail updated successfully')));
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update tour detail')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Tour Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dropdown for Tour
              DropdownButtonFormField<Tour>(
                value: currentTourDetail.tour,
                decoration: InputDecoration(labelText: 'Tour'),
                items: tours.map((tour) {
                  return DropdownMenuItem<Tour>(
                    value: tour,
                    child: Text(tour.tourName ?? 'No Name'),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  currentTourDetail.tour = value;
                }),
                validator: (value) => value == null ? 'Please select a tour' : null,
              ),
              SizedBox(height: 10),
              // Dropdown for Hotel
              DropdownButtonFormField<Hotel>(
                value: currentTourDetail.hotel,
                decoration: InputDecoration(labelText: 'Hotel'),
                items: hotels.map((hotel) {
                  return DropdownMenuItem<Hotel>(
                    value: hotel,
                    child: Text(hotel.name ?? 'No Name'),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  currentTourDetail.hotel = value;
                }),
              ),
              SizedBox(height: 10),
              // Dropdown for Vehicle
              DropdownButtonFormField<Vehicle>(
                value: currentTourDetail.vehicle,
                decoration: InputDecoration(labelText: 'Vehicle'),
                items: vehicles.map((vehicle) {
                  return DropdownMenuItem<Vehicle>(
                    value: vehicle,
                    child: Text(vehicle.vehicleName ?? 'No Name'),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  currentTourDetail.vehicle = value;
                }),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTourDetail,
                child: Text('Update Tour Detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
