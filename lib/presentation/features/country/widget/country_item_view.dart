import 'package:flutter/material.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';

import '../../../core/widgets/app_text.dart';
import '../../favourite/widget/favourite_toggle_button.dart';

class CountryItemView extends StatelessWidget {
  const CountryItemView({super.key, required this.data});

  final Country data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO:
        },
        child: Stack(
          children: [
            Column(
              spacing: 8.0,
              children: [
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Card(
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      // TODO: Build reusable image widget.
                      child: data.flags?.png != null
                          ? Image.network(
                              data.flags!.png!,
                              fit: BoxFit.fitHeight,
                              errorBuilder: (_, _, _) => const Center(
                                child: Icon(Icons.flag_outlined, size: 36),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.flag_outlined, size: 36),
                            ),
                    ),
                  ),
                ),
                AppText(
                  textAlign: TextAlign.center,
                  text: data.name?.common ?? '--',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: FavouriteToggleButton(country: data),
            ),
          ],
        ),
      ),
    );
  }
}
