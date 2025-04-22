class SendOrderModel {
  dynamic id;
  dynamic customerName;
  dynamic customerAddress;
  dynamic customerPhone;
  dynamic status;
  dynamic total;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic items;

  SendOrderModel({
    this.id,
    this.customerName,
    this.customerAddress,
    this.customerPhone,
    this.status,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory SendOrderModel.fromJson(Map<String, dynamic> json) {
    return SendOrderModel(
      id: json['id'],
      customerName: json['customerName'],
      customerAddress: json['customerAddress'],
      customerPhone: json['customerPhone'],
      status: json['status'],
      total: json['total'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      items: json['items'],
    );
  }

  SendOrderModel fromJson(Map<String, dynamic> json) {
    return SendOrderModel.fromJson(json);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'customerAddress': customerAddress,
        'customerPhone': customerPhone,
        'status': status,
        'total': total,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'items': items,
      };

  factory SendOrderModel.init() {
    return SendOrderModel(
      id: '',
      customerName: '',
      customerAddress: '',
      customerPhone: '',
      status: '',
      total: '',
      createdAt: '',
      updatedAt: '',
      items: '',
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<SendOrderModel> data = [];
    for (var item in jsonList) {
      data.add(SendOrderModel.fromJson(item));
    }
    return data;
  }
}

class OrderItem {
  dynamic id;
  dynamic quantity;
  dynamic price;
  dynamic orderId;
  dynamic productId;
  dynamic product;

  OrderItem({
    this.id,
    this.quantity,
    this.price,
    this.orderId,
    this.productId,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'],
      orderId: json['orderId'],
      productId: json['productId'],
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'price': price,
        'orderId': orderId,
        'productId': productId,
        'product': product?.toJson(),
      };
}

class Product {
  dynamic id;
  dynamic name;
  dynamic price;
  dynamic oldPrice;
  dynamic image;
  dynamic status;
  dynamic rating;
  dynamic categoryId;
  dynamic createdAt;
  dynamic updatedAt;

  Product({
    this.id,
    this.name,
    this.price,
    this.oldPrice,
    this.image,
    this.status,
    this.rating,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      oldPrice: json['oldPrice'],
      image: json['image'],
      status: json['status'],
      rating: json['rating'],
      categoryId: json['categoryId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'oldPrice': oldPrice,
        'image': image,
        'status': status,
        'rating': rating,
        'categoryId': categoryId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
