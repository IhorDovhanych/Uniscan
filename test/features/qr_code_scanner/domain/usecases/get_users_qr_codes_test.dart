import 'package:uniscan/features/qr_code_scanner/domain/repositories/qr_code_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockQrCodeRepository extends Mock implements QrCodeRepository {}

void main(){
  GetUsersQrCodes usecase;
  MockQrCodeRepository mockQrCodeRepository;

  setUp(() {
    mockQrCodeRepository = MockQrCodeRepository();
    usecase = GetUsersQrCodes(mockQrCodeRepository);
  });
}