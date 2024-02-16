import "dart:math";

extension TimSort<T> on List<T> {
  void timsort(int Function(T a, T b) compare) {
    if (this.length <= 1) return;

    const int RUN = 32;
    int n = this.length;

    for (int i = 0; i < n; i += RUN) {
      _insertionSort(i, min(i + RUN - 1, n - 1), compare);
    }

    for (int size = RUN; size < n; size *= 2) {
      for (int left = 0; left < n; left += 2 * size) {
        int mid = left + size - 1;
        int right = min((left + 2 * size - 1), (n - 1));

        if (mid < right) {
          _merge(left, mid, right, compare);
        }
      }
    }
  }

  void _insertionSort(int left, int right, int Function(T a, T b) compare) {
    for (int i = left + 1; i <= right; i++) {
      T temp = this[i];
      int j = i - 1;
      while (j >= left && compare(this[j], temp) > 0) {
        this[j + 1] = this[j];
        j--;
      }
      this[j + 1] = temp;
    }
  }

  void _merge(int left, int mid, int right, int Function(T a, T b) compare) {
    int len1 = mid - left + 1;
    int len2 = right - mid;
    List<T> leftList = List<T>.from(this.getRange(left, mid + 1));
    List<T> rightList = List<T>.from(this.getRange(mid + 1, right + 1));

    int i = 0, j = 0;
    int k = left;
    while (i < len1 && j < len2) {
      if (compare(leftList[i], rightList[j]) <= 0) {
        this[k] = leftList[i];
        i++;
      } else {
        this[k] = rightList[j];
        j++;
      }
      k++;
    }

    while (i < len1) {
      this[k] = leftList[i];
      i++;
      k++;
    }

    while (j < len2) {
      this[k] = rightList[j];
      j++;
      k++;
    }
  }
}
