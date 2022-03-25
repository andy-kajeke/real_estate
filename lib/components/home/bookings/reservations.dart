import 'package:flutter/material.dart';
import 'package:birungi_estates/components/home/bookings/bookings.dart' as first;
import 'package:birungi_estates/components/home/bookings/payment_receipts.dart' as second;

class Reservations extends StatefulWidget {
  final String user_id;

  Reservations({required this.user_id});
  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text("Reservations"),
          bottom: TabBar(controller: controller, tabs: const <Tab>[
            Tab(
                child: Text(
                  "INSPECTIONS",
                  style: TextStyle(fontSize: 16),
                )
            ),
            Tab(
                child: Text(
                  "PAY RECEIPTS",
                  style: TextStyle(fontSize: 16),
                )
            ),
          ]),
        ),
        body: new TabBarView(
            controller: controller,
            children: <Widget>[
              //new first.AllTransactions(),
              new first.Bookings(user_id: widget.user_id,),
              //new second.Transfers(gpaidRef: widget.gpaidRef,),
              new second.PaymentReceipts()
            ]
        )
    );
  }
}
