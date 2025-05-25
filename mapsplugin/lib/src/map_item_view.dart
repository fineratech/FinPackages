import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'models/map_item.dart';

class MapItemView extends StatelessWidget {
  const MapItemView({
    super.key,
    this.onTap,
    this.margin = const EdgeInsetsDirectional.only(end: 10),
    required this.item,
    this.backgroundColor,
  });

  final MapItem item;

  final Function()? onTap;

  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        margin: margin,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 50.0, // Adjust the width as needed
                  height: 50.0, // Adjust the height as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(item.logo),

                      // Replace with your image path
                      fit: BoxFit.contain,
                      // Ensure no cropping and maintain aspect ratio
                      alignment: AlignmentDirectional
                          .topStart, // Align the image to the left
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item.name,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // const Text(
                //   "4.6",
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const Icon(
                //   Icons.star,
                //   color: Colors.yellow,
                // ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              item.description ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.locationAddress.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.locationAddress,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
            // SizedBox(
            //   height: 11.h,
            // ),
          ],
        ),
      ),
    );
  }
}
