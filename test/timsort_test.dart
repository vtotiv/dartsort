import "dart:math";

import "package:test/test.dart";
import "package:dartsort/sorting.dart";

void main() {
  group("Timsort basic sorting", () {
    test("Sorts integers", () {
      List<int> numbers = [5, 3, 1, 8, 7, 2, 4, 6];
      numbers.timsort((a, b) => a.compareTo(b));
      expect(numbers, [1, 2, 3, 4, 5, 6, 7, 8]);
    });

    test("Sorts strings", () {
      List<String> strings = ["banana", "apple", "mango", "cherry"];
      strings.timsort((a, b) => a.compareTo(b));
      expect(strings, ["apple", "banana", "cherry", "mango"]);
    });

    test("Sorts random integers", () {
      Random random = Random();
      for (int i = 0; i < 100; i++) {
        List<int> list =
            List.generate(random.nextInt(100), (index) => random.nextInt(1000));
        List<int> sortedList = List.from(list)..sort((a, b) => a.compareTo(b));
        list.timsort((a, b) => a.compareTo(b));
        expect(list, sortedList);
      }
    });

    test("Timsort should be stable", () {
      List<Pair> pairs = [
        Pair(5, 1),
        Pair(2, 2),
        Pair(5, 2),
        Pair(3, 3),
        Pair(2, 1),
        Pair(3, 1),
        Pair(3, 2),
        Pair(5, 3),
        Pair(2, 3),
        Pair(4, 1),
        Pair(4, 2),
        Pair(4, 3),
      ];

      // expected order of second values for each group of first values after sorting
      var expectedOrder = [2, 1, 3, 3, 1, 2, 1, 2, 3, 1, 2, 3];

      pairs.timsort((a, b) => a.first.compareTo(b.first));

      for (int i = 0, j = 0; i < pairs.length; i = j) {
        int currentFirst = pairs[i].first;
        // find the next group of first values
        while (j < pairs.length && pairs[j].first == currentFirst) {
          j++;
        }
        // check that the second values are in the expected order
        for (int k = i; k < j; k++) {
          expect(pairs[k].second, expectedOrder[k]);
        }
      }
    });
  });

  group("Timsort edge cases", () {
    test("Sorting an empty list", () {
      List<int> emptyList = [];
      emptyList.timsort((a, b) => a.compareTo(b));
      expect(emptyList, isEmpty);
    });

    test("Sorting one element", () {
      List<String> oneElem = ["first"];
      oneElem.timsort((a, b) => a.compareTo(b));
      expect(oneElem, equals(["first"]));
    });

    test("Sorting a list with all elements equal", () {
      List<int> equalElementsList = List.filled(100, 5);
      equalElementsList.timsort((a, b) => a.compareTo(b));
      expect(equalElementsList, everyElement(equals(5)));
    });
  });
}

class Pair {
  final int first;
  final int second;

  Pair(this.first, this.second);

  @override
  String toString() => "($first, $second)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;
}
