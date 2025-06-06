// screens/home_page.dart
import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/sleep_summary_card.dart';
import '../widgets/sleep_timeline.dart';
import '../widgets/quick_actions.dart';
import '../widgets/sleep_tip.dart';
import '../widgets/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAlarmOn = true;
  int sleepStreak = 5;
  double lastNightSleep = 7.5; // hours
  double sleepGoal = 8.0; // hours
  bool hasSleepData = true;

  List<String> sleepTips = [
    "Consistency improves sleep quality!",
    "Avoid screens 1 hour before bed.",
    "Keep your bedroom cool and dark.",
    "Try to wake up at the same time daily.",
  ];
  int currentTipIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SleepSummaryCard(
                      sleepStreak: sleepStreak,
                      lastNightSleep: lastNightSleep,
                      sleepGoal: sleepGoal,
                      hasSleepData: hasSleepData,
                      isAlarmOn: isAlarmOn,
                      onAlarmToggle: (value) {
                        setState(() {
                          isAlarmOn = value;
                        });
                      },
                      onLogSleep: _logSleep,
                    ),
                    SizedBox(height: 24),
                    
                    SleepTimeline(),
                    SizedBox(height: 32),
                    
                    QuickActions(
                      onLogSleep: _logSleep,
                      onSetAlarm: _setAlarm,
                      onViewStats: _viewStats,
                    ),
                    SizedBox(height: 24),
                    
                    SleepTip(tip: sleepTips[currentTipIndex]),
                  ],
                ),
              ),
            ),
            
            BottomNavigation(),
          ],
        ),
      ),
    );
  }

  void _logSleep() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Sleep'),
        content: Text('Sleep logging feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _setAlarm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Alarm'),
        content: Text('Alarm setting feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _viewStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View Stats'),
        content: Text('Statistics feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}