// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/cupertino.dart';

// Future<bool> checkPermissions(BuildContext context) async {
//   final PermissionStatus permissionStatus = await _getPermission();
//   if (permissionStatus == PermissionStatus.granted) {
//     return true;
//   } else {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//               title: const Text('Permissions error'),
//               content: const Text('Please enable contacts access '
//                   'permission in system settings'),
//               actions: <Widget>[
//                 CupertinoDialogAction(
//                   child: const Text('OK'),
//                   onPressed: () {},
//                 )
//               ],
//             ));
//     return false;
//   }
// }

// //Check contacts permission
// Future<PermissionStatus> _getPermission() async {
//   final PermissionStatus permission = await Permission.contacts.status;
//   if (permission != PermissionStatus.granted &&
//       permission != PermissionStatus.denied) {
//     final Map<Permission, PermissionStatus> permissionStatus =
//         await [Permission.contacts].request();
//     return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
//   } else {
//     return permission;
//   }
// }
