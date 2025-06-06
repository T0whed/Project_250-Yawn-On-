// widgets/sleep_summary_card.dart
import 'package:flutter/material.dart';

class SleepSummaryCard extends StatelessWidget {
  final int sleepStreak;
  final double lastNightSleep;
  final double sleepGoal;
  final bool hasSleepData;
  final bool isAlarmOn;
  final Function(bool) onAlarmToggle;
  final VoidCallback onLogSleep;

  const SleepSummaryCard({
    Key? key,
    required this.sleepStreak,
    required this.lastNightSleep,
    required this.sleepGoal,
    required this.hasSleepData,
    required this.isAlarmOn,
    required this.onAlarmToggle,
    required this.onLogSleep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sleepPercentage = (lastNightSleep / sleepGoal) * 100;
    Color progressColor = sleepPercentage >= 90 
        ? Colors.green 
        : sleepPercentage >= 70 
            ? Colors.orange 
            : Colors.red;

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
          _buildStreakDisplay(),
          SizedBox(height: 16),
          _buildSleepStats(sleepPercentage, progressColor),
          SizedBox(height: 16),
          _buildLogSleepButton(),
          SizedBox(height: 16),
          _buildAlarmStatus(),
        ],
      ),
    );
  }

  Widget _buildStreakDisplay() {
    return Row(
      children: [
        Text('🔥', style: TextStyle(fontSize: 20)),
        SizedBox(width: 8),
        Text(
          sleepStreak > 0 ? '$sleepStreak-Day Streak' : 'Start Your Streak!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: sleepStreak > 0 ? Colors.orange[800] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSleepStats(double sleepPercentage, Color progressColor) {
    if (hasSleepData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slept: ${lastNightSleep.toStringAsFixed(1)}h | Goal: ${sleepGoal.toStringAsFixed(0)}h',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (sleepPercentage / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        'No sleep data for last night',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      );
    }
  }

  Widget _buildLogSleepButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onLogSleep,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          hasSleepData ? 'Update Sleep' : 'Tap to log last night',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildAlarmStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Alarm: 7:00 AM (Tomorrow)',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        Switch(
          value: isAlarmOn,
          onChanged: onAlarmToggle,
          activeColor: Color(0xFF1E3A8A),
        ),
      ],
    );
  }
}