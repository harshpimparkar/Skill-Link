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
  bool _showControls = true; // Initially show controls
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 1.0; // Initial volume at 100%
  bool _isMuted = false;
  late String _title;
  late String _description;
  late String _instructor;
  late String _durationText;
  late DateTime _uploadDate;
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMetadata();
    _initializeVideo(widget.arguments['videoUrl']);

    // Auto-hide controls after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
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

  Future<void> _initializeVideo(String videoUrl) async {
    try {
      // Use network video URL instead of asset
      _controller = VideoPlayerController.network(videoUrl)
        ..addListener(_videoListener)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _duration = _controller.value.duration;
              _isPlaying = true;
              _isInitializing = false;
            });
            _controller.play();
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _isInitializing = false;
              _hasError = true;
              _errorMessage = 'Failed to load video: ${error.toString()}';
            });
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _hasError = true;
          _errorMessage = 'Failed to initialize video: ${e.toString()}';
        });
      }
    }
  }

  void _retryVideoLoading() {
    if (mounted) {
      setState(() {
        _isInitializing = true;
        _hasError = false;
        _errorMessage = '';
      });
      _initializeVideo(widget.arguments['videoUrl']);
    }
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

  void _setVolume(double value) {
    setState(() {
      _volume = value;
      _controller.setVolume(value);
      _isMuted = value == 0;
    });
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        // If currently muted, restore to previous volume or set to 1.0
        _controller.setVolume(_volume > 0 ? _volume : 1.0);
        _isMuted = false;
      } else {
        // If not muted, store current volume and set to 0
        _controller.setVolume(0);
        _isMuted = true;
      }
    });
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

      // Auto-hide controls after 5 seconds
      if (_showControls) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _showControls) {
            setState(() {
              _showControls = false;
            });
          }
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
            // Video Player Section with improved layout
            Expanded(
              flex: 3,
              child: _buildVideoSection(),
            ),

            // Lecture information section
            Expanded(
              flex: 2,
              child: _buildLectureInfoSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    // If we're still initializing, show loading indicator
    if (_isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    // If there was an error loading the video
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retryVideoLoading,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // If video is loaded successfully
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          Container(
            color: Colors.black,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
          ),

          // Buffering indicator
          if (_isBuffering)
            const CircularProgressIndicator(
              color: Colors.white54,
            ),

          // Play/Pause button (large, center)
          if (_showControls)
            IconButton(
              iconSize: 64,
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white.withOpacity(0.8),
              ),
              onPressed: _togglePlayPause,
            ),

          // Controls overlay (bottom)
          if (_showControls)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar with time labels
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 2,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 12,
                                ),
                              ),
                              child: Slider(
                                value: _position.inMilliseconds.toDouble(),
                                min: 0,
                                max: _duration.inMilliseconds.toDouble() == 0
                                    ? 1
                                    : _duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  _controller.seekTo(
                                      Duration(milliseconds: value.toInt()));
                                },
                                activeColor: Colors.blue,
                                inactiveColor: Colors.grey,
                              ),
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left controls
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10,
                                  color: Colors.white),
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
                              icon: const Icon(Icons.forward_10,
                                  color: Colors.white),
                              onPressed: _skipAhead,
                            ),
                          ],
                        ),

                        // Volume controls on the right
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isMuted || _volume == 0
                                    ? Icons.volume_off
                                    : (_volume < 0.5
                                        ? Icons.volume_down
                                        : Icons.volume_up),
                                color: Colors.white,
                              ),
                              onPressed: _toggleMute,
                            ),
                            SizedBox(
                              width: 100,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 2,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 12,
                                  ),
                                ),
                                child: Slider(
                                  value: _isMuted ? 0 : _volume,
                                  min: 0,
                                  max: 1,
                                  divisions: 10,
                                  onChanged: _setVolume,
                                  activeColor: Colors.blue,
                                  inactiveColor: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLectureInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Instructor and duration info
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _instructor,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _durationText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${_uploadDate.day}/${_uploadDate.month}/${_uploadDate.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showLectureInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
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
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_description),
              ],
            ),
          );
        },
      ),
    );
  }
}
