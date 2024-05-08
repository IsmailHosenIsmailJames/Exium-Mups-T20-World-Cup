import 'package:get/get.dart';

import '../../../models/players_info_model.dart';

class PlayerListOfACountryController extends GetxController {
  RxList<PlayerInfoModel> listOfPlayers = <PlayerInfoModel>[].obs;
  RxList<PlayerInfoModel> selectedPlayer = <PlayerInfoModel>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = "".obs;
}
