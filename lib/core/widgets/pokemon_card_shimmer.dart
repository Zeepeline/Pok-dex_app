import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PokemonCardShimmer extends StatelessWidget {
  const PokemonCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cardHeight = 130.0;
    final cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Left section (Text and Chips)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 32, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 20,
                      width: 120,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: List.generate(2, (index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 24,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),

          // Right section (Image container)
          Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[200]!,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Icon(Icons.favorite_border, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
