import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nft_market/detail.dart';
import 'package:nft_market/auction_item.dart';

class Post extends StatelessWidget {
  const Post({super.key, required this.item, required this.onFavoriteChanged, required this.onFollowChanged});

  final AuctionItem item;
  final VoidCallback onFavoriteChanged;
  final VoidCallback onFollowChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => Detail(item: item, onFollowChanged: onFollowChanged, onFavoriteChanged: onFavoriteChanged),
            )),
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(fit: StackFit.expand, children: [
                Image.asset('images/${item.image}.png', fit: BoxFit.cover),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black38, Colors.transparent, Colors.transparent, Colors.black54]))),
                Positioned(top: 12, left: 12, child: _glass(child: CountdownLabel(endsAt: item.endsAt, compact: true))),
                Positioned(top: 8, right: 8, child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(.92),
                  child: IconButton(
                    tooltip: item.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                    onPressed: onFavoriteChanged,
                    icon: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border, color: item.isFavorite ? Colors.pink : Colors.black87),
                  ),
                )),
                Positioned(left: 16, right: 16, bottom: 14, child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Row(children: [CircleAvatar(radius: 12, backgroundImage: AssetImage('images/${item.creatorImage}.png')), const SizedBox(width: 7), Text('@${item.creator}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))]),
                  ])),
                  const SizedBox(width: 8),
                  _glass(child: Row(mainAxisSize: MainAxisSize.min, children: [Image.asset('images/et.png', width: 20, height: 20), const SizedBox(width: 5), Text('${item.price} ETH', style: const TextStyle(fontWeight: FontWeight.w700))])),
                ])),
              ]);
            }),
          ),
        ),
      );

  Widget _glass({required Widget child}) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), color: Colors.white.withOpacity(.78), child: child),
        ),
      );
}

class CountdownLabel extends StatefulWidget {
  const CountdownLabel({super.key, required this.endsAt, this.compact = false});
  final DateTime endsAt;
  final bool compact;

  @override
  State<CountdownLabel> createState() => _CountdownLabelState();
}

class _CountdownLabelState extends State<CountdownLabel> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.endsAt.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = widget.endsAt.difference(DateTime.now());
      if (mounted && next.inSeconds != _remaining.inSeconds) setState(() => _remaining = next.isNegative ? Duration.zero : next);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = _remaining.inSeconds < 0 ? 0 : _remaining.inSeconds;
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    final value = days > 0 ? '${days}d ${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m' : '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    return Text(widget.compact ? value : 'Ends in $value', style: TextStyle(fontWeight: FontWeight.w600, fontSize: widget.compact ? 12 : 15));
  }
}
