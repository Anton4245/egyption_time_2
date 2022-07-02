import 'package:flutter/material.dart';

enum MenuProp { icon, text }

mainPopupMenu<E>(
    ThemeData theme,
    List<E>? menuList,
    Map<E, Map<MenuProp, dynamic>> menuProperties,
    void Function(E menuItem) callBack,
    [String size = 'big']) {
  menuList ??= menuProperties.entries.map((e) => e.key).toList();

  return SizedBox.fromSize(
    size: Size((size == 'big') ? 24 : 18, (size == 'big') ? 24 : 18),
    child: PopupMenuButton<E>(
      padding: const EdgeInsets.all(0),
      offset: Offset.zero,
      icon: SizedBox.fromSize(
        size: Size((size == 'big') ? 24 : 18, (size == 'big') ? 24 : 18),
        child: Icon(
          Icons.more_vert,
          color: theme.colorScheme.primary,
          size: (size == 'big') ? 24 : 18,
        ),
      ),
      itemBuilder: (context) => [
        ...menuList!.map((e) => PopupMenuItem(
              value: e,
              child: Row(
                children: [
                  Icon(
                    menuProperties[e]?[MenuProp.icon] ?? Icons.edit_note,
                    color: theme.colorScheme.primary,
                    size: (size == 'big') ? 20 : 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                        menuProperties[e]?[MenuProp.text] ?? 'New action',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.subtitle2?.copyWith(
                            fontSize: (size == 'big') ? 16 : 14,
                            color: theme.colorScheme.primary)),
                  ),
                ],
              ),
            ))
      ],
      onSelected: callBack,
    ),
  );
}
