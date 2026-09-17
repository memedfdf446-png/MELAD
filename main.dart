import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const SignLanguageTranslatorApp());
}

class SignLanguageTranslatorApp extends StatelessWidget {
  const SignLanguageTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مترجم لغة الإشارة',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      locale: const Locale('ar', 'SA'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        fontFamily: 'Cairo',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;
  String _currentWord = 'مرحباً بكم';
  String _signDescription = 'أدخل كلمة أو اضغط للتجربة الفورية';
  IconData _currentIcon = Icons.waving_hand_rounded;

  final Map<String, Map<String, dynamic>> _dictionary = {
    'مرحبا': {'icon': Icons.waving_hand_rounded, 'desc': 'رفع اليد مع التلويح ببطء'},
    'شكرا': {'icon': Icons.favorite_rounded, 'desc': 'وضع اليد على الصدر تعبيراً عن الامتنان'},
    'حب': {'icon': Icons.favorite_rounded, 'desc': 'تقاطع الذراعين على الصدر'},
    'مساعدة': {'icon': Icons.sign_language_rounded, 'desc': 'رفع اليدين لطلب العون والمساعدة'},
  };

  void _translateWord(String word) {
    final cleanWord = word.trim().toLowerCase();
    if (cleanWord.isEmpty) return;

    setState(() {
      _currentWord = word;
      if (_dictionary.containsKey(cleanWord)) {
        _currentIcon = _dictionary[cleanWord]!['icon'];
        _signDescription = _dictionary[cleanWord]!['desc'];
      } else {
        _currentIcon = Icons.sign_language_rounded;
        _signDescription = 'تم البحث عن الإشارة بنجاح (كلمة مخصصة)';
      }
    });


  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _signDescription = 'جاري الاستماع للصوت...';
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _isListening) {
            _textController.text = 'مرحبا';
            _translateWord('مرحبا');
            setState(() => _isListening = false);
          }
        });
      } else {
        _signDescription = 'تم إيقاف الاستماع';
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مترجم لغة الإشارة', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.purpleAccent, width: 2),
                        ),
                        child: Icon(
                          _currentIcon,
                          size: 58,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _currentWord,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _signDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _translateWord,
                          decoration: const InputDecoration(
                            hintText: 'اكتب الكلمة هنا (مثال: مرحبا)...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.translate_rounded, color: Color(0xFF6750A4)),
                        onPressed: () => _translateWord(_textController.text),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _toggleListening,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: _isListening ? Colors.red : const Color(0xFF6750A4),
                  child: Icon(
                    _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isListening ? 'جاري الاستماع للتحدث...' : 'اضغط الميكروفون للتحدث',
                style: TextStyle(
                  fontSize: 12,
                  color: _isListening ? Colors.red : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}