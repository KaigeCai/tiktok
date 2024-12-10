import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'video_urls.dart';

class TikTok extends StatefulWidget {
  const TikTok({super.key});

  @override
  State<TikTok> createState() => _TikTokState();
}

class _TikTokState extends State<TikTok> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late List<String> videoUrls;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;
  bool _isConnected = true; // 网络连接状态
  bool _isControllerInitialized = false; // 用来标记视频控制器是否初始化

  @override
  void initState() {
    videoUrls = getVideoUrls();
    _pageController = PageController(initialPage: 1); // 初始页面设置为 1
    _checkConnectivity(); // 初始化时检查网络状态
    _initializeVideoPlayer(_currentIndex);
    super.initState();
  }

  /// 检查网络连接
  Future<void> _checkConnectivity() async {
    Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        if (mounted) {
          setState(() {
            // 如果集合中包含 Wi-Fi 或移动网络，则认为有网络连接
            _isConnected = results.contains(
                  ConnectivityResult.wifi,
                ) ||
                results.contains(
                  ConnectivityResult.mobile,
                );
          });
        }
      },
      onError: (error) {
        debugPrint("网络状态监听错误: $error");
      },
    );
  }

  Future<void> _initializeVideoPlayer(int index) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrls[index]),
    )..initialize().then(
        (_) {
          if (mounted) {
            setState(() {
              _isControllerInitialized = true;
            });
            _videoController!.play();
            _videoController!.setLooping(true);
          }
        },
      );
  }

  /// 处理首尾过渡的跳转逻辑
  void _handlePageChange(int index) {
    if (index == 0) {
      // 滑动到虚拟第一页，跳转到实际最后一页
      _pageController.jumpToPage(videoUrls.length);
      setState(() {
        _currentIndex = videoUrls.length - 1;
      });
      _initializeVideoPlayer(_currentIndex);
    } else if (index == videoUrls.length + 1) {
      // 滑动到虚拟最后一页，跳转到实际第一页
      _pageController.jumpToPage(1);
      setState(() {
        _currentIndex = 0;
      });
      _initializeVideoPlayer(_currentIndex);
    } else {
      // 正常页面滑动
      setState(() {
        _currentIndex = index - 1;
      });
      _initializeVideoPlayer(_currentIndex);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (!_isConnected) {
      // 未连接网络时的界面
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                "未连接互联网",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: videoUrls.length + 2, // 包括虚拟首尾页
        onPageChanged: _handlePageChange,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          // 等待视频控制器初始化完成
          if (!_isControllerInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          );
        },
      ),
    );
  }
}
