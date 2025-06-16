import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonPage extends ConsumerStatefulWidget {
  const PersonPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonPageState();
}

class _PersonPageState extends ConsumerState<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Person Page')),
      body: Center(
        child: Text(
          'Welcome to the Person Page!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
