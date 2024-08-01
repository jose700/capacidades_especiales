import 'dart:ui' as ui show Image;
import 'dart:ui';

class ImageNode {
  int? curIndex;
  int? index;
  Path? path;
  Rect? rect;
  ui.Image? image;

  int getXIndex(int level) {
    return (index ?? 0) % level;
  }

  int getYIndex(int level) {
    return ((index ?? 0) / level).floor();
  }
}
