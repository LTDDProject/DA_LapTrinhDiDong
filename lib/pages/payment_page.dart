import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String paymentUrl;

  const PaymentPage({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: Center(
        child: Text('Vui lòng đợi, bạn sẽ được chuyển đến trang thanh toán...'),
      ),
    );
  }
}
