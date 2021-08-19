import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ValueNotifier<Color> accentColor;

bool _isDarkTheme = true;
bool _isUsingHive = true;

class ThemePage extends StatefulWidget {
  final String title;

  const ThemePage({Key key, this.title}) : super(key: key);

  @override
  _ThemePageState createState() => _ThemePageState();
}

class AppColors {

  static const Color PRIMARY_COLOR = Color(0xFFEEEEEE);
  static const Color SECONDARY_COLOR = Color(0xFF1C4670);
  static const Color ACCENT_COLOR = Color(0xFFF1E9E5);
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: accentColor,
      builder: (_, color, __) => MaterialApp(
        title: 'App Settings Demo',
        theme: _isDarkTheme
            ? ThemeData.dark().copyWith(accentColor: color)
            : ThemeData.light().copyWith(accentColor: color),
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                _buildThemeSwitch(context),
                _buildPreferenceSwitch(context),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Shared Pref'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: _isUsingHive,
            onChanged: (newVal) {
              if (kIsWeb) {
                return;
              }
              _isUsingHive = newVal;
              setState(() {
              });
            }),
        Text('Hive Storage'),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Light Theme'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: _isDarkTheme,
            onChanged: (newVal) {
              _isDarkTheme = newVal;
              setState(() {});
            }),
        Text('Dark Theme'),
      ],
    );
  }
}