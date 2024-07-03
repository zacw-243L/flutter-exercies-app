import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController bodyController = TextEditingController();

  final List<String> _bodyParts = [
    "back",
    "cardio",
    "chest",
    "lower arms",
    "lower legs",
    "neck",
    "shoulders",
    "upper arms",
    "upper legs",
    "waist"
  ];
  String _selectedBodyPart = '';
  int _selectedNumberOfExercises = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Parameters'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Target:'),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _bodyParts.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                setState(() {
                  _selectedBodyPart = selection;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    title: Text('10'),
                    value: 10,
                    groupValue: _selectedNumberOfExercises,
                    onChanged: (value) {
                      setState(() {
                        _selectedNumberOfExercises = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: Text('25'),
                    value: 25,
                    groupValue: _selectedNumberOfExercises,
                    onChanged: (value) {
                      setState(() {
                        _selectedNumberOfExercises = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: Text('50'),
                    value: 50,
                    groupValue: _selectedNumberOfExercises,
                    onChanged: (value) {
                      setState(() {
                        _selectedNumberOfExercises = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedBodyPart.isNotEmpty) {
                    Navigator.pop(context, [
                      _selectedBodyPart,
                      _selectedNumberOfExercises.toString()
                    ]);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a body part'),
                      ),
                    );
                  }
                },
                child: Text('Search'.toUpperCase()),
              ),
            ),
          ],
        ));
  }
}
