import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const DevFlowApp());
}

class DevFlowApp extends StatelessWidget {
  const DevFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ==========================================
// 1. DASHBOARD SCREEN
// ==========================================
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevFlow', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading demo-project.zip...')),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalysisScreen(projectName: 'demo-project/')),
              );
            }
          });
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Analyze Project'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Recent Analyses', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          _buildProjectCard('Todo API', '12 issues', '8 resolved', 85, context),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String issues, String resolved, int score, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: score / 100, backgroundColor: Colors.grey[800], color: Colors.green),
            Text(score.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$issues • $resolved'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// ==========================================
// 2. PROJECT ANALYSIS SCREEN
// ==========================================
class AnalysisScreen extends StatefulWidget {
  final String projectName;
  const AnalysisScreen({super.key, required this.projectName});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  Map<String, dynamic>? analysisData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnalysis();
  }

  Future<void> _fetchAnalysis() async {
    try {
      // Calls your FastAPI Backend!
      final response = await http.post(Uri.parse('https://devflow-frontend-pizn.onrender.com/api/analyze'));
      if (response.statusCode == 200) {
        setState(() {
          analysisData = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.projectName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final score = analysisData!['health_score'];
    final issues = analysisData!['issues'] as List;

    return Scaffold(
      appBar: AppBar(title: Text(widget.projectName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(color: Colors.redAccent, value: (100 - score).toDouble(), title: '', radius: 10),
                          PieChartSectionData(color: Colors.greenAccent, value: score.toDouble(), title: '', radius: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PROJECT HEALTH', style: TextStyle(color: Colors.grey, letterSpacing: 1.2)),
                      Text('$score / 100', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Identified Issues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...issues.map((issue) => Card(
                  child: ListTile(
                    leading: Icon(
                      issue['type'] == 'security' ? Icons.security : Icons.bug_report,
                      color: issue['type'] == 'security' ? Colors.redAccent : Colors.orange,
                    ),
                    title: Text(issue['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${issue['file']} • Line ${issue['line']}\n${issue['description']}'),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => IssueDetailScreen(issueId: issue['id'], issueTitle: issue['title']),
                          ),
                        );
                      },
                      child: const Text('Fix', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class IssueDetailScreen extends StatefulWidget {
  final String issueId;
  final String issueTitle;

  const IssueDetailScreen({super.key, required this.issueId, required this.issueTitle});

  @override
  State<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends State<IssueDetailScreen> {
  bool _isFixing = false;
  Map<String, dynamic>? _fixResult;
  String? _errorMessage;

  void _generateFix() async {
    setState(() {
      _isFixing = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://devflow-frontend-pizn.onrender.com/api/fix'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"issue_id": widget.issueId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _fixResult = data;
            _isFixing = false;
          });
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Fix generation failed';
            _isFixing = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error (${response.statusCode})';
          _isFixing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error: $e';
        _isFixing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.issueTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
              ),
            if (_fixResult == null && !_isFixing)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Generate AI Fix Plan'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                  onPressed: _generateFix,
                ),
              ),
            if (_isFixing)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("DevFlow & IBM Bob Agents working..."),
                  ],
                ),
              ),
            if (_fixResult != null) ...[
              const Text('AI FIX PLAN EXECUTED ✅', style: TextStyle(fontSize: 20, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Fixed Code:', style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  _fixResult?['fixed_code'] ?? '// No code returned',
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBeforeAfterCard(
                      'BEFORE',
                      '${_fixResult?['before_tests']?['total'] ?? 0}',
                      '${_fixResult?['before_tests']?['passed'] ?? 0}',
                      '${_fixResult?['before_tests']?['failed'] ?? 0}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBeforeAfterCard(
                      'AFTER',
                      '${_fixResult?['after_tests']?['total'] ?? 0}',
                      '${_fixResult?['after_tests']?['passed'] ?? 0}',
                      '${_fixResult?['after_tests']?['failed'] ?? 0}',
                      isAfter: true,
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBeforeAfterCard(String title, String total, String passed, String failed, {bool isAfter = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAfter ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isAfter ? Colors.green : Colors.redAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Tests: $total'),
          Text('Passed: $passed', style: TextStyle(color: isAfter ? Colors.greenAccent : Colors.white)),
          Text('Failed: $failed', style: TextStyle(color: isAfter ? Colors.white : Colors.redAccent)),
        ],
      ),
    );
  }
}

// ==========================================
// 4. PROFILE SCREEN (Unchanged)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Developer Profile')));
  }
}