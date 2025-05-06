import 'package:usb_con_api/usb_con_api_service.dart';

class HwConnectivityRepository{


  final UsbConApi _api;

  HwConnectivityRepository(this._api);

  Stream<List<UsbPort>> watchUsbDevices() {
    return _api.watchUsbDevices();
  }

  Future<List<UsbPort>> getUsbDevicesList() async{
    return _api.getUsbDevicesList();
  }

  /// Implement the business logic for BLE/USB connection to hardware components

}