import 'package:ipisp/payment_details.dart';
import 'dart:convert';

class PaymentDetailsJWTParser {

    static PaymentData parseJWT(String jwtToken) {

        String basicInfo = jwtToken.split(".")[1];
        var encoded = ascii.decode(base64.decode(base64.normalize(basicInfo)));
        return PaymentData.fromJson(json.decode(encoded));
    }
}

