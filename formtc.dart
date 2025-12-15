import 'package:flutter/material.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Các biến để lưu dữ liệu từ Form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int? _rating; // đánh giá sao

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Gửi phản hồi'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blueGrey,
                          child: const Icon(
                            Icons.feedback,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Gửi phản hồi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Chúng tôi trân trọng mọi góp ý để cải thiện',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Họ tên
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Họ tên',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập họ tên';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Đánh giá sao (custom)
                          const Text(
                            'Đánh giá',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (i) {
                              final starIndex = i + 1;
                              return IconButton(
                                onPressed: () =>
                                    setState(() => _rating = starIndex),
                                icon: Icon(
                                  _rating != null && _rating! >= starIndex
                                      ? Icons.star
                                      : Icons.star_border,
                                  color:
                                      _rating != null && _rating! >= starIndex
                                      ? Colors.amber
                                      : Colors.grey,
                                ),
                                tooltip: '$starIndex sao',
                              );
                            }),
                          ),
                          if (_rating == null)
                            const Padding(
                              padding: EdgeInsets.only(left: 12.0, top: 4.0),
                              child: Text(
                                'Vui lòng chọn số sao',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),

                          // Nội dung góp ý
                          TextFormField(
                            controller: _contentController,
                            decoration: const InputDecoration(
                              labelText: 'Nội dung góp ý',
                              prefixIcon: Icon(Icons.comment),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập nội dung góp ý';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Nút gửi
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final formValid =
                                    _formKey.currentState?.validate() ?? false;
                                final ratingValid = _rating != null;
                                if (!ratingValid) {
                                  setState(() {}); // để hiển thị thông báo
                                }
                                if (formValid && ratingValid) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Xác nhận gửi'),
                                      content: Text(
                                        'Bạn chắc chắn muốn gửi phản hồi?\n\nTên: ${_nameController.text}\nSao: $_rating\nGóp ý: ${_contentController.text}',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Hủy'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Cảm ơn! Phản hồi đã được gửi.',
                                                ),
                                              ),
                                            );
                                            _formKey.currentState?.reset();
                                            setState(() => _rating = null);
                                            _nameController.clear();
                                            _contentController.clear();
                                          },
                                          child: const Text('Gửi'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Gửi phản hồi',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
