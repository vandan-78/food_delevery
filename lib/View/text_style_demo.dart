import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/text_styles.dart';

class TextStylesDemoScreen extends StatelessWidget {
  const TextStylesDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_TextExample> examples = [
      _TextExample("Display Large", TextStyles.displayLarge),
      _TextExample("Display Medium", TextStyles.displayMedium),
      _TextExample("Display Small", TextStyles.displaySmall),

      _TextExample("Headline Large", TextStyles.headlineLarge),
      _TextExample("Headline Medium", TextStyles.headlineMedium),
      _TextExample("Headline Small", TextStyles.headlineSmall),

      _TextExample("Title Large", TextStyles.titleLarge),
      _TextExample("Title Medium", TextStyles.titleMedium),
      _TextExample("Title Small", TextStyles.titleSmall),

      _TextExample("Body Large", TextStyles.bodyLarge),
      _TextExample("Body Medium", TextStyles.bodyMedium),
      _TextExample("Body Small", TextStyles.bodySmall),

      _TextExample("Label Large", TextStyles.labelLarge),
      _TextExample("Label Medium", TextStyles.labelMedium),
      _TextExample("Label Small", TextStyles.labelSmall),

      _TextExample("Button Large", TextStyles.buttonLarge),
      _TextExample("Button Medium", TextStyles.buttonMedium),
      _TextExample("Button Small", TextStyles.buttonSmall),

      _TextExample("Splash Title", TextStyles.splashTitle),
      _TextExample("Splash Subtitle", TextStyles.splashSubtitle),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text("Text Styles Demo",style: TextStyles.titleLarge.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: examples.length,
        separatorBuilder: (_, __) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final item = examples[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: TextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text("The quick brown fox jumps over the lazy dog", style: item.style),
            ],
          );
        },
      ),
    );
  }
}

class _TextExample {
  final String name;
  final TextStyle style;

  _TextExample(this.name, this.style);
}
