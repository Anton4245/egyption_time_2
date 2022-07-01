import 'package:flutter/material.dart';

enum MenuProp { icon, text }

mainPopupMenu<E>(
    ThemeData theme,
    List<E>? menuList,
    Map<E, Map<MenuProp, dynamic>> menuProperties,
    void Function(E menuItem) callBack) {
  menuList ??= menuProperties.entries.map((e) => e.key).toList();

  return PopupMenuButton<E>(
    icon: Icon(
      Icons.more_vert,
      color: theme.colorScheme.primary,
    ),
    itemBuilder: (context) => [
      ...menuList!.map((e) => PopupMenuItem(
            value: e,
            child: Row(
              children: [
                Icon(
                  menuProperties[e]?[MenuProp.icon] ?? Icons.edit_note,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(menuProperties[e]?[MenuProp.text] ?? 'New action',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.subtitle2
                          ?.copyWith(color: theme.colorScheme.primary)),
                ),
              ],
            ),
          ))
    ],
    onSelected: callBack,
  );
}
