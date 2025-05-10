
class BikeAssetData {

  final int resourceId;
  final String bikeDescription;
  final String bikeImageUrl;
  final String bikeModel;

  BikeAssetData({
    required this.resourceId,
    required this.bikeDescription,
    required this.bikeImageUrl,
    required this.bikeModel
  });

  factory BikeAssetData.fromJson(Map<String, dynamic> json) => BikeAssetData(
    resourceId: json["resourceId"],
    bikeDescription: json["bikeDescription"],
    bikeImageUrl: json["bikeImageUrl"],
    bikeModel: json["bikeModel"]
  );

  Map<String, dynamic> toJson() => {
    "resourceId": resourceId,
    "bikeDescription": bikeDescription,
    "bikeImageUrl": bikeImageUrl,
    "bikeModel": bikeModel
  };


}