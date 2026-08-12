import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RecruiterOutreachApp());
}

class RecruiterOutreachApp extends StatelessWidget {
  const RecruiterOutreachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecruitGen - Outreach Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B5), // LinkedIn blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OutreachGeneratorScreen(),
      },
    );
  }
}

class OutreachGeneratorScreen extends StatefulWidget {
  const OutreachGeneratorScreen({super.key});

  @override
  State<OutreachGeneratorScreen> createState() =>
      _OutreachGeneratorScreenState();
}

class _OutreachGeneratorScreenState extends State<OutreachGeneratorScreen> {
  final TextEditingController _roleController = TextEditingController(
      text: 'Robert - Mechanical & Quality Engineering Roles');
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  String _generatedMessage = '';
  String _generatedPrompt = '';

  void _generateOutreach() {
    // In a real app, this would connect to an LLM (like OpenAI/Claude).
    // Here we generate the exact system prompt instructed by the user 
    // so they can copy it, or we could generate a simulated response.
    
    final role = _roleController.text.trim();
    final profile = _profileController.text.trim();
    
    if (role.isEmpty || profile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both the role and candidate profile.')),
      );
      return;
    }

    setState(() {
      _generatedPrompt = '''
You are an expert executive recruiter writing a personalized LinkedIn/ContactOut outreach message. Analyze the candidate profile below and create a highly tailored, professional, concise, and friendly recruitment message following these exact guidelines:

STRUCTURE (Keep under 120 words total):
Subject line format: Robert - $role (or Exciting Job Opportunity: [Specific role title] - [Location])

Message body:
Greeting: Hi [First Name],

Paragraph 1 (Opening): State the specific role you're recruiting for and ONE specific element from their profile that caught your attention (a project, achievement, skill, certification, or career move - NOT generic praise).

Paragraph 2 (The Role): Describe the opportunity in 3-4 flowing sentences (NO bullet points). Cover the industry, company stage, core responsibilities, and compensation structure. Highlight that the opportunity is with top companies within the industry. Make it feel realistic, professional, and appealing.

Paragraph 3 (The Connection): One sentence explaining why their specific background makes them a strong fit. Must reference experience from their profile.

Close / Hook: Add a subtle, effective hook. End by saying that if they're interested, they should let you know and the next step will be sending them the Job Description (JD) for review. Keep it brief, warm, and natural.

CANDIDATE PROFILE:
$profile
''';

      _generatedMessage = "System prompt generated successfully! Copy this and paste it into ChatGPT, Claude, or your LLM of choice to generate the perfect personalized message.";
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RecruitGen AI Outreach'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildInputSection()),
                    const SizedBox(width: 24),
                    Expanded(child: _buildOutputSection()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputSection(),
                    const SizedBox(height: 24),
                    _buildOutputSection(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Candidate & Role Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(
                labelText: 'Job Role / Title',
                border: OutlineInputBorder(),
                hintText: 'e.g., Mechanical & Quality Engineering Roles',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _profileController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Candidate LinkedIn Profile / Details',
                border: OutlineInputBorder(),
                hintText: 'Paste the candidate\'s profile or resume here...',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateOutreach,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Combined Prompt'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputSection() {
    if (_generatedPrompt.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'Enter details and generate to see your combined prompt here.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Compiled AI Prompt',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy Prompt',
                  onPressed: () => _copyToClipboard(_generatedPrompt),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _generatedMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SelectableText(
                _generatedPrompt,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
