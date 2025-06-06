import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../utils/platform_infos.dart';
import 'image_viewer.dart';
import 'media_viewer_app_bar.dart';

class ImageGalleryPage extends StatefulWidget {
  final List<Event> events;
  final int initialIndex;

  const ImageGalleryPage({
    super.key,
    required this.events,
    required this.initialIndex,
  });

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  late final PageController _pageController;
  late int _currentIndex;
  final ValueNotifier<bool> _showAppBar = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _showAppBar.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleAppBar() {
    _showAppBar.value = !_showAppBar.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (PlatformInfos.isWeb) {
            Navigator.of(context).pop();
          } else {
            _toggleAppBar();
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.events.length,
              itemBuilder: (context, index) => ImageViewer(
                event: widget.events[index],
              ),
            ),
            MediaViewerAppBar(
              showAppbarPreviewNotifier: _showAppBar,
              event: widget.events[_currentIndex],
              currentIndex: _currentIndex + 1,
              totalCount: widget.events.length,
            ),
          ],
        ),
      ),
    );
  }
}
