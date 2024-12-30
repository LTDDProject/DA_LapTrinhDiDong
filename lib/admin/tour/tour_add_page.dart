import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/tour.dart';
import '../../services/tour_service.dart';

class TourAddPage extends StatefulWidget {
  final Tour? tour;

  TourAddPage({this.tour});

  @override
  _TourAddPageState createState() => _TourAddPageState();
}

class _TourAddPageState extends State<TourAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tourNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _imgFile;
  final ImagePicker _picker = ImagePicker();

  List<Category> _categories = [];
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.tour != null) {
      _tourNameController.text = widget.tour!.tourName;
      _descriptionController.text = widget.tour!.description;
      _priceController.text = widget.tour!.price.toString();
      _quantityController.text = widget.tour!.quantity.toString();
      _startDate = widget.tour!.startDate;
      _endDate = widget.tour!.endDate;
      _selectedCategoryId = widget.tour!.categoryId;
    }
  }

  void _loadCategories() async {
    try {
      List<Category> categories = await ApiService().fetchCategories();
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty && _selectedCategoryId == null) {
          _selectedCategoryId = _categories[0].categoryId;
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load categories')));
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imgFile = File(pickedFile.path); // Sử dụng File với path
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to pick image')));
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime selectedDate = _startDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate)
      setState(() {
        _startDate = picked;
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime selectedDate = _endDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate)
      setState(() {
        _endDate = picked;
      });
  }

  void _saveTour() async {
    if (_formKey.currentState!.validate()) {
      Tour newTour = Tour(
        tourId: widget.tour?.tourId ?? 0,
        tourName: _tourNameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        startDate: _startDate ?? DateTime.now(),
        endDate: _endDate ?? DateTime.now(),
        categoryId: _selectedCategoryId ?? 1,
        img: _imgFile != null ? _imgFile!.path.split('/').last : '', // Sử dụng tên file
      );

      bool success = widget.tour == null
          ? await ApiService().addTour(newTour, _imgFile!)
          : await ApiService().editTour(widget.tour!.tourId, newTour);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text(widget.tour == null ? 'Thêm tour thành công' : 'Cập nhật tour thành công'),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi khi lưu tour')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tour == null ? 'Thêm Tour' : 'Chỉnh Sửa Tour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                    if (double.tryParse(value) == null || double.parse(value) < 0) {
                      return 'Giá phải là số dương';
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
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Số lượng phải là số dương';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(labelText: 'Chọn Danh Mục'),
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.categoryId,
                      child: Text(category.categoryName),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategoryId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn danh mục';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Text(_startDate == null
                        ? 'Chọn ngày bắt đầu'
                        : '${_startDate!.toLocal()}'.split(' ')[0]),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectStartDate(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(_endDate == null
                        ? 'Chọn ngày kết thúc'
                        : '${_endDate!.toLocal()}'.split(' ')[0]),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectEndDate(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Chọn Hình Ảnh'),
                    ),
                    if (_imgFile != null) ...[
                      SizedBox(width: 10),
                      Image.file(
                        _imgFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ],
                ),

                ElevatedButton(
                  onPressed: _saveTour,
                  child: Text(widget.tour == null ? 'Thêm Tour' : 'Cập Nhật Tour'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
