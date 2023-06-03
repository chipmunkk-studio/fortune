import 'package:flutter/material.dart';

class Post {
  final String image;
  final String title;
  final String description;

  Post({required this.image, required this.title, required this.description});
}

class BoardPage extends StatefulWidget {
  BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final List<Post> posts = [
    Post(
        image:
            'https://zijhkonihriwfrffefwm.supabase.co/storage/v1/object/public/board/image/2023412_16951_melow2@naver.com.txt.png',
        title: 'Post 1',
        description: 'This is the description of post 1'),
    Post(image: 'https://picsum.photos/200', title: 'Post 2', description: 'This is the description of post 2'),
    Post(image: 'https://picsum.photos/200', title: 'Post 3', description: 'This is the description of post 3'),
    Post(image: 'https://picsum.photos/200', title: 'Post 4', description: 'This is the description of post 4'),
  ];

  String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Scan Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Scan Result',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _scanBarcode,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Start barcode scan',
              ),
            ),
          ],
        ),
      ),
    );
  }

}
