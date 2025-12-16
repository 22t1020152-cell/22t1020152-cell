import 'package:flutter/material.dart';

class ProjectLayoutPage extends StatelessWidget {
  const ProjectLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bố cục dự án'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            // Chia các phần đều nhau theo chiều dọc
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              // Phần đầu: tên "dự án flutter"
              Text(
                'dự án flutter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Ở giữa: icon trái tim
              Icon(
                Icons.favorite,
                size: 64,
                color: Colors.redAccent,
              ),
              // Cuối: chữ "làm dự án"
              Text(
                'làm dự án',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


