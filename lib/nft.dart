
class NFT {
  final String id;
  final String name;
  final String creator;
  final String category;
  final double price;
  final String image;
  final String creatorImage;
  final DateTime auctionEndTime;

  NFT({
    required this.id,
    required this.name,
    required this.creator,
    required this.category,
    required this.price,
    required this.image,
    required this.creatorImage,
    required this.auctionEndTime,
  });
}
