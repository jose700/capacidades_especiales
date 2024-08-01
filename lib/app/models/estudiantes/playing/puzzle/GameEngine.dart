import 'package:capacidades_especiales/app/models/estudiantes/playing/puzzle/ImageNode.dart';

class GameEngine {
  static void makeRandom(List<ImageNode> list) {
    List<int> arr = [];
    do {
      arr.clear();
      list.shuffle();
      for (int i = 0; i < list.length; i++) {
        list[i].curIndex = i;
        arr.add(list[i].index!);
      }
    } while (InversePairs(arr) % 2 != 0);
  }

  static int InversePairs(List<int> array) {
    if (array.length == 0) {
      return 0;
    }
    return InversePairs2(array, 0, array.length - 1);
  }

  static int InversePairs2(List<int> array, int start, int end) {
    int result = 0;
    if (start < end) {
      int mid = ((start + end) / 2).floor();
      result += InversePairs2(array, start, mid);
      result += InversePairs2(array, mid + 1, end);
      result += merge(array, start, mid, end);
    }
    return result;
  }

  static int merge(List<int> array, int start, int mid, int end) {
    int i = start;
    int j = mid + 1;
    int k = 0;
    List<int> temp = List<int>.filled(end - start + 1, 0);
    int result = 0;
    while (i <= mid && j <= end) {
      if (array[i] > array[j]) {
        result += (mid - i + 1);
        temp[k++] = array[j++];
      } else {
        temp[k++] = array[i++];
      }
    }
    while (i <= mid) {
      temp[k++] = array[i++];
    }
    while (j <= end) {
      temp[k++] = array[j++];
    }
    for (int m = start; m <= end; m++) {
      array[m] = temp[m - start];
    }
    return result;
  }
}
