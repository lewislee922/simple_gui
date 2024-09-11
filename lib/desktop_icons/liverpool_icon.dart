import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/window_elements/desktop_icon.dart';

class LiverpoolIcon extends ShortcutIcon {
  LiverpoolIcon(
      {super.key,
      VoidCallback? onTap,
      bool isSelected = false,
      VoidCallback? onDoubleTap})
      : super(
            name: "Liverpool HIV drug interactions",
            selected: isSelected,
            icon: Container(
              clipBehavior: Clip.hardEdge,
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: Image.asset(
                "assets/desktop/icons/liverpool.png",
                fit: BoxFit.contain,
              ),
            ),
            onTap: onTap,
            onDoubleTap: onDoubleTap ??
                () async {
                  if (await canLaunchUrlString(
                      "https://www.hiv-druginteractions.org/checker#")) {
                    launchUrlString(
                        "https://www.hiv-druginteractions.org/checker#");
                  }
                });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => onTap?.call(),
      child: GestureDetector(
        onDoubleTap: () => onDoubleTap?.call(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            SizedBox(
              width: 70,
              child: Text(name,
                  softWrap: true,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      backgroundColor: selected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent)),
            )
          ],
        ),
      ),
    );
  }
}
