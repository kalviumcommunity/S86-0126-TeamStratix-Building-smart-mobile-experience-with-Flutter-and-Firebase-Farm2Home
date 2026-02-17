class AppConstants {
  static const String appName = 'Farm2Home';
  
  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleFarmer = 'farmer';
  
  // Order Status
  static const String statusReceived = 'Received';
  static const String statusHarvesting = 'Harvesting';
  static const String statusPacked = 'Packed';
  static const String statusOutForDelivery = 'Out for Delivery';
  static const String statusDelivered = 'Delivered';
  
  static const List<String> orderStatuses = [
    statusReceived,
    statusHarvesting,
    statusPacked,
    statusOutForDelivery,
    statusDelivered,
  ];
}
