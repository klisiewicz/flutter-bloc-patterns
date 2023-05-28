import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:example/src/list_app.dart';
import 'package:example/src/post/model/post.dart';
import 'package:example/src/post/model/post_repository.dart';
import 'package:example/src/tools/connection/connectivity_plus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/base_list.dart';
import 'package:flutter_bloc_patterns/connection.dart';

void main() => runApp(ConnectionApp());

typedef PostsBloc = ListBloc<Post>;

class ConnectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connection App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ListBloc<Post>(PostListRepository()),
          ),
          BlocProvider(
            create: (_) => ConnectionBloc(
              ConnectivityPlusRepository(Connectivity()),
            ),
          ),
        ],
        child: const ConnectionPage(),
      ),
    );
  }
}

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ConnectionListener(
        onOnline: _showOnlineSnackbar,
        onOffline: _showOfflineSnackbar,
        child: ConnectionBuilder(
          onOnline: (context) => const PostsViewStateBuilder(),
          onOffline: (context) => const OfflineView(),
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

class OfflineView extends StatelessWidget {
  const OfflineView({super.key});

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
          )
        ],
      ),
    );
  }
}
