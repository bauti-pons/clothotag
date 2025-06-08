// ----------- solo para pruebas en 2 pestañas del mismo navegador/red -----------

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.roomId});
  final String roomId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _msgCtrl = TextEditingController();
  final _messages = <String>[];

  RTCPeerConnection? _peer1;
  RTCPeerConnection? _peer2;
  RTCDataChannel? _chat1;
  RTCDataChannel? _chat2;

  @override
  void initState() {
    super.initState();
    _initConnection();
  }

  Future<void> _initConnection() async {
    final config = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };
    _peer1 = await createPeerConnection(config);
    _peer2 = await createPeerConnection(config);

    // data channel desde peer1 -> peer2
    _chat1 = await _peer1!.createDataChannel('chat', RTCDataChannelInit());
    _peer2!.onDataChannel = (channel) => _chat2 = channel;

    // intercambio de SDP
    final offer = await _peer1!.createOffer();
    await _peer1!.setLocalDescription(offer);
    await _peer2!.setRemoteDescription(offer);

    final answer = await _peer2!.createAnswer();
    await _peer2!.setLocalDescription(answer);
    await _peer1!.setRemoteDescription(answer);

    // intercambio de ICE (local loop)
    _peer1!.onIceCandidate = (c) => _peer2!.addCandidate(c);
    _peer2!.onIceCandidate = (c) => _peer1!.addCandidate(c);

    // recepción de mensajes
    _chat1!.onMessage = _onMsg;
    _chat2!.onMessage = _onMsg;
    setState(() {});
  }

  void _onMsg(RTCDataChannelMessage msg) {
    final text = utf8.decode(msg.binary);
    setState(() => _messages.add(text));
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _chat1 == null) return;
    _chat1!.send(RTCDataChannelMessage.fromBinary(utf8.encode(text)));
    _msgCtrl.clear();
  }

  @override
  void dispose() {
    _peer1?.close();
    _peer2?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat – ${widget.roomId}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, i) => ListTile(title: Text(_messages.reversed.toList()[i])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(hintText: 'Mensaje'),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
