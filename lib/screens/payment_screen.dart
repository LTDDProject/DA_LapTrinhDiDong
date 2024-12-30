import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentUrl = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán VnPay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: paymentUrl != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Thanh toán tại đây:'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(paymentUrl)) {
                  await launch(paymentUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Không thể mở URL.')),
                  );
                }
              },
              child: Text('Mở trình duyệt'),
            ),
          ],
        )
            : Center(
          child: Text('Không có URL thanh toán!'),
        ),
      ),
    );
  }
}
