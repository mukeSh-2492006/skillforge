import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'SkillSprint',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              'Learn Skills. Track Progress. Grow Together.',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(Icons.person, color: Color(0xFF334155), size: 30),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hi, Student!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Keep going! Your future self will thank you. 😉',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Overall Progress Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: const [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(
                          value: 0.40,
                          strokeWidth: 6,
                          backgroundColor: Color(0xFFDBEAFE),
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      Text(
                        '40%',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Completed Topics',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '12 / 30',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: 0.40,
                            minHeight: 6,
                            backgroundColor: Color(0xFFDBEAFE),
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Keep learning! 🚀',
                          style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Today's Challenge Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.stars_outlined, color: Colors.blue, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "Today's Challenge",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),

            // Today's Challenge Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.code, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Solve a Coding Problem',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Find the missing number in an array.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          icon: const Text('Start Now', style: TextStyle(color: Colors.white, fontSize: 12)),
                          label: const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Your Skills Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.handshake_outlined, color: Colors.blue, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Your Skills',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSkillTile('Python', '40%', Colors.amber.shade100, Colors.orange),
                  _buildSkillTile('DSA', '25%', Colors.purple.shade100, Colors.purple),
                  _buildSkillTile('Java', '15%', Colors.orange.shade100, Colors.deepOrange),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget _buildSkillTile(String name, String progress, Color bgColor, Color iconColor) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.code_rounded, color: iconColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(progress, style: TextStyle(color: iconColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}