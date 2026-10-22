import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nft_market/auction_item.dart';
import 'package:nft_market/post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final TabController _controller;
  int _navigationIndex = 0;
  final List<AuctionItem> _items = [
    AuctionItem(creator: 'ali', name: 'Power of the Night', price: '10', image: '1', creatorImage: 'h2', category: 'Art', endsAt: DateTime.now().add(const Duration(days: 1, hours: 2, minutes: 20))),
    AuctionItem(creator: 'alireza', name: 'Digital Dreams', price: '50', image: '2', creatorImage: 'h3', category: 'Game', endsAt: DateTime.now().add(const Duration(hours: 3, minutes: 30))),
    AuctionItem(creator: 'abdoul', name: 'Sound of Space', price: '20', image: '3', creatorImage: 'h2', category: 'Music', endsAt: DateTime.now().add(const Duration(minutes: 45))),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesOnly = _navigationIndex == 1;
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final category = const ['New', 'Art', 'Game', 'Music'][_controller.index];
                final visible = _items.where((item) =>
                    (!favoritesOnly || item.isFavorite) &&
                    (category == 'New' || item.category == category)).toList();
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _header()),
                    SliverToBoxAdapter(child: _sectionTitle(favoritesOnly ? 'Your favorites' : 'Live auctions')),
                    if (!favoritesOnly) SliverToBoxAdapter(child: _tabs()),
                    if (visible.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text('No favorites yet. Tap a heart to save an artwork.')),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.crossAxisExtent;
                            final columns = width >= 1050 ? 3 : (width >= 680 ? 2 : 1);
                            return SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisExtent: width < 680 ? 410 : 430,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 6,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Post(
                                  item: visible[index],
                                  onFavoriteChanged: () => setState(() => visible[index].isFavorite = !visible[index].isFavorite),
                                  onFollowChanged: () => setState(() {
                                    final item = visible[index];
                                    item.isFollowing = !item.isFollowing;
                                    item.followers += item.isFollowing ? 1 : -1;
                                  }),
                                ),
                                childCount: visible.length,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
            _bottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(backgroundImage: AssetImage('images/p3.png')),
            const Text('NFT Market', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
            Row(children: [
              _roundAction(Icons.search, () => showSearch(context: context, delegate: _AuctionSearch(_items))),
              const SizedBox(width: 12),
              _roundAction(Icons.notifications_none, () {}),
            ]),
          ],
        ),
      );

  Widget _roundAction(IconData icon, VoidCallback onTap) => CircleAvatar(
        radius: 21,
        backgroundColor: Colors.grey.shade300,
        child: IconButton(onPressed: onTap, icon: Icon(icon, color: Colors.grey.shade700, size: 23)),
      );

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          TextButton(onPressed: () => setState(() => _navigationIndex = 1), child: const Text('Favorites')),
        ]),
      );

  Widget _tabs() => TabBar(
        controller: _controller,
        labelColor: Colors.grey.shade800,
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: const Color(0xffF35383),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [Tab(text: 'New'), Tab(text: 'Art'), Tab(text: 'Game'), Tab(text: 'Music')],
      );

  Widget _bottomNavigation() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [Colors.grey.withOpacity(.6), Colors.grey.withOpacity(.35)]),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _navIcon(Icons.home, 0),
                _navIcon(Icons.favorite, 1),
                _navIcon(Icons.search, 2),
                _navIcon(Icons.add_box_outlined, 3),
              ]),
            ),
          ),
        ),
      );

  Widget _navIcon(IconData icon, int index) => IconButton(
        onPressed: () {
          if (index == 2) {
            showSearch(context: context, delegate: _AuctionSearch(_items));
          } else {
            setState(() => _navigationIndex = index == 1 ? 1 : 0);
          }
        },
        icon: Icon(icon, size: 25, color: _navigationIndex == index ? const Color(0xffF35383) : Colors.white),
      );
}

class _AuctionSearch extends SearchDelegate<String> {
  _AuctionSearch(this.items);
  final List<AuctionItem> items;

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, ''), icon: const Icon(Icons.arrow_back));
  @override
  Widget buildResults(BuildContext context) => _results();
  @override
  Widget buildSuggestions(BuildContext context) => _results();

  Widget _results() {
    final matches = items.where((item) => item.name.toLowerCase().contains(query.toLowerCase()) || item.creator.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(children: matches.map((item) => ListTile(title: Text(item.name), subtitle: Text('by ${item.creator}'))).toList());
  }
}
