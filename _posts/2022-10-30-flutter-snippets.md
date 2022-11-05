---
layout: post
title: flutter snippets
date: 2022-10-30 00:01 +0330
---
# pacakge snippets

## mixed
```dart
CachedNetworkImage(
  fit: BoxFit.cover,
  height: 125,
  width: 125,
  imageUrl: imageUrl
),
```


## dialogs
### confirmation dialog
```dart
Future<bool> dialogConfirmation(String msg, {bool isDestructiveAction = true}) {
  return showCupertinoModalPopup<bool>(
    context: Get.context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
            child: Text(msg),
            onPressed: () async {
              Get.back(result: true);
            },
            isDestructiveAction: isDestructiveAction),
      ],
      cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true),
    ),
  );
}
```

### multi choice
```dart
/// shows deialog with [msgs] as choices, returns [selected choice, selected index]
Future<Tuple2<String, int>> dialogMultiChoice(List<String> msgs) {
  return showCupertinoModalPopup<Tuple2<String, int>>(
    context: Get.context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        for (int i = 0; i < msgs.length; i++)
          CupertinoActionSheetAction(
            child: Text(msgs[i]),
            onPressed: () async {
              Get.back(result: Tuple2(msgs[i], i));
            },
            isDestructiveAction: true,
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true),
    ),
  );
}
```