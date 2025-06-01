// widgets/quick_actions.dart
import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onLogSleep;
  final VoidCallback onSetAlarm;
  final VoidCallback onViewStats;

  const QuickActions({
    Key? key,
    required this.onLogSleep,
    required this.onSetAlarm,
    required this.onViewStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          icon: Icons.bedtime,
          label: 'Log Sleep',
          onTap: onLogSleep,
        ),
        _buildQuickActionButton(
          icon: Icons.alarm,
          label: 'Set Alarm',
          onTap: onSetAlarm,
        ),
        _buildQuickActionButton(
          icon: Icons.bar_chart,
          label: 'View Stats',
          onTap: onViewStats,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: Color(0xFF1E3A8A),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}