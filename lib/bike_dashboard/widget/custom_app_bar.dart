import 'package:flutter/material.dart';
import 'package:porsche_ebike_code_challenge/user_login/view/login_screen.dart';

import 'custom_switch.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final bool showOptionMenu;
  const CustomAppBar({super.key, required this.title, this.showOptionMenu = false});

  @override
  Widget build(BuildContext context) {

    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: showOptionMenu ? PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz_rounded, size: 32),
            onSelected: (value){
              if(value == "logout"){
                _confirmLogout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Logout'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('About'),
                  ],
                ),
              ),
            ],
          ) : null,
          elevation: 12,
          title: Text(title),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CustomSwitch(
                value: false,//context.watch<ThemeCubit>().state.isDark,
                onChanged: (value){
                  //context.read<ThemeCubit>().setTheme(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);

  void _confirmLogout(BuildContext con) {
    showDialog(
      context: con,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Logout'),
            onPressed: () async{
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );

            },
          ),
        ],
      ),
    );
  }
}