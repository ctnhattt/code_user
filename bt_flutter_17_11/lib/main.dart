import 'package:flutter/material.dart';
import 'package:bt_flutter_17_11/dictionary.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      home: DictionaryScreen(),
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<DictionaryEntry> allEntries = [];
  List<DictionaryEntry> displayedEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDictionary();
  }

  Future<void> _loadDictionary() async {
    List<DictionaryEntry> entries = await DictionaryLoader().loadDictionary();
    setState(() {
      allEntries = entries;
      displayedEntries = entries.take(20).toList();
    });
  }

  void _search(String query) {
    List<DictionaryEntry> results = allEntries.where((entry) =>
      entry.term.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      displayedEntries = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Từ điển'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                
                context: context,
                delegate: _CustomSearchDelegate(allEntries, _search),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: displayedEntries.length,
        itemBuilder: (context, index) {
          DictionaryEntry entry = displayedEntries[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DefinitionScreen(entry: entry),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 111, 180, 237),
                border: Border.all(
                  color: Color.fromARGB(255, 165, 206, 240),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${entry.term}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DefinitionScreen extends StatelessWidget {
  final DictionaryEntry entry;

  DefinitionScreen({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Definition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.term}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '${entry.definition}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  final List<DictionaryEntry> entries;
  final Function(String) searchCallback;

  _CustomSearchDelegate(this.entries, this.searchCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchCallback(query);
    return Container(); // No results widget is needed since the results are displayed in the main screen.
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<DictionaryEntry> suggestions = entries
        .where((entry) => entry.term.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        DictionaryEntry entry = suggestions[index];
        return ListTile(
          title: Text(entry.term),
          onTap: () {
            query = entry.term;
            showResults(context);
          },
        );
      },
    );
  }
}