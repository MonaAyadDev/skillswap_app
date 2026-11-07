import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/core/models/models.dart';

void main() {
  test('UserModel test properties', () {
    const user = UserModel(
      uid: 'user_123',
      name: 'Elena Rostova',
      bio: 'Product Designer',
      country: 'USA',
      teachSkills: ['UI/UX', 'Figma'],
      learnSkills: ['Flutter'],
      ratingAvg: 4.9,
    );

    expect(user.uid, 'user_123');
    expect(user.name, 'Elena Rostova');
    expect(user.teachSkills.length, 2);
    expect(user.learnSkills.first, 'Flutter');
  });

  test('RequestModel test status', () {
    const request = RequestModel(
      id: 'req_123',
      fromUserId: 'u1',
      toUserId: 'u2',
      skillToTeach: 'Flutter',
      skillToLearn: 'UI/UX',
      status: RequestStatus.pending,
    );

    expect(request.status, RequestStatus.pending);
    final accepted = request.copyWith(status: RequestStatus.accepted);
    expect(accepted.status, RequestStatus.accepted);
  });
}
