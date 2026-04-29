import 'package:flutter/material.dart';
import '../data/models/compliment_model.dart';
import '../data/services/compliment_service.dart';

class ComplimentProvider extends ChangeNotifier {
  List<Compliment> compliments = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isGenerating = false;

  Future<void> fetchCompliments() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    final result = await ComplimentService.getCompliments(page);
    List data = result["data"];

    if (data.isEmpty) {
      hasMore = false;
    } else {
      compliments.addAll(
        data.map((e) => Compliment.fromJson(e)).toList(),
      );
      page++;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> generate(String theme, int total) async {
    isGenerating = true;
    notifyListeners();

    try {
      await ComplimentService.generateCompliments(theme, total);

      compliments.clear();
      page = 1;
      hasMore = true;

      await fetchCompliments();
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}
