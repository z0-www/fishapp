import 'dart:developer' as developer;

void bootStage(String name, [String detail = '']) {
  developer.log(
    detail.isEmpty ? name : '$name $detail',
    name: 'fish-boot',
  );
}
