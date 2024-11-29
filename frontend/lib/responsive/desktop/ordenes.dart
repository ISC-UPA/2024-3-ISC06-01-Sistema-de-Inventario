import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/drawer.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderDesktop extends StatefulWidget {
  const OrderDesktop({super.key});

  @override
  _OrderDesktopState createState() => _OrderDesktopState();
}

class _OrderDesktopState extends State<OrderDesktop> {
  int selectedCategoryIndex = 0;
  final List<String> categories = [
    'Todos',
    'Abierto',
    'Pendiente',
    'Cerrado',
    'Cancelado'
  ];
  late List<int> allTickets;

  @override
  void initState() {
    super.initState();
    allTickets = List<int>.generate(7, (index) => index + 1);
  }

  List<int> getFilteredTickets() {
    if (selectedCategoryIndex == 0) {
      return allTickets;
    } else if (selectedCategoryIndex == 1) {
      return allTickets.where((ticket) => ticket % 2 != 0).toList();
    } else {
      return allTickets.where((ticket) => ticket % 2 == 0).toList();
    }
  }

  int calculateCrossAxisCount(double width) {
    if (width > 1200) {
      return 3;
    } else if (width > 800) {
      return 2;
    } else if (width > 600) {
      return 1;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<int> filteredTickets = getFilteredTickets();
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = calculateCrossAxisCount(screenWidth);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const DesktopMenu(),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    List.generate(categories.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            selectedCategoryIndex == index
                                                ? Colors.blue
                                                : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedCategoryIndex = index;
                                        });
                                      },
                                      child: Text(categories[index]),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 30.0,
                              mainAxisSpacing: 30.0,
                            ),
                            itemCount: filteredTickets.length,
                            itemBuilder: (context, index) {
                              return TicketWidget(
                                width: 350,
                                height: 600,
                                isCornerRounded: true,
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: TicketData(
                                      ticketNumber: filteredTickets[index]),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TicketData extends StatelessWidget {
  final int ticketNumber;

  const TicketData({super.key, required this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: const Center(
                child: Text(
                  'Business Class',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            const Row(
              children: [
                Text(
                  'LHR',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.flight_takeoff,
                    color: Colors.pink,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'ISL',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Flight Ticket',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget(
                  'Passengers', 'Hafiz M Mujahid', 'Date', '28-08-2022'),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 52.0),
                child: ticketDetailsWidget('Flight', '76836A45', 'Gate', '66B'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 53.0),
                child: ticketDetailsWidget('Class', 'Business', 'Seat', '21B'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
          child: BarcodeWidget(
            data: 'Ticket $ticketNumber',
            barcode: Barcode.code128(),
            width: 200,
            height: 80,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0, left: 75.0, right: 75.0),
          child: Text(
            '0000 +9230 2884 5163',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text('         Developer: instagram.com/DholaSain')
      ],
    );
  }
}

class BarcodeWidget extends StatelessWidget {
  final String data;
  final Barcode barcode;
  final double width;
  final double height;

  const BarcodeWidget({
    required this.data,
    required this.barcode,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final svg = barcode.toSvg(data, width: width, height: height);
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.string(svg),
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
