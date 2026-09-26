class Issue {
  final String id;
  final String title;
  final String category;
  final String severity;
  final String file;
  final int line;
  final String description;
  final String impact;
  final String recommendation;

  Issue({
    required this.id,
    required this.title,
    required this.category,
    required this.severity,
    required this.file,
    required this.line,
    required this.description,
    required this.impact,
    required this.recommendation,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Security',
      severity: json['severity'] ?? 'MEDIUM',
      file: json['file'] ?? '',
      line: json['line'] is int ? json['line'] : int.tryParse(json['line'].toString()) ?? 0,
      description: json['description'] ?? '',
      impact: json['impact'] ?? '',
      recommendation: json['recommendation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'severity': severity,
      'file': file,
      'line': line,
      'description': description,
      'impact': impact,
      'recommendation': recommendation,
    };
  }
}

class ProjectAnalysis {
  final String summary;
  final int healthScore;
  final List<Issue> issues;
  final List<String> testGaps;
  final List<String> strengths;

  ProjectAnalysis({
    required this.summary,
    required this.healthScore,
    required this.issues,
    required this.testGaps,
    required this.strengths,
  });

  factory ProjectAnalysis.fromJson(Map<String, dynamic> json) {
    var rawIssues = json['issues'] as List? ?? [];
    List<Issue> issueList = rawIssues.map((i) => Issue.fromJson(i as Map<String, dynamic>)).toList();

    return ProjectAnalysis(
      summary: json['summary'] ?? '',
      healthScore: json['health_score'] ?? 70,
      issues: issueList,
      testGaps: (json['test_gaps'] as List? ?? []).map((e) => e.toString()).toList(),
      strengths: (json['strengths'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
