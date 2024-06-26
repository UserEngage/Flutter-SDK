enum ProductEventType {
  addToCart,
  purchase,
  liking,
  addToObservation,
  order,
  reservation,
  returnItem,
  view,
  click,
  detail,
  add,
  remove,
  checkout,
  checkoutOption,
  refund,
  promoClick,
}

class ProductEvent {
  final String productId;

  final ProductEventType eventType;

  final Map<String, dynamic> parameters;

  final String eventName;

  final DateTime timestamp;

  ProductEvent({
    required this.productId,
    required this.eventType,
    required this.parameters,
  })  : timestamp = DateTime.now().toUtc(),
        eventName = 'product';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'event': eventName,
      'timestamp': timestamp.toIso8601String(),
      'event_type': _mapEventTypeToApiName(eventType),
      'data': <String, dynamic>{
        'custom_id': productId,
        ...parameters,
      },
    };
  }

  String _mapEventTypeToApiName(ProductEventType type) {
    return <ProductEventType, String>{
      ProductEventType.addToCart: 'add to cart',
      ProductEventType.purchase: 'purchase',
      ProductEventType.liking: 'liking',
      ProductEventType.addToObservation: 'add to observation',
      ProductEventType.order: 'order',
      ProductEventType.reservation: 'reservation',
      ProductEventType.returnItem: 'return',
      ProductEventType.view: 'view',
      ProductEventType.click: 'click',
      ProductEventType.detail: 'detail',
      ProductEventType.add: 'add',
      ProductEventType.remove: 'remove',
      ProductEventType.checkout: 'checkout',
      ProductEventType.checkoutOption: 'checkout option',
      ProductEventType.refund: 'refund',
      ProductEventType.promoClick: 'promo click',
    }[type]!;
  }
}
