import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class AddPaymentDetailScreen extends StatefulWidget {
  const AddPaymentDetailScreen({super.key});

  @override
  State<AddPaymentDetailScreen> createState() => _AddPaymentDetailScreenState();
}

class _AddPaymentDetailScreenState extends State<AddPaymentDetailScreen> {

  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset("assets/google_pay_config.json");
  }

  void onGooglePayResult(paymentResult) {
    debugPrint('Payment result: ${paymentResult.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaymentConfiguration>(
      future: _googlePayConfigFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GooglePayButton(
              paymentConfiguration: snapshot.data!,
              onPaymentResult: onGooglePayResult,
              loadingIndicator: Center(
                child: CircularProgressIndicator(),
              ),
              paymentItems: [
                PaymentItem(
                    amount: '1.00',
                  label: 'Total',
                  status: PaymentItemStatus.final_price,
                )
              ],
            type: GooglePayButtonType.pay,
            margin: EdgeInsets.only(top: 15),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
