import 'package:flutter/material.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString () {
    return '$_prefix $_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, 'Erreur de réseau : ');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Requette invalide : ');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, 'Requette non permise : ');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Valeurs de champs invalides : ');
}