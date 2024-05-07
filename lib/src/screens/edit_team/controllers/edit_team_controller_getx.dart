import 'package:get/get.dart';

import '../../../models/country_list_model.dart';

class EditTeamController extends GetxController {
  RxList<Result> contryListResult = <Result>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = "".obs;
}
