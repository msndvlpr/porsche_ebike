
class BikeAssetData {
  final int resourceId;
  final String bikeDescription;
  final String bikeImageUrl;

  BikeAssetData({
    required this.resourceId,
    required this.bikeDescription,
    required this.bikeImageUrl
  });

  factory BikeAssetData.fromJson(Map<String, dynamic> json) => BikeAssetData(
    resourceId: json["resourceId"],
    bikeDescription: json["bikeDescription"],
    bikeImageUrl: json["bikeImageUrl"]
  );

  Map<String, dynamic> toJson() => {
    "resourceId": resourceId,
    "bikeDescription": bikeDescription,
    "bikeImageUrl": bikeImageUrl
  };


}