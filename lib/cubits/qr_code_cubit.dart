import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/models/qr_code_model.dart';
import 'package:qr_code_scanner/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class QrCodeState {}

class QrCodeStateInitial extends QrCodeState {}

class QrCodeStateLoading extends QrCodeState {}

class QrCodeStateLoaded extends QrCodeState {
  List<QrCodeModel> qrCodes;

  QrCodeStateLoaded(this.qrCodes);
}

class QrCodeStateError extends QrCodeState {
  String error;

  QrCodeStateError(this.error);
}

class QrCodeCubit extends Cubit<QrCodeState> {
  final database = QrCodeDatabase();

  QrCodeCubit() : super(QrCodeStateInitial());

  Future<void> getQrCodes() async {
    try {
      final data = await database.getQrCodes();
      emit(QrCodeStateLoaded(data));
    } catch (error) {
      emit(QrCodeStateError(error.toString()));
    }
  }

  Future<void> searchQrCodes(String name) async {
    try {
      final data = await database.searchQrCode(name);
      emit(QrCodeStateLoaded(data));
    } catch (error) {
      emit(QrCodeStateError(error.toString()));
    }
  }

  Future<void> deleteQrCodes(int id) async {
    try {
      await database.deleteQrCode(id);
    } catch (error) {
      emit(QrCodeStateError(error.toString()));
    }
  }

  Future<void> renameQrCode(int id, String newName) async {
    try {
      await database.updateQrCodeName(id, newName);
    } catch (error) {
      emit(QrCodeStateError(error.toString()));
    }
  }

  Future<void> saveQrCode(String name, String link) async {
    try {
      final qrCode = QrCodeModel(name: name, link: link);
      await database.insertQrCodes(qrCode);
    } catch (error) {
      emit(QrCodeStateError(error.toString()));
    }
  }

  Future<void> openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
