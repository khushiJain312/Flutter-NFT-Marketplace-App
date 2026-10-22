import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nft_market/auction_item.dart';
import 'package:nft_market/post.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.item, required this.onFollowChanged, required this.onFavoriteChanged});

  final AuctionItem item;
  final VoidCallback onFollowChanged;
  final VoidCallback onFavoriteChanged;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
        backgroundColor: const Color(0xfff4f6f8),
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width < 600 ? 390 : 520,
              pinned: true,
              backgroundColor: Colors.white,
              leading: Padding(padding: const EdgeInsets.all(7), child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.black)))),
              actions: [Padding(padding: const EdgeInsets.all(7), child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(onPressed: () { widget.onFavoriteChanged(); setState(() {}); }, tooltip: item.isFavorite ? 'Remove from favorites' : 'Add to favorites', icon: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border, color: item.isFavorite ? Colors.pink : Colors.black))))],
              flexibleSpace: FlexibleSpaceBar(background: Stack(fit: StackFit.expand, children: [
                Image.asset('images/${item.image}.png', fit: BoxFit.cover),
                Positioned(left: 18, right: 18, bottom: 30, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _glass(CountdownLabel(endsAt: item.endsAt, compact: false)),
                  _glass(Row(children: [Image.asset('images/et.png', width: 22), const SizedBox(width: 6), Text('${item.price} ETH', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))])),
                ])),
              ])),
            ),
            SliverToBoxAdapter(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 820), child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundImage: AssetImage('images/${item.creatorImage}.png')),
                  title: Text(item.creator, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  subtitle: Text('${item.followers} followers'),
                  trailing: ElevatedButton(onPressed: () { widget.onFollowChanged(); setState(() {}); }, child: Text(item.isFollowing ? 'Following' : 'Follow +')),
                ),
                const Divider(height: 28),
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
                const SizedBox(height: 8),
                Text('${item.category} collectible · Auction ends in:', style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
                const SizedBox(height: 14),
                CountdownLabel(endsAt: item.endsAt),
                const SizedBox(height: 20),
                Text('A unique digital collectible by ${item.creator}. Place your bid before the auction ends.', style: TextStyle(fontSize: 16, height: 1.55, color: Colors.grey.shade700)),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Padding(padding: EdgeInsets.all(14), child: Text('Place a bid')))),
              ]),
            )))),
          ]),
        ),
      );
  }

  Widget _glass(Widget child) => ClipRRect(borderRadius: BorderRadius.circular(10), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), color: Colors.white.withOpacity(.8), child: child)));
}
