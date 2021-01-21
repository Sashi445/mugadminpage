import 'package:flutter/material.dart';
import 'package:mugadminpage/views/create_service_page.dart';


class ServicesandFormsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Service'),
            ),
            DataColumn(
              label: Text('Status')
            ),
          ],
          rows: [
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateService()
            )
          );
        },
      ),
    );
  }
}