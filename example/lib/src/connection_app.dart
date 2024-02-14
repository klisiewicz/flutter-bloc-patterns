import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:example/src/list_details_app.dart';
import 'package:example/src/post/model/post_details.dart';
import 'package:example/src/tools/connection/connectivity_plus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/connection.dart';

void main() => runApp(ConnectionApp());

class ConnectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connection App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BlocProvider(
        create: (_) => ConnectionBloc(
          ConnectivityPlusRepository(
            Connectivity(),
          ),
        ),
        child: const ConnectionPage(),
      ),
    );
  }
}

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: ConnectionListener(
        onOnline: _showOnlineSnackbar,
        onOffline: _showOfflineSnackbar,
        child: ConnectionBuilder(
          online: (context) => PostDetailsView(
            PostDetails(
              id: 1,
              title: 'Lorem Ipsum',
              body:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            ),
          ),
          offline: (context) => const _OfflineView(),
        ),
      ),
    );
  }

  void _showOnlineSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You are back online.'),
        backgroundColor: Colors.green[300],
      ),
    );
  }

  void _showOfflineSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You are offline.'),
        backgroundColor: Colors.red[300],
      ),
    );
  }
}

class _OfflineView extends StatelessWidget {
  const _OfflineView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.signal_wifi_0_bar_rounded, size: 64),
          const SizedBox(height: 16),
          Text(
            'You are offline. Check your Internet connection.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
