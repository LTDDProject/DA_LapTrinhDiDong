import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';  // Assuming this is where AuthService is defined.
import '../models/booktour_request.dart';

class BookTourScreen extends StatefulWidget {
  final int tourId;

  BookTourScreen({required this.tourId});

  @override
  _BookTourScreenState createState() => _BookTourScreenState();
}

class _BookTourScreenState extends State<BookTourScreen> {
  int _quantity = 1;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = '$_quantity';
  }

  Future<void> _bookTour() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = await AuthService.getUserId();
      if (userId == null || userId <= 0) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User chưa đăng nhập.';
        });
        return;
      }

      final url = 'http://192.168.1.107:5001/api/v1/book-tour';
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(BookTourRequest(
          tourId: widget.tourId,
          quantity: _quantity,
          userId: userId, // Pass the userId
        ).toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService.getToken()}',
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final paymentUrl = responseData['paymentUrl'];

        if (paymentUrl != null) {
          Navigator.pushNamed(
            context,
            '/payment',
            arguments: paymentUrl,
          );
        } else {
          setState(() {
            _errorMessage = 'Không tìm thấy URL thanh toán.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Đã xảy ra lỗi: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi hệ thống: $e';
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _quantityController.text = '$_quantity';
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = '$_quantity';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt Tour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _decrementQuantity,
                  icon: Icon(Icons.remove),
                ),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Số lượng',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _quantity = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: _incrementQuantity,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _bookTour,
              child: Text('Đặt Tour'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
