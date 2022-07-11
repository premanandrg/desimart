double starValue = 0;

Map orderStatusStrings = {
  'NEW': 'Order Placed',
  'READY TO SHIP': 'Order Packed',
  'CANCELED': 'Order Cancelled',
  'INVOICED': 'Preparing to Ship',
  'PICKUP SCHRDULED': 'Pickup Scheduled',
  'OUT FOR PICKUP': 'Out for Pickup',
  'SHIPPED': 'Shipped',
  'IN TRANSIT-EN-ROUTE': 'On the way',
  'IN TRANSIT': 'On the way',
  'REACHED AT DESTINATION HUB': 'Reached at your nearest Hub',
  'OUT FOR DELIVERY': 'Out for delivery',
  'DELIVERED': 'Delivered',
};

//Color Codes
List red = [
  'CANCELED',
  'CANCELLATION REQUESTED',
  'DAMAGED',
  'PICKUP EXCEPTION',
  'RTO DELIVERED',
];

List green = [
  7,
];

List yellow = [
  'NEW',
  'READY TO SHIP',
  'INVOICED',
  'PICKUP SCHEDULED',
  'OUT FOR PICKUP',
  'PICKED UP',
  'SHIPPED',
  'OUT FOR DELIVERY',
  'IN TRANSIT',
  'IN TRANSIT-EN-ROUTE',
];
