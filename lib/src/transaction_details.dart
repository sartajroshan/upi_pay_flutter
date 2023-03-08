import 'package:decimal/decimal.dart';
import 'package:upi_pay/src/applications.dart';
import 'package:upi_pay/src/exceptions.dart';

extension TransParse on String {
  TransactionDetails toTransactionDetails(UpiApplication upiApplication) {
    Map<String, String> params = {};
    Uri.parse(this).queryParameters.forEach((key, value) {
      params[key] = value;
    });

    /*  List<String> parts = this.split('?');

    String encodedParams = parts[1]
        .split('&')
        .map((p) => p.startsWith('pa=') ? p : Uri.encodeComponent(p))
        .join('&');

    String encodedUrl = '${parts[0]}?$encodedParams';*/

    String payeeAddress = params['pa']!;
    String payeeName = params['pn']!;
    String transactionRef = params['tr']!;
    String transactionId = params['tid']!;
    String amount = params['am']!;
    String currency = params['cu']!;
    String transactionNote = params['tn']!;
    return TransactionDetails(
        upiApplication: upiApplication,
        payeeAddress: payeeAddress,
        payeeName: payeeName,
        transactionRef: transactionRef,
        amount: amount,
        currency: currency,
        transactionId: transactionId,
        transactionNote: transactionNote,
        uri: this,
        merchantCode: '');
  }
}

class TransactionDetails {
  static const String _currency = 'INR';
  static const int _maxAmount = 100000;

  final UpiApplication upiApplication;
  final String payeeAddress;
  final String payeeName;
  final String transactionRef, transactionId;
  final String currency;
  final Decimal amount;
  final String? url;
  final String merchantCode;
  final String? transactionNote;
  final String? uri;

  TransactionDetails(
      {required this.upiApplication,
      required this.payeeAddress,
      required this.payeeName,
      required this.transactionRef,
      required this.transactionId,
      this.currency: TransactionDetails._currency,
      required String amount,
      this.url,
      this.merchantCode: '',
      this.transactionNote: 'UPI Transaction',
      this.uri})
      : amount = Decimal.parse(amount) {
    if (!_checkIfUpiAddressIsValid(payeeAddress)) {
      throw InvalidUpiAddressException();
    }
    final Decimal am = Decimal.parse(amount);
    if (am.scale > 2) {
      throw InvalidAmountException(
          'Amount must not have more than 2 digits after decimal point');
    }
    if (am <= Decimal.zero) {
      throw InvalidAmountException('Amount must be greater than 1');
    }
    if (am > Decimal.fromInt(_maxAmount)) {
      throw InvalidAmountException(
          'Amount must be less then 1,00,000 since that is the upper limit '
          'per UPI transaction');
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'app': upiApplication.toString(),
      'pa': payeeAddress,
      'pn': payeeName,
      'tr': transactionRef,
      'tid': transactionId,
      'cu': currency,
      'am': amount.toString(),
      'url': url,
      'mc': merchantCode,
      'tn': transactionNote,
      'uri': uri
    };
  }

  String toString() {
    if (uri == null) {
      String cUri = 'upi://pay?pa=$payeeAddress'
          '&pn=${Uri.encodeComponent(payeeName)}'
          '&tr=$transactionRef'
          '&tid=$transactionId'
          '&tn=${Uri.encodeComponent(transactionNote!)}'
          '&am=${amount.toString()}'
          '&cu=$currency';
      if (url != null && url!.isNotEmpty) {
        cUri += '&url=${Uri.encodeComponent(url!)}';
      }
      if (merchantCode.isNotEmpty) {
        cUri += '&mc=${Uri.encodeComponent(merchantCode)}';
      }
      return cUri;
    }
    Map<String, String> params = {};
    Uri.parse(uri!).queryParameters.forEach((key, value) {
      params[key] = value;
    });

    List<String> parts = uri!.split('?');

    String encodedParams = parts[1]
        .split('&')
        .map((p) => p.startsWith('pa=') ? p : Uri.encodeComponent(p))
        .join('&');

    String encodedUrl = '${parts[0]}?$encodedParams';
    return encodedUrl;
  }
}

bool _checkIfUpiAddressIsValid(String upiAddress) {
  return upiAddress.split('@').length == 2;
}
