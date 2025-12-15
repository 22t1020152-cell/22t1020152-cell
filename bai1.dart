import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Danh sách lớp'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        children: const [
          CourseCard(
            title: 'xml và ứng dụng - nhóm 1',
            code: '2025-2026/tin4588.9087',
            members: '58 học viên',
          ),
          SizedBox(height: 8),
          CourseCard(
            title: 'cơ sở dữ liệu - nhóm 3',
            code: '2025-2026/tin45670987',
            members: '56 thành viên',
          ),
          SizedBox(height: 8),
          CourseCard(
            title: 'cấu trúc dữ liệu - nhóm 4',
            code: '2025-2026/tin98763456',
            members: '37 thành viên',
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String code;
  final String members;

  const CourseCard({
    super.key,
    required this.title,
    required this.code,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.blueGrey.shade800,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.more_horiz, color: Colors.white70),
                ],
              ),
              const SizedBox(height: 8),
              Text(code, style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(members, style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
