class UsbPort {

  final String? description;
  final String? name;
  final String? transport;
  final String? busNumber;
  final String? deviceNumber;
  final String? vendorId;
  final String? productId;
  final String? manufacturer;
  final String? productName;
  final String? serialNumber;
  final String? macAddress;

  UsbPort({
    this.description,
    this.name,
    this.transport,
    this.busNumber,
    this.deviceNumber,
    this.vendorId,
    this.productId,
    this.manufacturer,
    this.productName,
    this.serialNumber,
    this.macAddress
  });

  factory UsbPort.fromJson(Map<String, dynamic> json) {
    return UsbPort(
      description: json['description'] as String?,
      name: json['name'] as String?,
      transport: json['transport'] as String,
      busNumber: json['busNumber'] as String?,
      deviceNumber: json['deviceNumber'] as String?,
      vendorId: json['vendorId'] as String?,
      productId: json['productId'] as String?,
      manufacturer: json['manufacturer'] as String?,
      productName: json['productName'] as String?,
      serialNumber: json['serialNumber'] as String?,
      macAddress: json['macAddress'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'transport': transport,
      'busNumber': busNumber,
      'deviceNumber': deviceNumber,
      'vendorId': vendorId,
      'productId': productId,
      'manufacturer': manufacturer,
      'productName': productName,
      'serialNumber': serialNumber,
      'macAddress': macAddress
    };
  }
}
