String normalizeBarcode(String code) {
  return code.trim().replaceAll(RegExp(r'\s+'), '');
}
