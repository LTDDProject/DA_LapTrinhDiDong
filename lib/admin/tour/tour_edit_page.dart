import 'package:flutter/material.dart';
import '../../models/tour.dart';
import '../../services/tour_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TourEditPage extends StatefulWidget {
  final Tour tour;

  TourEditPage({required this.tour});

  @override
  _TourEditPageState createState() => _TourEditPageState();
}

class _TourEditPageState extends State<TourEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tourNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _imgFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tourNameController.text = widget.tour.tourName;
    _descriptionController.text = widget.tour.description;
    _priceController.text = widget.tour.price.toString();
    _quantityController.text = widget.tour.quantity.toString();
    _startDate = widget.tour.startDate;
    _endDate = widget.tour.endDate;
  }

  void _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imgFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void _saveTour() async {
    if (_formKey.currentState!.validate()) {
      Tour updatedTour = Tour(
        id: widget.tour.id,
        tourName: _tourNameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        startDate: _startDate ?? DateTime.now(),
        endDate: _endDate ?? DateTime.now(),
        categoryId: 1,
        img: _imgFile != null ? _imgFile!.path.split('/').last : widget.tour.img,
      );

      bool success = await ApiService().editTour(widget.tour.id, updatedTour);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cập nhật tour thành công'),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lỗi khi cập nhật tour'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh Sửa Tour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tourNameController,
                decoration: InputDecoration(labelText: 'Tên Tour'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên tour';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả tour';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Số lượng'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số lượng';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Chọn Hình Ảnh'),
                  ),
                  if (_imgFile != null) Text(_imgFile!.path.split('/').last),
                ],
              ),
              ElevatedButton(
                onPressed: _saveTour,
                child: Text('Cập Nhật Tour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
