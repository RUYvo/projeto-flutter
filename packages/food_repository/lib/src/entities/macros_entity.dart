class MacrosEntity {
  double delivery;
  double time;
  double rating;

  MacrosEntity({
    required this.delivery,
    required this.time,
    required this.rating
  });

    Map<String, Object?> toDocument(){
    return {
      'delivery': delivery,
      'time': time,
      'rating': rating,
    };
  }

  static MacrosEntity fromDocument(Map<String, dynamic> doc){
    return MacrosEntity(
      delivery: doc['delivery'],
      time: doc['time'],
      rating: doc['rating'],
    );
  }
}