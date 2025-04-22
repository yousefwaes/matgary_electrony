class SendOrderModel {
  dynamic id, price, image, name, description, category, rating, reviews,oldPrice;
   


  SendOrderModel(
      {required this.id,
      required this.price,
      required this.name,
      required this.reviews,
      required this.description,
      required this.category,
      required this.rating,
        required this. oldPrice,
    
      required this.image});

  factory SendOrderModel.fromJson(Map<String, dynamic> product) {
    return SendOrderModel(
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

  SendOrderModel fromJson(Map<String, dynamic> json) {
    return SendOrderModel.fromJson(json);
  }

  factory SendOrderModel.init() {
    return SendOrderModel(
        id: '',
        price: '',
        name: '',
        category: '',
        reviews: '',
        description: '',
        rating: '',
        image: '', oldPrice: '');
  }

  fromJsonList(List<dynamic> jsonList) {
    List<SendOrderModel> data = [];
    for (var post in jsonList) {
      data.add(SendOrderModel.fromJson(post));
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
