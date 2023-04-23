import 'package:flutter/material.dart';
import 'package:pcp_frontend/components.dart';
import 'package:pcp_frontend/sizes.dart';

class ChallengeCreatePage extends StatefulWidget {
  const ChallengeCreatePage({super.key});

  @override
  State<ChallengeCreatePage> createState() => _ChallengeCreatePageState();
}

class _ChallengeCreatePageState extends State<ChallengeCreatePage> {
  final _name = TextEditingController();
  final _tier = TextEditingController();
  final _description = TextEditingController();
  final _initialCode = TextEditingController();
  final _testCase = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _tier.dispose();
    _description.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Create Challenge',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: PadSize.md),
            TextField(
              controller: _tier,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Tier',
              ),
            ),
            const SizedBox(height: PadSize.md),
            TextField(
              controller: _description,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: PadSize.md),
            TextField(
              controller: _initialCode,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Initial Code',
              ),
            ),
            const SizedBox(height: PadSize.md),
            TextField(
              controller: _testCase,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Test Case',
              ),
            ),
            const SizedBox(height: PadSize.md),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
