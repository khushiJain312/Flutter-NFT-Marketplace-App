class AuctionItem {
  AuctionItem({
    required this.creator,
    required this.name,
    required this.price,
    required this.image,
    required this.creatorImage,
    required this.category,
    required this.endsAt,
    this.followers = 1000,
    this.isFavorite = false,
    this.isFollowing = false,
  });

  final String creator;
  final String name;
  final String price;
  final String image;
  final String creatorImage;
  final String category;
  final DateTime endsAt;
  int followers;
  bool isFavorite;
  bool isFollowing;
}
