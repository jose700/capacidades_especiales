import 'package:flutter/material.dart';

class FontSelectionScreen extends StatefulWidget {
  final List<String> fontOptions;
  final String selectedFont;
  final Function(String) onFontSelected;

  const FontSelectionScreen({
    Key? key,
    required this.fontOptions,
    required this.selectedFont,
    required this.onFontSelected,
  }) : super(key: key);

  @override
  _FontSelectionScreenState createState() => _FontSelectionScreenState();
}

class _FontSelectionScreenState extends State<FontSelectionScreen> {
  String filter = '';
  List<String> get filteredFonts {
    return widget.fontOptions
        .where((font) => font.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar Fuente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: filteredFonts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final font = filteredFonts[index];
                return ListTile(
                  title: Text(font),
                  leading: Radio<String>(
                    value: font,
                    groupValue: widget.selectedFont,
                    onChanged: (value) {
                      widget.onFontSelected(value!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
