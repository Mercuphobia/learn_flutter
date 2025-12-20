import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String profession,
    required String email,          // Đã thêm kiểu String
    required DateTime dateOfBirth,  // Đã thêm kiểu DateTime
    required String location,
    required String avatarUrl,
  }) = _UserModel;

  // Hỗ trợ từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // Data mẫu
  static UserModel dummyData() {
    return UserModel(
      id: '1',
      name: 'Philip Williamson',
      profession: 'UI UX Designer',
      email: 'philip@gmail.com',
      dateOfBirth: DateTime(2001, 12, 10),
      location: 'HANOI, VN',
      avatarUrl: 'assets/images/google.png',
    );
  }
}