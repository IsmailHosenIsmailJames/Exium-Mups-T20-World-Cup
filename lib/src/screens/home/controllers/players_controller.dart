import 'package:get/get.dart';

import '../../../models/players_info_model.dart';

class PlayersController extends GetxController {
  RxList<PlayerInfoModel> players = <PlayerInfoModel>[].obs;
  RxInt countUpdate = 0.obs;
}
