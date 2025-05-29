import 'package:flutter/material.dart';

void main() {
  runApp(MoodMateApp());
}

class MoodMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodMate',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212),
        primaryColor: Colors.tealAccent[400],
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.tealAccent[400],
          elevation: 2,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              color: Colors.tealAccent[400], fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white54),
        ),
        cardColor: Color(0xFF242424), checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Colors.tealAccent[400]; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Colors.tealAccent[400]; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Colors.tealAccent[400]; }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Colors.tealAccent[400]; }
 return null;
 }),
 ),
      ),
      home: AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Simple in-memory user manager
class AuthManager {
  static final Map<String, String> users = {};
  static String? currentUser;
}

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  void handleAuth() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        error = 'Please enter username and password.';
      });
      return;
    }

    if (isLogin) {
      if (AuthManager.users[username] == password) {
        AuthManager.currentUser = username;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MoodPage()));
      } else {
        setState(() {
          error = 'Invalid username or password.';
        });
      }
    } else {
      if (AuthManager.users.containsKey(username)) {
        setState(() {
          error = 'User already exists.';
        });
      } else {
        AuthManager.users[username] = password;
        setState(() {
          isLogin = true;
          error = '';
          usernameController.clear();
          passwordController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(isLogin ? 'Login to MoodMate' : 'Register for MoodMate')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: theme.primaryColor),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor!)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: theme.primaryColor),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor!)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            if (error.isNotEmpty)
              Text(
                error,
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: handleAuth,
              child: Text(isLogin ? 'Login' : 'Register', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() {
                isLogin = !isLogin;
                error = '';
              }),
              child: Text(
                isLogin
                    ? 'Don\'t have an account? Register'
                    : 'Have an account? Login',
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodSuggestion {
  final String quote;
  final String activity;
  final IconData icon;
  final Color color;

  MoodSuggestion({
    required this.quote,
    required this.activity,
    required this.icon,
    required this.color,
  });
}

enum ViewType { grid, list }

class MoodPage extends StatefulWidget {
  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final Map<String, MoodSuggestion> moods = {
    'Happy': MoodSuggestion(
      quote: "Happiness is a journey, not a destination.",
      activity: "Listen to your favorite upbeat song!",
      icon: Icons.sentiment_satisfied_alt,
      color: Colors.yellowAccent.shade400,
    ),
    'Sad': MoodSuggestion(
      quote: "Tough times don't last, but tough people do.",
      activity: "Try journaling your thoughts for 10 minutes.",
      icon: Icons.sentiment_dissatisfied,
      color: Colors.blueAccent.shade400,
    ),
    'Angry': MoodSuggestion(
      quote: "For every minute you remain angry, you lose sixty seconds of peace.",
      activity: "Take 5 deep breaths and stretch your body.",
      icon: Icons.sentiment_very_dissatisfied,
      color: Colors.redAccent.shade400,
    ),
    'Tired': MoodSuggestion(
      quote: "Sometimes the most productive thing you can do is rest.",
      activity: "Try a quick power nap or meditate for 5 minutes.",
      icon: Icons.bedtime,
      color: Colors.deepPurpleAccent.shade400,
    ),
    'Excited': MoodSuggestion(
      quote: "Enthusiasm moves the world.",
      activity: "Plan something fun for the weekend!",
      icon: Icons.emoji_events,
      color: Colors.orangeAccent.shade400,
    ),
  };

  String dropdownValue = 'Happy';
  ViewType viewType = ViewType.grid;

  @override
  Widget build(BuildContext context) {
    final MoodSuggestion suggestion = moods[dropdownValue]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('MoodMate - Welcome, ${AuthManager.currentUser}!'),
        backgroundColor: suggestion.color.withOpacity(0.9),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthManager.currentUser = null;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => AuthPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: suggestion.color.withOpacity(0.1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: DropdownButton<String>(
              dropdownColor: Color(0xFF222222),
              value: dropdownValue,
              iconEnabledColor: suggestion.color,
              style: TextStyle(color: Colors.white, fontSize: 18),
              items: moods.keys
                  .map((mood) => DropdownMenuItem(
                        value: mood,
                        child: Text(mood,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() => dropdownValue = val!);
              },
              underline: Container(height: 2, color: suggestion.color),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                Icon(suggestion.icon, color: suggestion.color, size: 120),
                SizedBox(height: 16),
                Text(
                  '"${suggestion.quote}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: suggestion.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Suggestion: ${suggestion.activity}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          ToggleButtons(
            isSelected: [viewType == ViewType.grid, viewType == ViewType.list],
            onPressed: (index) {
              setState(() => viewType = ViewType.values[index]);
            },
            color: suggestion.color.withOpacity(0.7),
            selectedColor: Colors.white,
            fillColor: suggestion.color,
            borderRadius: BorderRadius.circular(8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.grid_view),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.list),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: viewType == ViewType.grid
                ? GridView.count(
                    padding: EdgeInsets.all(12),
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    children: moods.entries.map((entry) {
                      final mood = entry.key;
                      final data = entry.value;
                      return Card(
                        color: data.color.withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(data.icon, color: data.color, size: 50),
                            SizedBox(height: 8),
                            Text(mood,
                                style: TextStyle(
                                    color: data.color,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : ListView(
                    padding: EdgeInsets.all(12),
                    children: moods.entries.map((entry) {
                      final mood = entry.key;
                      final data = entry.value;
                      return Card(
                        color: data.color.withOpacity(0.25),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(data.icon, color: data.color, size: 40),
                          title: Text(mood,
                              style: TextStyle(
                                  color: data.color,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(data.quote, style: TextStyle(color: Colors.white70)),
                        ),
                      );
                    }).toList(),
                  ),
          )
        ],
     ),
);
}
}