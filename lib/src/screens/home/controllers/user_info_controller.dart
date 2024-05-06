import 'package:get/get.dart';

import '../../../models/success_login_responce.dart';

class UserInfoControllerGetx extends GetxController {
  Rx<User> userInfo =
      Rx(User(id: -1, fullName: "fullName", mobileNumber: "mobileNumber"));
}
