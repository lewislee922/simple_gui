import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/window_elements/desktop_icon.dart';

class UptodateShortcutIcon extends ShortcutIcon {
  UptodateShortcutIcon(
      {super.key,
      VoidCallback? onTap,
      bool isSelected = false,
      VoidCallback? onDoubleTap})
      : super(
          name: "UpToDate",
          selected: isSelected,
          icon: Container(
            clipBehavior: Clip.hardEdge,
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            child: Image.asset(
              "assets/desktop/icons/uptodate.png",
              fit: BoxFit.contain,
            ),
          ),
          onTap: onTap,
          onDoubleTap: onDoubleTap ??
              () async {
                if (await canLaunchUrlString(
                    "https://www.uptodate.com/contents/search")) {
                  launchUrlString("https://www.uptodate.com/contents/search");
                }
              },
        );

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => onTap?.call(),
      child: GestureDetector(
        onDoubleTap: () => onDoubleTap?.call(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: selected ? Colors.grey : Colors.transparent,
                    width: 1.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: icon,
            ),
            const SizedBox(height: 4.0),
            Text(name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    backgroundColor: selected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent))
          ],
        ),
      ),
    );
  }
}
