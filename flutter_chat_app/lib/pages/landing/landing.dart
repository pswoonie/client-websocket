import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/chat_room_list/chat_room_list.dart';
import 'package:flutter_chat_app/pages/friends/friends.dart';
import 'package:flutter_chat_app/pages/more/more.dart';
import 'package:flutter_chat_app/pages/shop/shop.dart';
import 'package:go_router/go_router.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _RoomListState();
}

class _RoomListState extends State<Landing> {
  final formKey = GlobalKey<FormState>();
  int currentPageIndex = 1;
  var rooms = <RoomObject>[];
  final String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random random = Random();

  @override
  void initState() {
    super.initState();
  }

  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

  Future<void> _showDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Room'),
          content: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Invite'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                context.pop();
                var room = RoomObject(
                  title: 'title',
                  id: _getRandomString(25),
                  members: [],
                );
                setState(() {
                  rooms.add(room);
                });
              },
            ),
          ],
        );
      },
    );
  }

  String _getAppBarTitle() {
    switch (currentPageIndex) {
      case 0:
        return 'Friends';
      case 1:
        return 'Chat';
      case 2:
        return 'Shop';
      case 3:
        return 'More';
      default:
        return '';
    }
  }

  Widget _getIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.group);
      case 1:
        return const Badge(
          label: Text('2'),
          child: Icon(Icons.chat),
        );
      case 2:
        return const Icon(Icons.shop);
      case 3:
        return const Icon(Icons.more_horiz);
      default:
        return const Icon(Icons.error);
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Friends';
      case 1:
        return 'Chat';
      case 2:
        return 'Shop';
      case 3:
        return 'More';
      default:
        return '';
    }
  }

  Widget _getNavigationDestinationIcon(int index) {
    return NavigationDestination(
      icon: _getIcon(index),
      label: _getLabel(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        titleSpacing: 16,
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        actions: (currentPageIndex == 0 || currentPageIndex == 1)
            ? [
                Visibility(
                  visible: currentPageIndex == 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
                Visibility(
                  visible: currentPageIndex == 1,
                  child: IconButton(
                    onPressed: () => _showDialog(context),
                    icon: const Icon(Icons.add),
                  ),
                ),
                Visibility(
                  visible: currentPageIndex == 1,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                ),
              ]
            : [],
      ),
      body: <Widget>[
        const Friends(),
        ChatRoomList(rooms: rooms),
        const Shop(),
        const More(),
      ][currentPageIndex],
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.deepPurple,
              blurRadius: 10,
              offset: Offset(0, 0.75),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: List.generate(
            4,
            (index) => _getNavigationDestinationIcon(index),
          ),
        ),
      ),
    );
  }
}
