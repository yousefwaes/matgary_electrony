class ProductModel {
  dynamic id, price, image, name, description, category, rating, reviews,oldPrice;
   bool isFavorite;
   int quantity;


  ProductModel(
      {required this.id,
      required this.price,
      required this.name,
      required this.reviews,
      required this.description,
      required this.category,
      required this.rating,
        required this. oldPrice,
      this.isFavorite=false,
        this.quantity=0,
      required this.image});

  factory ProductModel.fromJson(Map<String, dynamic> product) {
    return ProductModel(
      id: product['id'],
      image: product['image'],
      reviews: product['reviews'],
      price: product['price'],
      name: product['name'],
      description: product['description'],
      category: product['category'],
      rating: product['rating'],
        oldPrice:product['oldPrice'],
       //isFavorite: product['isFavorite']
    );
  }

  ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel.fromJson(json);
  }

  factory ProductModel.init() {
    return ProductModel(
        id: '',
        price: '',
        name: '',
        category: '',
        reviews: '',
        description: '',
        rating: '',
        oldPrice:0,
        isFavorite: false,
        quantity: 0,
        image: '');
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ProductModel> data = [];
    for (var post in jsonList) {
      data.add(ProductModel.fromJson(post));
    }
    return data;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'name': name,
          'reviews': reviews,
        'category': category,
        'description': description,
        'image': image,

      };
}
