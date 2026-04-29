import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/compliment_provider.dart';
import '../../core/theme/theme_notifier.dart';

class ComplimentScreen extends StatefulWidget {
  @override
  State<ComplimentScreen> createState() => _ComplimentScreenState();
}

class _ComplimentScreenState extends State<ComplimentScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplimentProvider>().fetchCompliments();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<ComplimentProvider>().fetchCompliments();
      }
    });
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date).toLocal();
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (e) {
      return date;
    }
  }

  void showGenerateDialog() {
    final themeController = TextEditingController();
    final totalController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<ComplimentProvider>(
          builder: (context, provider, _) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("✨ Generate Pujian"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: themeController,
                    decoration: InputDecoration(
                      labelText: "Tema (Misal: semangat belajar)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: provider.isGenerating
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: provider.isGenerating
                      ? null
                      : () async {
                          await provider.generate(
                            themeController.text,
                            int.parse(totalController.text),
                          );
                          Navigator.pop(dialogContext);
                        },
                  child: provider.isGenerating
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white)),
                            SizedBox(width: 10),
                            Text("Generating..."),
                          ],
                        )
                      : Text("Generate"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Pilih warna gradient per kartu berdasarkan index
  List<Color> _cardGradient(int index) {
    final gradients = [
      [Color(0xFFEC4899), Color(0xFFBE185D)], // pink
      [Color(0xFF8B5CF6), Color(0xFF6D28D9)], // purple
      [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // blue
      [Color(0xFFF59E0B), Color(0xFFB45309)], // amber
      [Color(0xFF10B981), Color(0xFF047857)], // green
    ];
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplimentProvider>();
    final theme = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Pujian AI",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
              icon: Icon(Icons.dark_mode), onPressed: theme.toggleTheme),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showGenerateDialog,
        icon: Icon(Icons.auto_awesome),
        label: Text("Generate"),
        backgroundColor: Color(0xFFEC4899),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 120),
              itemCount: provider.compliments.length + 1,
              itemBuilder: (context, index) {
                if (index < provider.compliments.length) {
                  final item = provider.compliments[index];
                  final number = index + 1;
                  final colors = _cardGradient(index);

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: colors),
                      boxShadow: [
                        BoxShadow(
                            color: colors[0].withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: Offset(0, 6))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("#$number",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                formatDate(item.createdAt),
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 11),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          item.text,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tag,
                                  color: Colors.white70, size: 13),
                              SizedBox(width: 4),
                              Text(
                                item.theme,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return provider.isLoading
                      ? Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text("Loading...")
                            ],
                          ),
                        )
                      : SizedBox();
                }
              },
            ),
          ),
          if (provider.isGenerating)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
