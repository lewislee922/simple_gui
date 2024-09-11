import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/window_elements/desktop_icon.dart';

class DrugsIcon extends ShortcutIcon {
  DrugsIcon(
      {super.key,
      VoidCallback? onTap,
      bool isSelected = false,
      VoidCallback? onDoubleTap})
      : super(
            name: "Drugs.com",
            selected: isSelected,
            icon: Container(
              clipBehavior: Clip.hardEdge,
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: Image.asset(
                "assets/desktop/icons/drugs.png",
                fit: BoxFit.contain,
              ),
            ),
            onTap: onTap,
            onDoubleTap: onDoubleTap ??
                () async {
                  if (await canLaunchUrlString("https://www.drugs.com")) {
                    launchUrlString("https://www.drugs.com");
                  }
                });

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
