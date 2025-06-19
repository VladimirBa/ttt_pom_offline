import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'online_game_room_page.dart';
import '../widgets/neon_button.dart';
import 'package:share_plus/share_plus.dart'; // Добавлен пакет шаринга

class OnlineGameSetupPage extends StatefulWidget {
  final bool isHost;

  const OnlineGameSetupPage({super.key, required this.isHost});

  @override
  State<OnlineGameSetupPage> createState() => _OnlineGameSetupPageState();
}

class _OnlineGameSetupPageState extends State<OnlineGameSetupPage> {
  final _playerNameController = TextEditingController();
  final _roomIdController = TextEditingController();
  final _scrollController = ScrollController();
  String? _playerNameError;
  String? _roomIdError;
  bool _isArrowHighlighted = false;
  final int _maxNameLength = 12;
  final int _maxRoomIdLength = 8;
  WebSocketChannel? _channel;
  String? _playerId;
  String? _hostName;
  String? _guestName;

  @override
  void initState() {
    super.initState();
    _playerId = _generateShortId();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        setState(() => _isArrowHighlighted = false);
      } else {
        setState(() => _isArrowHighlighted = true);
      }
    });
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _roomIdController.dispose();
    _scrollController.dispose();
    _channel?.sink.close();
    super.dispose();
  }

  String _generateShortId() {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(
        Iterable.generate(
          8,
              (_) => chars.codeUnitAt(random.nextInt(chars.length)),
        ));
    }

  bool _isValidRoomId(String roomId) {
    return roomId.isNotEmpty && roomId.length <= _maxRoomIdLength;
  }

  void _createRoom() {
    String playerName = _playerNameController.text.trim();
    if (playerName.isEmpty) {
      setState(() => _playerNameError = 'Please enter a player name');
      return;
    }
    String roomId = _roomIdController.text.trim().isEmpty
        ? _generateShortId()
        : _roomIdController.text.trim();
    setState(() {
      _roomIdController.text = roomId;
      _playerNameError = null;
    });
  }

  void _joinRoom(String playerName, String roomId) {
    if (playerName.isEmpty) {
      setState(() => _playerNameError = 'Please enter a player name');
      return;
    }
    if (!_isValidRoomId(roomId)) {
      setState(() => _roomIdError = 'Please enter a valid Room ID (max 8 chars)');
      return;
    }
    _connectToRoom(playerName, roomId);
  }

  void _connectToRoom(String playerName, String roomId) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(
            'ws://192.168.31.250:8080?room=$roomId&player=$_playerId&name=$playerName'),
      );

      _channel!.stream.listen(
            (message) {
          final data = jsonDecode(message);
          debugPrint('WebSocket message: $data');

          if (data['type'] == 'error') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['message'])),
            );
            _channel?.sink.close();
            return;
          }

          if (data['type'] == 'playerJoined') {
            final players = data['players'] as List<dynamic>;
            setState(() {
              _hostName = players.firstWhere((p) => p['playerId'] == players[0]['playerId'])['playerName'];
              _guestName = players.length > 1
                  ? players.firstWhere((p) => p['playerId'] == players[1]['playerId'])['playerName']
                  : null;
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OnlineGameRoomPage(
                  playerName: playerName,
                  roomId: roomId,
                  isHost: widget.isHost,
                  hostName: _hostName!,
                  guestName: _guestName,
                ),
              ),
            );
          }
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to connect to the server')),
          );
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
        },
      );
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  // ФИКС: Реализация шаринга Room ID
  void _shareRoomId() {
    String roomId = _roomIdController.text.trim();
    if (roomId.isNotEmpty) {
      Share.share(
        'Join my Tic Tac Toe game! Room ID: $roomId',
        subject: 'Tic Tac Toe Room Invitation',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create Room ID first')),
      );
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth < 400 ? 24 : 28;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Setup Online Game',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.isHost
                                ? 'Create and share Room ID to play! (Server: 192.168.31.250:8080)'
                                : 'Enter Room ID to join the game! (Server: 192.168.31.250:8080)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _playerNameController,
                            decoration: InputDecoration(
                              label: RichText(
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 12),
                                  children: const [
                                    TextSpan(text: 'Player Name '),
                                    TextSpan(
                                      text: '(Turn first, ',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    TextSpan(
                                      text: 'Red',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ', X)',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              hintText: 'Enter your name',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: const OutlineInputBorder(),
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              helperText:
                              '${_playerNameController.text.length}/$_maxNameLength',
                              helperStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              counterText: '',
                              errorText: _playerNameError,
                            ),
                            maxLength: _maxNameLength,
                            style: TextStyle(
                              fontSize:
                              _playerNameController.text.length == _maxNameLength ? 12 : 14,
                              fontFamily: 'Roboto',
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _roomIdController,
                            decoration: InputDecoration(
                              labelText: 'Room ID',
                              hintText: widget.isHost
                                  ? 'Enter or generate Room ID'
                                  : 'Paste Room ID from host',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: const OutlineInputBorder(),
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              helperText:
                              '${_roomIdController.text.length}/$_maxRoomIdLength',
                              helperStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              counterText: '',
                              errorText: _roomIdError,
                            ),
                            maxLength: _maxRoomIdLength,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
                            child: Center(
                              child: GestureDetector(
                                onTap: _scrollToBottom,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  transform: _isArrowHighlighted
                                      ? Matrix4.translationValues(0, -5, 0)
                                      : Matrix4.identity(),
                                  child: Icon(
                                    Icons.keyboard_double_arrow_down,
                                    size: 40,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                            height: 50,
                            child: NeonButton(
                              text: 'Join Room',
                              icon: Icons.login,
                              onPressed: () {
                                debugPrint('Join Room pressed');
                                String playerName = _playerNameController.text.trim();
                                String roomId = _roomIdController.text.trim();
                                _joinRoom(playerName, roomId);
                              },
                            ),
                          ),
                          if (widget.isHost)
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                                  height: 50,
                                  child: NeonButton(
                                    text: 'Create Room ID',
                                    icon: Icons.add,
                                    onPressed: () {
                                      debugPrint('Create Room ID pressed');
                                      _createRoom();
                                    },
                                  ),
                                ),
                                if (_roomIdController.text.trim().isNotEmpty &&
                                    _isValidRoomId(_roomIdController.text.trim()))
                                  Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: screenWidth * 0.7 < 300 ? 300 : screenWidth * 0.7,
                                        height: 50,
                                        child: NeonButton(
                                          text: 'Share Room ID',
                                          icon: Icons.share,
                                          onPressed: () {
                                            debugPrint('Share Room ID pressed');
                                            _shareRoomId(); // Вызов исправленной функции
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}