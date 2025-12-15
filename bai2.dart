import 'package:flutter/material.dart';

class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample network images (replace with assets if you prefer)
    final urls = [
      'https://picsum.photos/seed/1/800',
      'https://picsum.photos/seed/2/800',
      'https://picsum.photos/seed/3/800',
      'https://picsum.photos/seed/4/800',
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_alert_sharp),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add_alarm_sharp),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Welcome, Charlie',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Tìm kiếm',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  child: const Icon(Icons.filter_list),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid with 2 columns => 2x2 display for 4 items
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1, // square tiles
                children: List.generate(4, (index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image: using network here so it runs without extra setup.
                        // To use local assets, see instructions below.
                        Image.network(
                          urls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 40),
                                ),
                              ),
                        ),
                        Positioned(
                          left: 8,
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Ảnh ${index + 1}',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
How to use local images (assets) instead of network images:

1) Create a folder `assets/images` at the project root and put 4 images there, e.g.
   - assets/images/img1.jpg
   - assets/images/img2.jpg
   - assets/images/img3.jpg
   - assets/images/img4.jpg

2) In `pubspec.yaml` add:

flutter:
  assets:
    - assets/images/img1.jpg
    - assets/images/img2.jpg
    - assets/images/img3.jpg
    - assets/images/img4.jpg

   (or add the whole folder with `- assets/images/`)

3) Replace `Image.network(urls[index], ...)` with
   `Image.asset('assets/images/img${index+1}.jpg', fit: BoxFit.cover)`

4) Run `flutter pub get` and then `flutter run`.
*/
