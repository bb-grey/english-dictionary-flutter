import '../components/word_type_button.dart';
import '../components/heading_text.dart';
import '../models/word.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class WordDetailScreen extends StatefulWidget {
  static const String routeName = '/word_detail';
  final String word;

  WordDetailScreen(this.word);

  @override
  _WordDetailScreenState createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  Word _wordDetails;
  String _word;
  int _activeMeaning = 0;
  @override
  void initState() {
    super.initState();
    _word = widget.word;
  }

  @override
  Widget build(BuildContext context) {
    _getWordDetails();
    //print(_word);
    return Scaffold(
      body: SafeArea(
        child: _wordDetails == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBackButton(),
                      SizedBox(height: 60.0),
                      _buildSearchedWord(),
                      _buildPronunciation(),
                      SizedBox(height: 30.0),
                      _buildWordTypeButtons(),
                      SizedBox(height: 30.0),
                      HeadingText('DEFINITIONS'),
                      SizedBox(height: 5.0),
                      _buildDefinitions(),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSynonyms(),
                          // _buildAntonyms(),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      HeadingText('Example'),
                      SizedBox(height: 5.0),
                      _buildExample(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _getWordDetails() async {
    final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$_word';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      dynamic wordDecoded = json.decode(response.body);
      Map<String, dynamic> wordDecodedMap = wordDecoded[0];
      // print(wordDecodedList);
      final String word = wordDecodedMap['word'];
      final String pro = wordDecodedMap['phonetics'][0]['text'];
      final String audio = wordDecodedMap['phonetics'][0]['audio'];
      final List<dynamic> meanings =
          wordDecodedMap['meanings'].take(3).toList();
      if (mounted) {
        setState(() {
          _wordDetails = Word(
              word: word, pronunciation: pro, audio: audio, meanings: meanings);
        });
      }
    }
  }

  Widget _buildSynonyms() {
    List<dynamic> synonyms = _wordDetails.meanings[_activeMeaning]
                ['definitions'][0]['synonyms']
            ?.take(5)
            ?.toList() ??
        [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingText('SYNONYMS'),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            synonyms.length,
            (index) => Text(synonyms[index]),
          ),
        ),
      ],
    );
  }

  // Widget _buildAntonyms() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       HeadingText('ANTONYMS', color: Colors.grey[800]),
  //       Text('Hello'),
  //       Text('Hello'),
  //       Text('Hello'),
  //       Text('Hello'),
  //     ],
  //   );
  // }

  Widget _buildWordTypeButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _wordDetails.meanings.length,
          (index) {
            if (index == 0) {
              return WordTypeButton(
                wordType: _wordDetails.meanings[index]['partOfSpeech'],
                isActive: _activeMeaning == index,
                topLeftBorderRadius: 5,
                bottomLeftBorderRadius: 5,
                onTap: () => _changeWordType(index),
              );
            } else if (index == _wordDetails.meanings.length - 1) {
              return WordTypeButton(
                wordType: _wordDetails.meanings[index]['partOfSpeech'],
                isActive: _activeMeaning == index,
                topRightBorderRadius: 5,
                bottomRightBorderRadius: 5,
                onTap: () => _changeWordType(index),
              );
            } else {
              return WordTypeButton(
                wordType: _wordDetails.meanings[index]['partOfSpeech'],
                isActive: _activeMeaning == index,
                onTap: () => _changeWordType(index),
              );
            }
          },
        ),
      ),
    );
  }

  void _changeWordType(int index) {
    if (mounted) {
      setState(() => _activeMeaning = index);
    }
  }

  Future<void> _playSound() async {
    AudioPlayer().play(_wordDetails.audio);
  }

  Widget _buildPronunciation() {
    return Row(
      children: [
        Text(
          '${_wordDetails.pronunciation}',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
          ),
        ),
        SizedBox(width: 10.0),
        GestureDetector(
          child: Icon(
            Icons.volume_up,
            color: Colors.blue,
          ),
          onTap: _playSound,
        ),
      ],
    );
  }

  Widget _buildSearchedWord() {
    return Text(
      '${_wordDetails.word}',
      style: Theme.of(context).textTheme.headline4.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.navigate_before,
            color: Colors.blue,
            size: 42.0,
          ),
          Text(
            'Search',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitions() {
    return Text(
      '${_wordDetails.meanings[_activeMeaning]['definitions'][0]['definition']}',
      style: TextStyle(fontFamily: 'Roboto '),
    );
  }

  Widget _buildExample() {
    return Text(
      '${_wordDetails.meanings[_activeMeaning]['definitions'][0]['example'] ?? ''}',
      style: TextStyle(fontFamily: 'Roboto '),
    );
  }
}

// [
// WordTypeButton(
//   wordType: 'Adjective',
//   isActive: true,
//   topLeftBorderRadius: 5,
//   bottomLeftBorderRadius: 5,
// ),
// WordTypeButton(wordType: 'Verb'),
// WordTypeButton(
//   wordType: 'Object',
//   topRightBorderRadius: 5,
//   bottomRightBorderRadius: 5,
// ),
//         ],
