/// 相关算法
///
///
///
///



abs(value) => value > 0 ? value : -value;


///二分查找
/// array有序的前提下。
int binarySearch(List<int> array, int start, int end, int key) {

  if (array == null || start > end) return -1;

  //int mid = (end - start) >> 1 + start;
  int mid = (start + end) >> 1;
  if (array[mid] == key) {
    return mid;
  } else if (array[mid] > key) {
    return binarySearch(array, start, mid -1, key);
  } else {
    return binarySearch(array, mid + 1, end, key);
  }
}


List<String> main() {
  List<int> list = [1, 2, 3, 4, 5, 6, 7, 8];
  print(binarySearch(list, 0, list.length - 1, 1));//测试通过
}
