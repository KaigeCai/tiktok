import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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
    videoUrls.shuffle(Random());
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
          return TikTokVideoPlayer(videoController: _videoController);
        },
      ),
    );
  }
}

class TikTokVideoPlayer extends StatefulWidget {
  const TikTokVideoPlayer({
    super.key,
    required VideoPlayerController? videoController,
  }) : _videoController = videoController;

  final VideoPlayerController? _videoController;

  @override
  State<TikTokVideoPlayer> createState() => _TikTokVideoPlayerState();
}

class _TikTokVideoPlayerState extends State<TikTokVideoPlayer> {
  bool _isInteracting = false; // 是否正在交互（显示控制条）
  double _currentProgress = 0; // 当前播放进度百分比
  Timer? _hideTimer; // 自动隐藏的定时器

  @override
  void initState() {
    super.initState();
    widget._videoController?.addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget._videoController?.removeListener(_updateProgress);
    _hideTimer?.cancel();
    super.dispose();
  }

  /// 更新进度
  void _updateProgress() {
    if (widget._videoController != null && widget._videoController!.value.isInitialized) {
      final position = widget._videoController!.value.position;
      final duration = widget._videoController!.value.duration;
      if (duration.inMilliseconds > 0) {
        setState(() {
          _currentProgress = position.inMilliseconds / duration.inMilliseconds;
        });
      }
    }
  }

  /// 长按弹出菜单
  void _showLongPressMenu(BuildContext context, Offset position) {
    if (!mounted) return;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        const PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share, color: Colors.black),
              SizedBox(width: 8),
              Text('分享'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'option2',
          child: Text('选项 2'),
        ),
      ],
    ).then((value) {
      if (value == 'share' && context.mounted) {
        _showShareMenu(context);
      }
    });
  }

  void _showShareMenu(BuildContext context) {
    final currentVideoUrl = widget._videoController!.dataSource; // 当前播放视频链接

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '分享到',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShareOption(
                    context: context,
                    label: 'QQ',
                    icon: 'assets/svg/qq.svg',
                    url: currentVideoUrl,
                  ),
                  _buildShareOption(
                    context: context,
                    label: '微信',
                    icon: 'assets/svg/wechat.svg',
                    url: currentVideoUrl,
                  ),
                  _buildShareOption(
                    context: context,
                    label: '短信',
                    icon: 'assets/svg/sms.svg',
                    url: currentVideoUrl,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建单个分享选项
  Widget _buildShareOption({
    required BuildContext context,
    required String label,
    required String icon,
    required String url,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Share.share(url),
          child: SvgPicture.asset(icon, width: 32.0, height: 32.0),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16.0)),
      ],
    );
  }

  /// 左右滑动控制播放进度
  void _handleHorizontalDrag(DragUpdateDetails details) {
    if (widget._videoController != null && widget._videoController!.value.isInitialized) {
      final controller = widget._videoController!;
      final position = controller.value.position;
      final duration = controller.value.duration;

      if (duration.inMilliseconds > 0) {
        // 滑动步长与屏幕宽度成比例
        final delta = details.primaryDelta! / context.size!.width;

        // 根据步长调整时间
        final deltaTime = Duration(
          milliseconds: (delta * duration.inMilliseconds).toInt(),
        );

        // 计算新的播放位置
        var newPosition = position + deltaTime;

        // 修正播放位置到合法范围
        if (newPosition < Duration.zero) {
          newPosition = Duration.zero;
        } else if (newPosition > duration) {
          newPosition = duration;
        }

        // 跳转到新位置
        controller.seekTo(newPosition);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget._videoController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final position = controller.value.position;
    final duration = controller.value.duration;
    final progressText = "${_formatDuration(position)} / ${_formatDuration(duration)}";

    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
      onLongPressStart: (details) => _showLongPressMenu(context, details.globalPosition),
      onHorizontalDragUpdate: _handleHorizontalDrag,
      onHorizontalDragStart: (_) {
        setState(() {
          _isInteracting = true;
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() {
          _isInteracting = false;
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          if (_isInteracting)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Slider(
                    value: _currentProgress,
                    onChanged: (value) {
                      final newPosition = Duration(
                        milliseconds: (value * duration.inMilliseconds).toInt(),
                      );
                      controller.seekTo(newPosition);
                      setState(() {
                        _isInteracting = true;
                      });
                    },
                  ),
                  Text(
                    progressText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 格式化时间
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
