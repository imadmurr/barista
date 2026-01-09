import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"),
            ),

            const SizedBox(height: 20),

            Text("John Doe", style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 6),
            const Text("johndoe@example.com"),

            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () => context.pushNamed("favorites"),
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => context.pushNamed("profile"),
            ),
          ],
        ),
      ),
    );
  }
}
