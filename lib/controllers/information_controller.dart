import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:teste_api/api/api.dart';
import 'package:teste_api/types/information.dart';

class Informationcontroller extends ChangeNotifier {
  List<String> _categories = [];
  final Map<String, List<Information>> _info = {};
  bool _isLoading = false;
  String _messageError = '';

  List<String> get categories => _categories;
  Map<String, List<Information>> get info => _info;
  bool get isLoading => _isLoading;
  String get messageError => _messageError;

  String _errorFormater(Response response) {
    String msg, stak = '', url = '', excptUri = '';
    try {
      var jsonBody = jsonDecode(response.body);
      if (jsonBody is Map && jsonBody.containsKey('error')) {
        msg = jsonBody['error'];
        if (jsonBody.containsKey('stackTrace')) {
          // ignore: prefer_interpolation_to_compose_strings
          stak = '\nStackTrace: ' + jsonBody['stackTrace'];
        }
        if (jsonBody.containsKey('url')) {
          // ignore: prefer_interpolation_to_compose_strings
          url = '\nURL passada: ' + jsonBody['url'];
        }
        if (jsonBody.containsKey('excptUri')) {
          // ignore: prefer_interpolation_to_compose_strings
          excptUri = '\nexcptUri passada: ' + jsonBody['excptUri'];
        }
      } else {
        msg = jsonBody.toString();
      }
    } catch (e) {
      msg = e.toString();
    }
    return 'Erro: ${response.statusCode}-$msg \nURL: ${response.request?.url} $url $stak $excptUri';
  }

  Future<void> list() async {
    _isLoading = true;
    notifyListeners();
    var response = await Api().unAuth().get('/informations/categories');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _categories =
          result['searched'].map<String>((s) => s.toString()).toList();
      for (var e in _categories) {
        var resp = await Api().unAuth().get('/informations/category/$e');
        if (resp.statusCode == 200) {
          var result = jsonDecode(resp.body);
          final entrie = <String, List<Information>>{
            e: Information.fromList(result['searched'])
          };
          _info.addAll(entrie);
        } else {
          _messageError = _errorFormater(response);
        }
      }
    } else {
      _messageError = _errorFormater(response);
    }
    _isLoading = false;
    notifyListeners();
  }
}
