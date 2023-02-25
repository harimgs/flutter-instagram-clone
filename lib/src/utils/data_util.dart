import 'package:uuid/uuid.dart';

class DataUtil {
  // 확장자 처리하기
  static String makeFilePath() {
    return '${const Uuid().v4()}.jpg';
  }
}
