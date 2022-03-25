import 'package:flutter/material.dart';

class Receipt extends StatefulWidget {
  final String payment_ref;
  final String booking_ref;
  final String property_ref;
  final String property_title;
  final String transaction_id;
  final String amount;
  final String payment_mode;
  final String status;
  final String created_at;

  Receipt({required this.payment_ref, required this.booking_ref, required this.property_ref, required this.property_title,
    required this.transaction_id, required this.amount, required this.payment_mode, required this.status, required this.created_at});
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  var mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Payment Receipt"),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Payment Ref', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.payment_ref, style: TextStyle(fontSize: 16,),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.payment_mode, style: TextStyle(fontSize: 16,),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Amount Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text('UGX '+ widget.amount.replaceAllMapped(reg, mathFunc), style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Transaction ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.transaction_id, style: TextStyle(fontSize: 16,),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Inspection Ref', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.booking_ref, style: TextStyle(fontSize: 16,),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Property Ref', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.property_ref, style: TextStyle(fontSize: 16,),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Property Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.property_title, style: TextStyle(fontSize: 16,),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Transaction Date', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.created_at, style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Transaction Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Text(widget.status, style: TextStyle(fontSize: 16,),),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("For any inquiries", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              SizedBox(height: 5,),
              Text("contact the support center", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              SizedBox(height: 5,),
              Text("Thank You.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            ],
          )
        ],
      ),
    );
  }
}
