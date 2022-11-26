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

/// cupertino style info dialog
static infoDialog(String msg) async {
  await showCupertinoDialog<String>(
      context: Get.context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(msg),
            actions: [
              CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
}

/// cupertino style custom dialog
static customDialog(String msg, List<Map<String, dynamic>> actions) async {
  await showCupertinoDialog<String>(
      context: Get.context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(msg),
        actions: actions.map((e) => CupertinoDialogAction(
              child: Text(e["title"]),
              onPressed: e["onPressed"])).toList()
      ));
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
## list extension
```dart
extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));

  Iterable<E> diff(Iterable<E> others, {bool Function(E, E)? comparator}) {
    return this.where((t) => !others.any(((o) => comparator != null ? comparator(o, t) : o == t)));
  }
}

extension MyCustomList<E> on List<E> {
  void upsert(E value, {bool Function(E item)? delegate}) {
    if (delegate == null) delegate = (item) => item == value;
    final ind = this.indexWhere((element) => delegate!(element));
    if (ind < 0)
      this.add(value);
    else
      this[ind] = value;
  }
}


```
{:file="list_extensions.dart"}
