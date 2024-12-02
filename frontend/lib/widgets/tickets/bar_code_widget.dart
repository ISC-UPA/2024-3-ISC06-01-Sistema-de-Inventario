import 'package:flutter/material.dart';
import 'package:frontend/models/model_restock.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/widgets/price.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BarCodeWidget extends StatelessWidget {
  final String data;
  final double width;
  final double height;

  const BarCodeWidget({
    required this.data,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: width,
      ),
    );
  }
}


Widget ticketDetailsWidget(String firstTitle, List<String> descriptions, ColorScheme theme) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
              ),
              ...descriptions.map((desc) => Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  desc,
                  style: TextStyle(color: theme.secondary),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget ticketProductTitlesWidget(String cantidad, String product, String total, ColorScheme theme) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cantidad,
              style: TextStyle(color: theme.tertiary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8.0), // Ajusta este valor según sea necesario
            Text(
              product,
              style: TextStyle(color: theme.tertiary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          total,
          style: TextStyle(color: theme.tertiary, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget ticketProductDetailsWidget(String cantidad, String product, RestockOrder order, ColorScheme theme, int s) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cantidad,
              style: TextStyle(color: theme.primary),
            ),
            const SizedBox(width: 8.0), // Ajusta este valor según sea necesario
            Text(
              product,
              style: TextStyle(color: theme.primary),
            ),
          ],
        ),
        Price(
          apiServices: ApiServices(),
          restockOrder: order,
          textStyle: TextStyle(color: theme.primary),
          s: s,
        ),
      ],
    ),
  );
}