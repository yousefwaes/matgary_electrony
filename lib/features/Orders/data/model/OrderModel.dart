class OrderModel {
  final int id;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String status;
  final double total;
  final String createdAt;
  final String updatedAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderItemModel> orderItems = [];
    if (json['items'] != null) {
      orderItems = (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList();
    }

    return OrderModel(
      id: json['id'],
      customerName: json['customerName'],
      customerAddress: json['customerAddress'],
      customerPhone: json['customerPhone'],
      status: json['status'],
      total: json['total'].toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      items: orderItems,
    );
  }

  factory OrderModel.init() {
    return OrderModel(
      id: 0,
      customerName: '',
      customerAddress: '',
      customerPhone: '',
      status: '',
      total: 0.0,
      createdAt: '',
      updatedAt: '',
      items: [],
    );
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
        'items': items.map((item) => item.toJson()).toList(),
      };

  static List<OrderModel> fromJsonList(List<dynamic> jsonList) {
    List<OrderModel> data = [];
    for (var order in jsonList) {
      data.add(OrderModel.fromJson(order));
    }
    return data;
  }
}

class OrderItemModel {
  final int id;
  final int quantity;
  final double price;
  final int orderId;
  final int productId;
  final ProductItemModel product;

  OrderItemModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.orderId,
    required this.productId,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      orderId: json['orderId'],
      productId: json['productId'],
      product: ProductItemModel.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'price': price,
        'orderId': orderId,
        'productId': productId,
        'product': product.toJson(),
      };
}

class ProductItemModel {
  final int id;
  final String name;
  final double price;
  final double oldPrice;
  final String image;
  final String status;
  final dynamic rating;
  final int categoryId;
  final String createdAt;
  final String updatedAt;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.status,
    required this.rating,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      oldPrice: json['oldPrice'].toDouble(),
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