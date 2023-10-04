import 'dart:convert';
import 'package:flutter/material.dart';
import 'product_class_provider.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<product> _items = [
    //   product(
    //       id: 'p1',
    //       title: "CAMP CLINT White Unisex Sneakers",
    //       description: "The new era of the bygone years is back on the streets, or it never left. Versatile, flexible and timeless, presenting CAMPUS OGs - Classic Shoes For The Classy You. These shoes has Dual-Capsule Tech which provides ultra-comfort and durability. The superior quality PU upper provides optimum fit while the rubber sole ensures a good grip and is resistant to abrasion.",
    //       imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/CAMPCLINT_WHTBEIGE_720x.jpg?v=1661941347",
    //       price: 2199),
    //
    //   product(
    //       id: "p2",
    //       title: "CAMP DENVER White Unisex Sneakers",
    //       description: "The new era of the bygone years is back on the streets, or it never left. Versatile, flexible and timeless, presenting CAMPUS OGs - Classic Shoes For The Classy You. These shoes has Dual-Capsule Tech which provides ultra-comfort and durability. The superior quality PU upper provides optimum fit while the rubber sole ensures a good grip and is resistant to abrasion.",
    //       imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/CAMPDENVER_WHTLSKY_720x.jpg?v=1661941530",
    //       price: 1999),
    //   product(
    //       id: "p3",
    //       title: "THEO Multi Men's Running Shoes",
    //       description: "Ensure complete foot protection while you run by wearing this pair from Campus. The use of updated technology and TPR sole makes the shoe crack resistant and provides the required support and stability to your feet with comfort and durability. The sturdy Mesh upper keeps your feet comfortable and ensures breathability and allows you to indulge in your running sessions for long periods.",
    //       imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/22G-144_THEO_CRM-TEN_1_720x.jpg?v=1653476500",
    //       price: 2019),
    //
    //   product(
    //       id: "p4",
    //       title: "SPACE-RIDER Men's Running Shoes",
    //       description:"Brace yourself for lift off, with the brand new Campus Space Rider. Take your sport style game to the next level with these sneakers straight from the future! Space Rider isn't just a mere sneaker, it's a Super Sneaker - suitable for all swag-filled lifestyles. The multi-layered componentry of the shoe is what lays the foundation for its trendy and cool design. Its design brings together influences from both the early 2000s as well as a new-age and futuristic aesthetic. Space Rider features a richly layered upper, and a sturdy EVA mid sole and is thus slip-resistant and comfortable, reminiscent of a spacecraft venturing in the realms of the universe. These futuristic kicks are sure to launch you to infinity and beyond! With a smart lace closure, this pair of super sneakers is surely a good addition to your footwear collection. Wear it with a polo t-shirt and a pair of jeans for an awesome look.",
    //       imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/9G-763-G-CREAM-GOLDEN-2_720x.jpg?v=1641384085",
    //       price: 1854),
    //
    //
    //
    //   product(
    // id: 'p5',
    // title: 'ROYCE-2 Grey Men\'s Running Shoes',
    // description: 'This pair of Campus running shoes which is ideal for all your running sessions. The exceptional quality mesh upper will keep your feet relaxed for long hours. The Phylon sole is slip-resistant and ensures a firm grip providing your foot solace from a tiring workout session. To enhance your comfort, this pair comes with an insole which keeps your foot relaxed and odor free. You can team it up with your regular sportswear and a T-Shirt for a sporty look.',
    // imageUrl: 'https://cdn.shopify.com/s/files/1/0607/6678/1671/products/ROYCE-2_CG-248_GRY-RST.jpg?v=1658742549',
    // price: 929),
    // product(
    // id: 'p6',
    // title: 'REE-FLECT (N) Black Men\'s Running Shoes REE-FLECT (N) Black Men\'s Running Shoes',
    // description: 'Step up your athletic shoe game with these trendy Campus sports shoes. These have a knit textile upper that hugs the foot for a sock-like fit. Pillow-like midsole cushioning provides long-lasting comfort. Durable phylon making it super light and inserts at the forefoot and heel provide added grip so you\'re ready for unexpected terrain. Match this pair with track pants and a sleeveless sports T-shirt when heading out for a casual day with friends.',
    // imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/5G-858-G-BLK-RED_2_38a40007-68d8-49ac-ba3c-3ae5934bf127_720x.jpg?v=1645379475",
    // price: 3079),
    // product(
    // id: "p7",
    // title: "IGNITE Black Men's Running Shoes",
    // description: "Go for jogs, hit the gym or even play your favorite sport wearing this pair of shoes from Campus. Crafted with care, it will ensure that your feet stay comfortable for long hours. It features a sturdy mesh upper which adds to the overall look and slip-resistant phylon which provides comfort and negates the chance of accidental falls. Wear it with a T-Shirt and shorts to look smart",
    // imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/IGNITEPRO_22G-287_BLK-GRN_2_720x.jpg?v=1653992621",
    // price: 783),
    // product(
    // id: "p8",
    // title: "FIRST Grey Men's Running Shoes",
    // description: "Go for jogs, hit the gym or even play your favorite sport wearing this pair of shoes from Campus. Crafted with care, it will ensure that your feet stay comfortable for long hours. It features a sturdy mesh upper which adds to the overall look and slip-resistant phylon sole crafted with thousands of tiny crazy balls, feels like a soft, bouncy bean bag which provides comfort and negates the chance of accidental falls. Wear it with a T-Shirt and shorts to look smart.",
    // imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/FIRST_11G-787_L.GRY-BLK_720x.jpg?v=1660050259",
    // price: 1529),
    // product(
    // id: 'p9',
    // title: "DREAMPLEX Men's Running Shoes",
    // description: "Perfectly designed for your energetic lifestyle, this pair of running shoes from Campus will ensure absolute comfort and robust performance. The high-quality durable mesh upper is easy to maintain and comfortable keeping your foot fresh throughout. The TPU sole provides resistance on most surfaces and offers the required support and stability to your feet with durability. You can wear it with a polyester T-Shirt and a pair of track pants.",
    // imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/DREAMPLEX_22G-206_BLU-RED_2_2c7a481c-6348-45b1-9cbd-152a258fec17_1076x.jpg?v=1645166622",
    // price: 2139),
    //
    //   product(
    //       id: "p10",
    //       title: "ROYCE-2 Blue Men's Running Shoes",
    //       description: "This pair of Campus running shoes which is ideal for all your running sessions. The exceptional quality mesh upper will keep your feet relaxed for long hours. The Phylon sole is slip-resistant and ensures a firm grip providing your foot solace from a tiring workout session. To enhance your comfort, this pair comes with an insole which keeps your foot relaxed and odor free. You can team it up with your regular sportswear and a T-Shirt for a sporty look.",
    //       imageUrl: "https://cdn.shopify.com/s/files/1/0607/6678/1671/products/ROYCE-2_CG-248_BLU-ORG_720x.jpg?v=1658482825",
    //       price: 929),
  ];

  List<product> get items {
    return [..._items];
  }

  String authToken;
  String userId;
  Products(this.authToken, this.userId, items);

  findById(String Id) {
    return _items.firstWhere((prod) => prod.id == Id);
  }

  void Togglefav(String id) {
    final pruduct = _items.firstWhere((prodId) => prodId == id);
    pruduct.isFavorite = !pruduct.isFavorite;
  }

  List<product> get findFavs {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Future<void> fetchDataAndPut([bool filterByUser = false]) async {
    final filterLink =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        'https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/product.json?auth=$authToken$filterLink';

    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      if (fetchedData == null) {
        return;
      }
      
      url =
          'https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/userFavorite/$userId/.json?auth=$authToken';
      final favresponse = await http.get(Uri.parse(url));
      final favdata = jsonDecode(favresponse.body);
      List<product> fetchedProducts = [];
      fetchedData.forEach((prodId, prodData) {
        fetchedProducts.insert(
            0,
            product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite: favdata == null ? false : favdata[prodId] ?? false,
            ));
        print(prodData['title']);
      });

      _items = fetchedProducts;
      // print("favdata = $favdata");
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addPoduct(product Productz) async {
    final url =
        'https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/product.json?auth=$authToken';
    try {
      final Response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'title': Productz.title,
            'description': Productz.description,
            'price': Productz.price,
            'imageUrl': Productz.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = product(
          id: jsonDecode(Response.body)['name'],
          title: Productz.title,
          description: Productz.description,
          imageUrl: Productz.imageUrl,
          price: Productz.price);
      _items.insert(0, newProduct);

      notifyListeners();
    } catch (error) {
      print(Error);
      throw Error;
    }
  }

  Future<void> updateProduct(String id, product updatedproduct) async {
    final ProductIndex = _items.indexWhere((prod) => prod.id == id);
    if (ProductIndex != null) {
      final url =
          'https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': updatedproduct.title,
            'description': updatedproduct.description,
            'price': updatedproduct.price,
            'imageUrl': updatedproduct.imageUrl
          }));

      _items[ProductIndex] = updatedproduct;
      ;
    } else {
      print(ProductIndex);
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    final url =
        "https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken";
    http.delete(Uri.parse(url));
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
