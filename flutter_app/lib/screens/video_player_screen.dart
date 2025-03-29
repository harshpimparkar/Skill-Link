//screens/video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const VideoPlayerScreen({required this.arguments, super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _showControls = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late String _title;
  late String _description;
  late String _instructor;
  late String _durationText;
  late DateTime _uploadDate;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
    _initializeVideo(widget.arguments['videoUrl']);
  }

  void _loadMetadata() {
    _title = widget.arguments['title'] ?? 'Untitled Lecture';
    _description =
        widget.arguments['description'] ?? 'No description available';
    _instructor = widget.arguments['instructor'] ?? 'Unknown Instructor';
    _durationText = widget.arguments['duration'] ?? 'N/A';
    _uploadDate = DateTime.tryParse(widget.arguments['uploadDate'] ?? '') ??
        DateTime.now();
  }

  Future<void> _initializeVideo(String videoFileName) async {
    _controller = VideoPlayerController.asset('assets/videos/$videoFileName')
      ..addListener(_videoListener)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _duration = _controller.value.duration;
          });
          _controller.play();
        }
      });
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
        _isBuffering = _controller.value.isBuffering;
        _position = _controller.value.position;
        _duration = _controller.value.duration;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying ? _controller.pause() : _controller.play();
      _isPlaying = !_isPlaying;
    });
  }

  void _skipAhead() {
    final newPosition = _position + const Duration(seconds: 10);
    _controller.seekTo(newPosition < _duration ? newPosition : _duration);
  }

  void _skipBack() {
    final newPosition = _position - const Duration(seconds: 10);
    _controller
        .seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showLectureInfo(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Video Player Section
            GestureDetector(
              onTap: _toggleControls,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),

            // Video Tracker (Progress Bar)
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.blue,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.white54,
              ),
            ),

            // Control Buttons (Visible only when interacted)
            if (_showControls)
              Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white),
                      onPressed: _skipBack,
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white),
                      onPressed: _skipAhead,
                    ),
                  ],
                ),
              ),

            Expanded(child: _buildLectureInfoBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureInfoBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(_instructor, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(_durationText, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  void _showLectureInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Instructor'),
              subtitle: Text(_instructor),
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Duration'),
              subtitle: Text(_durationText),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Upload Date'),
              subtitle: Text(
                  '${_uploadDate.day}/${_uploadDate.month}/${_uploadDate.year}'),
            ),
            const Divider(),
            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_description),
          ],
        ),
      ),
    );
  }
}
