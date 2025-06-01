// widgets/sleep_timeline.dart
import 'package:flutter/material.dart';

class SleepTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          _buildTimelineBar(context),
          SizedBox(height: 8),
          _buildTimeLabels(),
        ],
      ),
    );
  }

  Widget _buildTimelineBar(BuildContext context) {
    return Container(
      height: 40,
      child: Stack(
        children: [
          // Background bar
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          
          // Ideal sleep zone (10 PM - 6 AM)
          Positioned(
            left: MediaQuery.of(context).size.width * 0.75, // 10 PM position
            child: Container(
              width: MediaQuery.of(context).size.width * 0.33, // 8 hours
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xFF1E3A8A).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Sleep block (11 PM - 7 AM)
          Positioned(
            left: MediaQuery.of(context).size.width * 0.79, // 11 PM position
            child: Container(
              width: MediaQuery.of(context).size.width * 0.33, // 8 hours
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Current time indicator
          Positioned(
            left: MediaQuery.of(context).size.width * 0.3, // Current time
            child: Container(
              width: 2,
              height: 30,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('12 AM', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text('6 AM', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text('12 PM', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text('6 PM', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text('12 AM', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}