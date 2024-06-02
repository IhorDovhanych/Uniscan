import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/domain/repository/qr_code_repository.dart';
import 'package:uniscan/application/domain/usecase/get_qr_codes_stream_use_case.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/nearest_qr_code_dialog.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

part 'home_state.dart';

class HomeCubit extends CubitBase<HomeState> {
  HomeCubit(
    this._getQrCodesStreamUseCase,
    this._qrCodeRepository,
  ) : super(HomeState()) {
    _subscribeToQrCodeChanges();
  }

  final GetQrCodesStreamUseCase _getQrCodesStreamUseCase;
  final QrCodeRepository _qrCodeRepository;

  void _subscribeToQrCodeChanges() {
    executeStream(_getQrCodesStreamUseCase.listen((final qrCodes) {
      emit(state.copyWith(qrCodes: qrCodes));
    }));
  }


  void deleteQrCode(final QrCodeEntity qrCode) {
    executeAsync(_qrCodeRepository.deleteQrCode(qrCode.id));
  }

  Future<void> loadNearestQrCode(final BuildContext context) async {
    try {
      final Position position = await getIt<GeoPositionService>().determinePosition();
      final List<QrCodeEntity> nearbyQrCodes = (await _qrCodeRepository.getNearbyQrCodes(
        position.latitude,
        position.longitude,
      )).fold(
        (final error) => [],
        (final qrCodes) => qrCodes,
      );
      if (nearbyQrCodes.isNotEmpty) {
        NearestQrCodeDialog.show(context, qrCode: nearbyQrCodes.first);
      }
    } catch (e) {
      print('Error loading nearest QR code: $e');
    }
  }
}
