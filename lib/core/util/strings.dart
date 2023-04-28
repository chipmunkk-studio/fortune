extension Prettify on String {
  String shortenForPrint([int n = 5]) {
    if (length <= 2 * n) {
      return this;
    } else {
      return '${substring(0, n)}...${substring(length - n)}';
    }
  }
}
