import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentUrl = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán VnPay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: paymentUrl != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Thanh toán tại đây:'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(paymentUrl)) {
                  await launch(paymentUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không thể mở URL.')),
                  );
                }
              },
              child: const Text('Mở trình duyệt'),
            ),
          ],
        )
            : const Center(
          child: Text('Không có URL thanh toán!'),
        ),
      ),
    );
  }
}
