import 'package:flutter/material.dart';
import '../../services/tour_detail_service.dart';
import '../../models/tourdetail.dart';

class AddTourDetailPage extends StatefulWidget {
  @override
  _AddTourDetailPageState createState() => _AddTourDetailPageState();
}

class _AddTourDetailPageState extends State<AddTourDetailPage> {
  final TourDetailApiService apiService = TourDetailApiService();
  final _formKey = GlobalKey<FormState>();

  late TourDetail newTourDetail;

  @override
  void initState() {
    super.initState();
    newTourDetail = TourDetail(tour: null, vehicle: null, hotel: null); // Khởi tạo đối tượng TourDetail mới
  }

  // Hàm thêm chi tiết tour
  void _addTourDetail() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        await apiService.addTourDetail(newTourDetail);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tour detail added successfully')));
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add tour detail')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Tour Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Tour Name'),
                onSaved: (value) => newTourDetail.tour = Tour(tourName: value),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a tour name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Hotel Name'),
                onSaved: (value) => newTourDetail.hotel = Hotel(name: value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Vehicle Name'),
                onSaved: (value) => newTourDetail.vehicle = Vehicle(vehicleName: value),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTourDetail,
                child: Text('Add Tour Detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
