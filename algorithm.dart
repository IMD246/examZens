import 'dart:math';

void main() {
  List<int> listNum = [
    1,
    3,
    5,
    7,
    9,
  ];

  miniMaxSum(arr: listNum);
}

void miniMaxSum({required List<int> arr}) {
  List<BigInt> listSum = [];
  int count = 0;
  while (listSum.length < arr.length) {
    int sum = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i != count) {
        sum = sum + arr[i];
      }
    }
    count++;
    listSum.add(BigInt.from(sum));
  }
  int maxValue = max(
    listSum[0].toInt(),
    listSum[listSum.length - 1].toInt(),
  );
  int minValue = min(
    listSum[0].toInt(),
    listSum[listSum.length - 1].toInt(),
  );

  print("${minValue} ${maxValue}");
}
