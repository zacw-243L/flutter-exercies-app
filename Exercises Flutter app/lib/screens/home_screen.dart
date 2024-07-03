import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_221252k/models/exercise.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String strBodyPart = 'back';
  String strLimit = '10';
  String stroffset = '0';

  //TODO Implement fetchExercises async function that makes an API request
  //TODO to fetch exercises (with limit of 10 exercises per query) by body part
  Future<List<Exercise>> fetchExercises(String bodyPart, int limit) async {
    String baseURL =
        'https://exercisedb.p.rapidapi.com/exercises/bodyPart/' + strBodyPart;

    //TODO Add request headers
    Map<String, String> requestHeaders = {
      'x-rapidapi-key': "",
      'x-rapidapi-host': "exercisedb.p.rapidapi.com"
    };

    //TODO Add query parameters
    Map<String, String> queryParams = {
      "bodyPart": strBodyPart,
      'limit': limit.toString(),
      'offset': '0'
    };

    //DO NOT EDIT
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await http.get(Uri.parse(baseURL + '?' + queryString),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      //TODO Processes response and returns List<Exercise>
      // Map<String, dynamic> jsonData = jsonDecode(response.body);
      // print(jsonDecode(response.body));
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      List<Exercise> exercise =
          jsonList.map((json) => Exercise.fromJson(json)).toList();
      return exercise;
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO Implement FloatingActionButton to navigate to SearchScreen
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final arguments =
              await Navigator.pushNamed(context, '/search') as List;
          String bodyPart = arguments[0];
          int numberOfExercises = int.parse(arguments[1]);
          setState(() {
            strBodyPart = bodyPart;
            strLimit = numberOfExercises.toString();
          });
        },
        child: const Icon(Icons.search, size: 30.0, color: Colors.black),
      ),
      //TODO Wait for returned argument and update strBodyPart
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              strBodyPart.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            // Add this
            child: SafeArea(
              child: FutureBuilder<List<Exercise>>(
                future: fetchExercises(strBodyPart, int.parse(strLimit)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Exercise exercise = snapshot.data![index];
                        return ListTile(
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: exercise.instructions.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      leading: Text('${index + 1}'),
                                      subtitle:
                                          Text(exercise.instructions[index]),
                                      leadingAndTrailingTextStyle: TextStyle(
                                        fontSize: 24,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              isScrollControlled: true,
                            );
                          },
                          leading: Image.network(exercise.gifUrl),
                          title: Text(
                              '${index + 1}. ${exercise.name.toUpperCase()}'),
                          subtitle: Text(
                            exercise.equipment,
                            textAlign:
                                TextAlign.justify, // Justify the subtitle
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
