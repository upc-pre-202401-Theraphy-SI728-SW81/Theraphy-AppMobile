import 'package:flutter/material.dart';

class NewView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AirpodsCard(),
      ),
    );
  } 
}

class AirpodsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My AirPods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.drive_eta),
                    SizedBox(width: 8),
                    Text('0 min'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.directions_walk),
                    SizedBox(width: 8),
                    Text('5 min'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.battery_full),
                    SizedBox(width: 8),
                    Text('95%'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.play_circle),
                  label: Text('Play sound'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.send),
                  label: Text('326.31 m'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Image(
              image: NetworkImage(
                  "https://icon-library.com/images/internet-of-things-icon/internet-of-things-icon-9.jpg"),
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
