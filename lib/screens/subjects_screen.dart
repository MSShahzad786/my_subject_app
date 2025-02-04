import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final List<Subject> _allSubjects = [];
  List<Subject> _filteredSubjects = [];
  List<Subject> _pinnedSubjects = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    _loadPinnedSubjects();
  }

  void _loadSubjects() {
    // Replace with your actual data source
    _allSubjects.addAll([
      Subject(id: '1', name: 'Mathematics'),
      Subject(id: '2', name: 'Physics'),
      Subject(id: '3', name: 'Chemistry'),
      Subject(id: '4', name: 'Biology'),
      Subject(id: '5', name: 'History'),
    ]);
    _filteredSubjects = _allSubjects;
  }

  Future<void> _loadPinnedSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final pinnedIds = prefs.getStringList('pinnedSubjects') ?? [];

    setState(() {
      for (var subject in _allSubjects) {
        subject.isPinned = pinnedIds.contains(subject.id);
      }
      _pinnedSubjects = _allSubjects.where((s) => s.isPinned).toList();
    });
  }

  Future<void> _togglePin(Subject subject) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> pinnedIds = prefs.getStringList('pinnedSubjects') ?? [];

    setState(() {
      subject.isPinned = !subject.isPinned;
      if (subject.isPinned) {
        pinnedIds.add(subject.id);
      } else {
        pinnedIds.remove(subject.id);
      }
      _pinnedSubjects = _allSubjects.where((s) => s.isPinned).toList();
    });

    await prefs.setStringList('pinnedSubjects', pinnedIds);
  }

  void _searchSubjects(String query) {
    setState(() {
      _filteredSubjects = _allSubjects.where((subject) {
        return subject.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search subjects...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchSubjects,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSubjects.length,
              itemBuilder: (context, index) {
                final subject = _filteredSubjects[index];
                return ListTile(
                  title: Text(subject.name),
                  trailing: IconButton(
                    icon: Icon(
                      subject.isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      color: subject.isPinned ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _togglePin(subject),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
