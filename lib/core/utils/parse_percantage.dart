double parsePercentage(String percentageString) {
  // Buang spasi dan persen
  String cleaned = percentageString.replaceAll('%', '').trim();
  // Ganti koma jadi titik
  cleaned = cleaned.replaceAll(',', '.');
  // Parse ke double
  double value = double.tryParse(cleaned) ?? 0.0;
  return value / 100;
}
