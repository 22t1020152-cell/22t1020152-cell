import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_product.dart';
import 'bai1.dart';
import 'bai2.dart';
import 'formtc.dart';
import 'form.dart';
import 'providers/auth_provider.dart';

/// Trang chủ (hub) kết nối tới các dự án/ màn hình đã làm.
class TrangChuPage extends StatelessWidget {
  const TrangChuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _HubItem(
        title: 'Products',
        subtitle: 'Danh sách sản phẩm (web API)',
        color: Colors.pinkAccent,
        icon: Icons.storefront,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProductListScreen())),
      ),
      _HubItem(
        title: 'Product UI (bai1)',
        subtitle: 'Danh sách lớp (giao diện ví dụ)',
        color: Colors.blueGrey,
        icon: Icons.view_agenda,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MyWidget())),
      ),
      _HubItem(
        title: 'Gallery (bai2)',
        subtitle: 'Lưới ảnh 2x2',
        color: Colors.teal,
        icon: Icons.photo_library,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MyWidget2())),
      ),
      _HubItem(
        title: 'Feedback',
        subtitle: 'Form gửi góp ý',
        color: Colors.deepPurple,
        icon: Icons.feedback,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FeedbackFormPage())),
      ),
      _HubItem(
        title: 'BMI Calculator',
        subtitle: 'Form tính BMI (form.dart)',
        color: Colors.orange,
        icon: Icons.monitor_heart,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const BmiForm())),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ - Hub dự án'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (ctx, authProvider, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: Tooltip(
                    message: authProvider.userData?.username ?? 'User',
                    child: PopupMenuButton<String>(
                      itemBuilder: (ctx) => [
                        const PopupMenuItem<String>(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(Icons.person, size: 20),
                              SizedBox(width: 8),
                              Text('Profile'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 20),
                              SizedBox(width: 8),
                              Text('Đăng xuất'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'logout') {
                          authProvider.logout();
                          Navigator.of(
                            ctx,
                          ).pushNamedAndRemoveUntil('/', (r) => false);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.account_circle),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
          return Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chào bạn!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Chọn một mục bên dưới để mở màn hình tương ứng.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: items.map((i) => _HubCard(item: i)).toList(),
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '© Your Project Hub',
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HubItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  _HubItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });
}

class _HubCard extends StatelessWidget {
  final _HubItem item;
  const _HubCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: item.color.withOpacity(0.15),
                child: Icon(item.icon, color: item.color),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  item.subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: item.onTap,
                  child: const Text(
                    'Mở',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
