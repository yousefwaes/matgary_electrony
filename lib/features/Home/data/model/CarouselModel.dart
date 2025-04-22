class CarouselModel {
  dynamic id,  image;

  CarouselModel({
    required this.id,
    required this.image,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> product) {
    return CarouselModel(
      id: product['id'],
      image: product['image'],
    );
  }

  CarouselModel fromJson(Map<String, dynamic> json) {
    return CarouselModel.fromJson(json);
  }

  factory CarouselModel.init() {
    return CarouselModel(
      id: '',
      image: '',
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<CarouselModel> data = [];
    for (var post in jsonList) {
      data.add(CarouselModel.fromJson(post));
    }
    return data;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
      };
}
