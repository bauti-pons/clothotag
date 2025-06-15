// Chat P2P únicamente para pruebas locales ‒ abre dos
// pestañas con la misma roomId y podrás chatear.
//
// En producción sustituye la señalización “in-memory” por
// un servidor (Firestore, Supabase, etc.).

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
  // --------------------------- UI -------------------------------------------
  final _textCtrl = TextEditingController();
  final List<_Msg> _messages = []; // se pintan en pantalla

  // ----------------------- WebRTC (loopback) --------------------------------
  RTCPeerConnection? _peer1, _peer2;
  RTCDataChannel? _chat1, _chat2;

  @override
  void initState() {
    super.initState();
    _initPeers();
  }

  Future<void> _initPeers() async {
    final cfg = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    _peer1 = await createPeerConnection(cfg);
    _peer2 = await createPeerConnection(cfg);

    // DataChannel desde peer1 -> peer2
    _chat1 = await _peer1!.createDataChannel('chat', RTCDataChannelInit());
    _peer2!.onDataChannel = (c) => _chat2 = c;

    // Intercambio SDP
    final offer = await _peer1!.createOffer();
    await _peer1!.setLocalDescription(offer);
    await _peer2!.setRemoteDescription(offer);

    final answer = await _peer2!.createAnswer();
    await _peer2!.setLocalDescription(answer);
    await _peer1!.setRemoteDescription(answer);

    // ICE loopback
    _peer1!.onIceCandidate = (c) => _peer2!.addCandidate(c);
    _peer2!.onIceCandidate = (c) => _peer1!.addCandidate(c);

    // Recepción de mensajes
    _chat1!.onMessage = _onMsg;
    _chat2!.onMessage = _onMsg;
    setState(() {});
  }

  // --------------------- recepción / envío ----------------------------------
  void _onMsg(RTCDataChannelMessage m) {
    final txt = utf8.decode(m.binary);
    setState(() => _messages.add(_Msg(txt, fromMe: false)));
  }

  void _send() {
    final txt = _textCtrl.text.trim();
    if (txt.isEmpty || _chat1 == null) return;

    _chat1!.send(RTCDataChannelMessage.fromBinary(utf8.encode(txt)));
    setState(() => _messages.add(_Msg(txt, fromMe: true)));
    _textCtrl.clear();
  }

  // --------------------------- UI -------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat – ${widget.roomId}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[_messages.length - 1 - i];
                return Align(
                  alignment: msg.fromMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: msg.fromMe
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textCtrl,
                    decoration:
                    const InputDecoration(hintText: 'Mensaje'),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: _send,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _chat1?.close();
    _chat2?.close();
    _peer1?.close();
    _peer2?.close();
    super.dispose();
  }
}

// Modelo interno de mensaje
class _Msg {
  final String text;
  final bool fromMe;
  _Msg(this.text, {required this.fromMe});
}
