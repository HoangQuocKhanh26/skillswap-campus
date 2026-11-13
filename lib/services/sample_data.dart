import '../models/skill.dart';
import '../models/swap_request.dart';
import '../models/user.dart';

/// Dữ liệu giả lập cho buổi demo: 18 hồ sơ sinh viên + một tài khoản demo.
class SampleData {
  SampleData._();

  static User _u({
    required String id,
    required String name,
    required String major,
    required String year,
    required String bio,
    required List<String> teach,
    required List<String> learn,
    required double rating,
    required int reviewCount,
    String responseTime = 'trong 2 giờ',
    String campus = 'Campus Hà Nội',
  }) {
    return User(
      id: id,
      name: name,
      bio: bio,
      avatarUrl: 'assets/avatars/$id.png',
      major: major,
      year: year,
      campus: campus,
      rating: rating,
      reviewCount: reviewCount,
      responseTime: responseTime,
      teachingSkills: teach.map(Skill.fromName).toList(),
      learningSkills: learn.map(Skill.fromName).toList(),
    );
  }

  static final List<User> users = [
    _u(
      id: 'u01',
      name: 'Minh Anh',
      major: 'Kỹ thuật phần mềm',
      year: 'K18',
      bio:
          'Mình làm backend Java được 2 năm, thích giải thích code bằng ví dụ đời thường. Rảnh tối thứ 3 – 5, ưu tiên học ở thư viện.',
      teach: ['Java', 'Tiếng Anh', 'SQL'],
      learn: ['Flutter', 'UI/UX'],
      rating: 4.9,
      reviewCount: 24,
      responseTime: 'trong 1 giờ',
    ),
    _u(
      id: 'u02',
      name: 'Gia Huy',
      major: 'Công nghệ thông tin',
      year: 'K17',
      bio:
          'Flutter enthusiast, đã làm 3 app cho câu lạc bộ. Mình có thể chỉ bạn từ setup đến deploy Firebase.',
      teach: ['Flutter', 'Firebase', 'Git'],
      learn: ['Java', 'Public Speaking'],
      rating: 4.7,
      reviewCount: 16,
    ),
    _u(
      id: 'u03',
      name: 'Thảo Vy',
      major: 'Thiết kế đồ hoạ',
      year: 'K18',
      bio:
          'Mình thích dạy Photoshop theo kiểu “làm thật, sửa thật”. Có thể review portfolio hoặc cùng làm poster cho CLB.',
      teach: ['Photoshop', 'Illustrator', 'Figma', 'UI/UX'],
      learn: ['HTML', 'CSS'],
      rating: 4.8,
      reviewCount: 31,
      responseTime: 'trong 3 giờ',
    ),
    _u(
      id: 'u04',
      name: 'Đức Long',
      major: 'Khoa học máy tính',
      year: 'K17',
      bio:
          'Mình làm data analysis cho một startup giáo dục. Muốn học Flutter để tự làm app nhỏ, sẵn sàng đổi lại Python/SQL.',
      teach: ['Python', 'SQL', 'Data Analysis'],
      learn: ['Flutter', 'Tiếng Anh'],
      rating: 4.9,
      reviewCount: 12,
    ),
    _u(
      id: 'u05',
      name: 'Lan Chi',
      major: 'Ngôn ngữ Anh',
      year: 'K19',
      bio:
          'IELTS 7.5, từng trợ giảng lớp speaking. Mình dạy theo chủ đề bạn quan tâm, không học thuộc lòng. Đang muốn học Flutter để làm app học từ vựng.',
      teach: ['Tiếng Anh', 'Public Speaking'],
      learn: ['Photoshop', 'Video Editing', 'Flutter'],
      rating: 5,
      reviewCount: 18,
      responseTime: 'trong 30 phút',
    ),
    _u(
      id: 'u06',
      name: 'Bảo Trâm',
      major: 'Marketing',
      year: 'K18',
      bio:
          'Mình chạy content cho 2 fanpage sinh viên. Muốn học Figma để tự dựng landing page thay vì chờ designer.',
      teach: ['Marketing', 'Video Editing'],
      learn: ['Figma', 'UI/UX'],
      rating: 4.6,
      reviewCount: 9,
    ),
    _u(
      id: 'u07',
      name: 'Quốc Bảo',
      major: 'Công nghệ thông tin',
      year: 'K19',
      bio:
          'Mình mê C++ và competitive programming. Có thể cùng bạn luyện thuật toán, đổi lại mình muốn nhập môn Python.',
      teach: ['C++', 'Git'],
      learn: ['Python', 'Machine Learning'],
      rating: 4.5,
      reviewCount: 7,
      responseTime: 'trong 5 giờ',
    ),
    _u(
      id: 'u08',
      name: 'Hồng Ngọc',
      major: 'Kinh tế quốc tế',
      year: 'K18',
      bio:
          'Thành thạo Excel, pivot table và dashboard cơ bản. Mình cần cải thiện speaking để chuẩn bị trao đổi học kỳ tới.',
      teach: ['Excel', 'Data Analysis'],
      learn: ['Tiếng Anh', 'Public Speaking'],
      rating: 4.7,
      reviewCount: 14,
    ),
    _u(
      id: 'u09',
      name: 'Tuấn Kiệt',
      major: 'Kỹ thuật phần mềm',
      year: 'K17',
      bio:
          'Full-stack JS, thích pair programming. Mình có thể chỉ React/Node qua một project thật trong 3 buổi, và đang ôn lại Java để hỗ trợ đồ án.',
      teach: ['React', 'Node.js', 'JavaScript', 'Java'],
      learn: ['UI/UX', 'Tiếng Anh'],
      rating: 4.8,
      reviewCount: 21,
    ),
    _u(
      id: 'u10',
      name: 'Mai Phương',
      major: 'Ngôn ngữ Nhật',
      year: 'K18',
      bio:
          'JLPT N2, đang làm gia sư tiếng Nhật cho sinh viên năm nhất. Muốn học marketing để phát triển kênh học tiếng.',
      teach: ['Tiếng Nhật', 'Tiếng Anh'],
      learn: ['Marketing', 'Photoshop'],
      rating: 4.9,
      reviewCount: 27,
      responseTime: 'trong 2 giờ',
    ),
    _u(
      id: 'u11',
      name: 'Hoàng Nam',
      major: 'Công nghệ thông tin',
      year: 'K18',
      bio:
          'Mình viết app Android bằng Kotlin/Java, đã publish 2 app lên Play Store. Muốn chuyển dần sang React Native.',
      teach: ['Android', 'Java', 'Git'],
      learn: ['React', 'Node.js'],
      rating: 4.6,
      reviewCount: 11,
    ),
    _u(
      id: 'u12',
      name: 'Thanh Hà',
      major: 'Thiết kế',
      year: 'K19',
      bio:
          'Mình thích wireframe bằng giấy trước khi vẽ Figma. Có thể dạy UI/UX từ con số 0, cần đổi lại HTML/CSS.',
      teach: ['Figma', 'UI/UX', 'Vẽ tay'],
      learn: ['HTML', 'CSS', 'JavaScript'],
      rating: 4.9,
      reviewCount: 23,
      responseTime: 'trong 1 giờ',
    ),
    _u(
      id: 'u13',
      name: 'Đình Khoa',
      major: 'Khoa học máy tính',
      year: 'K16',
      bio:
          'Mình làm ML ở phòng lab, thích đọc paper và build demo nhỏ. Đang tập thuyết trình để bảo vệ khoá luận.',
      teach: ['Machine Learning', 'Python'],
      learn: ['Public Speaking', 'Tiếng Anh'],
      rating: 5,
      reviewCount: 33,
      responseTime: 'trong 4 giờ',
    ),
    _u(
      id: 'u14',
      name: 'Yến Nhi',
      major: 'Quản trị du lịch',
      year: 'K18',
      bio:
          'Mình biết nấu món Hàn và có thể dạy tiếng Hàn giao tiếp cơ bản. Muốn học marketing du lịch và tiếng Anh.',
      teach: ['Tiếng Hàn', 'Nấu ăn'],
      learn: ['Tiếng Anh', 'Marketing'],
      rating: 4.8,
      reviewCount: 19,
    ),
    _u(
      id: 'u15',
      name: 'Việt Dũng',
      major: 'Công nghệ thông tin',
      year: 'K19',
      bio:
          'Mình tự học web front-end và đang làm portfolio. Muốn tìm người kèm Flutter để làm app quản lý chi tiêu.',
      teach: ['HTML', 'CSS', 'JavaScript'],
      learn: ['Flutter', 'Git'],
      rating: 4.4,
      reviewCount: 6,
      responseTime: 'trong 6 giờ',
    ),
    _u(
      id: 'u16',
      name: 'Khánh Linh',
      major: 'Tâm lý học',
      year: 'K17',
      bio:
          'Mình là MC của CLB và dạy yoga buổi sáng. Muốn cải thiện tiếng Anh và Excel để làm báo cáo nghiên cứu.',
      teach: ['Public Speaking', 'Yoga'],
      learn: ['Excel', 'Tiếng Anh'],
      rating: 4.9,
      reviewCount: 15,
      responseTime: 'trong 2 giờ',
    ),
    _u(
      id: 'u17',
      name: 'Nhật Minh',
      major: 'Âm nhạc',
      year: 'K18',
      bio:
          'Mình chơi guitar 6 năm và dựng video cho các sự kiện trường. Muốn học marketing để quảng bá lớp học guitar.',
      teach: ['Guitar', 'Video Editing'],
      learn: ['Marketing', 'Photoshop'],
      rating: 4.7,
      reviewCount: 13,
    ),
    _u(
      id: 'u18',
      name: 'Phương Thảo',
      major: 'Công nghệ thông tin',
      year: 'K18',
      bio:
          'Mình làm UI/UX cho app học tập của CLB, thích feedback thẳng nhưng tích cực. Có thể dạy Flutter cơ bản.',
      teach: ['Flutter', 'UI/UX'],
      learn: ['Python', 'Data Analysis'],
      rating: 4.8,
      reviewCount: 20,
      responseTime: 'trong 3 giờ',
    ),
  ];

  static final User demoUser = _u(
    id: 'me',
    name: 'Ngọc Anh',
    major: 'Kỹ thuật phần mềm',
    year: 'K18',
    bio:
        'Mình thích làm app Flutter và thiết kế giao diện. Muốn học Java vững hơn và cải thiện thuyết trình trước đám đông.',
    teach: ['Flutter', 'HTML', 'Tiếng Anh'],
    learn: ['Java', 'UI/UX', 'Public Speaking'],
    rating: 4.8,
    reviewCount: 12,
    responseTime: 'trong 1 giờ',
  );

  static User userById(String id) {
    if (id == demoUser.id) return demoUser;
    return users.firstWhere(
      (user) => user.id == id,
      orElse: () => demoUser,
    );
  }

  static DateTime _at(DateTime base, int daysFromNow, int hour, int minute) {
    return DateTime(
      base.year,
      base.month,
      base.day + daysFromNow,
      hour,
      minute,
    );
  }

  /// Tạo sẵn các yêu cầu ở mọi nhánh của vòng đời để demo thuyết phục.
  static List<SwapRequest> seedRequests({
    required String currentUserId,
    required DateTime now,
  }) {
    return [
      // 1. Đã gửi, đang chờ phản hồi
      SwapRequest(
        id: 'seed-01',
        senderId: currentUserId,
        receiverId: 'u12',
        message:
            'Chào Hà, mình thấy bạn đang học HTML/CSS còn mình cần học UI/UX. Mình có thể đổi một buổi Flutter/HTML nhé!',
        createdAt: now.subtract(const Duration(hours: 8)),
        expiresAt: now.add(const Duration(hours: 40)),
      ),
      // 2. Lời mời nhận được, còn nhiều thời gian
      SwapRequest(
        id: 'seed-02',
        senderId: 'u16',
        receiverId: currentUserId,
        message:
            'Ngọc Anh ơi, mình muốn luyện tiếng Anh giao tiếp. Mình có thể dạy bạn Public Speaking hoặc một buổi yoga nhé!',
        createdAt: now.subtract(const Duration(hours: 2)),
        expiresAt: now.add(const Duration(hours: 46)),
      ),
      // 3. Lời mời nhận được, sắp hết hạn (demo nhánh hết hạn)
      SwapRequest(
        id: 'seed-03',
        senderId: 'u11',
        receiverId: currentUserId,
        message:
            'Mình đang cần ôn Java để làm đồ án Android. Có thể trao đổi với bạn một buổi về Git hoặc Android cơ bản không?',
        createdAt: now.subtract(const Duration(hours: 20)),
        expiresAt: now.add(const Duration(hours: 4)),
      ),
      // 4. Đã chấp nhận, chưa chọn lịch
      SwapRequest(
        id: 'seed-04',
        senderId: currentUserId,
        receiverId: 'u15',
        message:
            'Dũng ơi, mình kèm bạn Flutter còn bạn chỉ mình Git workflow nhé?',
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        expiresAt: now.subtract(const Duration(days: 1, hours: 3)),
        status: SwapStatus.accepted,
        respondedAt: now.subtract(const Duration(days: 1, hours: 5)),
      ),
      // 5. Đã đặt lịch, sắp diễn ra
      SwapRequest(
        id: 'seed-05',
        senderId: currentUserId,
        receiverId: 'u03',
        message:
            'Vy ơi, mình muốn học Figma/UI/UX, đổi lại mình dạy HTML/CSS nhé!',
        createdAt: now.subtract(const Duration(days: 5)),
        expiresAt: now.subtract(const Duration(days: 4)),
        status: SwapStatus.scheduled,
        respondedAt: now.subtract(const Duration(days: 4, hours: 20)),
        sessions: [
          SwapSession(
            id: 'seed-05-s1',
            startTime: _at(now, 1, 15, 0),
            durationMinutes: 90,
            location: 'Thư viện tầng 3 · Bàn 12',
            mode: SessionMode.offline,
            note: 'Mang laptop và file thiết kế đang làm dở để cùng review.',
          ),
        ],
      ),
      // 6. Đã đặt lịch online
      SwapRequest(
        id: 'seed-06',
        senderId: 'u02',
        receiverId: currentUserId,
        message:
            'Mình muốn học Flutter nâng cao từ bạn, đổi lại mình chỉ Firebase/Git nhé.',
        createdAt: now.subtract(const Duration(days: 3)),
        expiresAt: now.subtract(const Duration(days: 2)),
        status: SwapStatus.scheduled,
        respondedAt: now.subtract(const Duration(days: 2, hours: 18)),
        sessions: [
          SwapSession(
            id: 'seed-06-s1',
            startTime: _at(now, 3, 9, 0),
            durationMinutes: 60,
            location: 'Google Meet · meet.google.com/skillswap',
            mode: SessionMode.online,
            note: 'Buổi 1: cấu trúc project và state management.',
          ),
        ],
      ),
      // 7. Đã hoàn thành, cả hai đã đánh giá
      SwapRequest(
        id: 'seed-07',
        senderId: currentUserId,
        receiverId: 'u01',
        message:
            'Minh Anh ơi, mình muốn học Java cơ bản, mình đổi lại một buổi Flutter nhé!',
        createdAt: now.subtract(const Duration(days: 14)),
        expiresAt: now.subtract(const Duration(days: 13)),
        status: SwapStatus.completed,
        respondedAt: now.subtract(const Duration(days: 13, hours: 20)),
        sessions: [
          SwapSession(
            id: 'seed-07-s1',
            startTime: _at(now, -3, 15, 0),
            durationMinutes: 60,
            location: 'Thư viện tầng 2 · Phòng học nhóm 4',
            mode: SessionMode.offline,
            status: SessionStatus.completed,
          ),
        ],
        reviews: [
          Review(
            id: 'seed-07-r1',
            sessionId: 'seed-07-s1',
            matchId: 'seed-07',
            fromUserId: currentUserId,
            toUserId: 'u01',
            rating: 5,
            comment:
                'Anh giải thích Java rất dễ hiểu, có ví dụ thực tế và kiên nhẫn sửa lỗi cùng mình.',
            tags: const ['Giải thích dễ hiểu', 'Kiên nhẫn'],
            createdAt: _at(now, -3, 17, 30),
          ),
          Review(
            id: 'seed-07-r2',
            sessionId: 'seed-07-s1',
            matchId: 'seed-07',
            fromUserId: 'u01',
            toUserId: currentUserId,
            rating: 5,
            comment:
                'Ngọc Anh chuẩn bị ví dụ Flutter rất kỹ, buổi học đúng giờ và vui.',
            tags: const ['Chuẩn bị chu đáo', 'Đúng giờ'],
            createdAt: _at(now, -3, 18, 5),
          ),
        ],
      ),
      // 8. Đã hoàn thành, đang chờ mình đánh giá
      SwapRequest(
        id: 'seed-08',
        senderId: 'u18',
        receiverId: currentUserId,
        message:
            'Mình muốn học Flutter với bạn, đổi lại mình dạy UI/UX và review portfolio nhé!',
        createdAt: now.subtract(const Duration(days: 8)),
        expiresAt: now.subtract(const Duration(days: 7)),
        status: SwapStatus.completed,
        respondedAt: now.subtract(const Duration(days: 7, hours: 12)),
        sessions: [
          SwapSession(
            id: 'seed-08-s1',
            startTime: _at(now, -1, 18, 0),
            durationMinutes: 90,
            location: 'Căng tin A · Khu ngoài trời',
            mode: SessionMode.offline,
            status: SessionStatus.completed,
          ),
        ],
        reviews: [
          Review(
            id: 'seed-08-r1',
            sessionId: 'seed-08-s1',
            matchId: 'seed-08',
            fromUserId: 'u18',
            toUserId: currentUserId,
            rating: 5,
            comment:
                'Buổi học rất hiệu quả, Ngọc Anh chỉ mình cách tách widget và debug layout nhanh.',
            tags: const ['Đúng giờ', 'Truyền cảm hứng'],
            createdAt: _at(now, -1, 20, 10),
          ),
        ],
      ),
      // 9. Bị từ chối
      SwapRequest(
        id: 'seed-09',
        senderId: currentUserId,
        receiverId: 'u06',
        message:
            'Trâm ơi, mình muốn học Marketing, đổi lại mình dạy Flutter/HTML nhé!',
        createdAt: now.subtract(const Duration(days: 4)),
        expiresAt: now.subtract(const Duration(days: 3)),
        status: SwapStatus.rejected,
        respondedAt: now.subtract(const Duration(days: 3, hours: 18)),
      ),
      // 10. Đã hết hạn
      SwapRequest(
        id: 'seed-10',
        senderId: currentUserId,
        receiverId: 'u14',
        message:
            'Nhi ơi, mình muốn học tiếng Hàn giao tiếp cơ bản, đổi lại mình dạy tiếng Anh nhé!',
        createdAt: now.subtract(const Duration(days: 7)),
        expiresAt: now.subtract(const Duration(days: 6)),
        status: SwapStatus.expired,
      ),
      // 11. Đã huỷ sau khi đặt lịch
      SwapRequest(
        id: 'seed-11',
        senderId: 'u17',
        receiverId: currentUserId,
        message:
            'Mình muốn học Photoshop để làm thumbnail, đổi lại mình dạy guitar nhé!',
        createdAt: now.subtract(const Duration(days: 5)),
        expiresAt: now.subtract(const Duration(days: 4)),
        status: SwapStatus.cancelled,
        respondedAt: now.subtract(const Duration(days: 4, hours: 15)),
        cancelReason: 'Mình bận lịch thi giữa kỳ, hẹn bạn lần sau nhé!',
        sessions: [
          SwapSession(
            id: 'seed-11-s1',
            startTime: _at(now, -2, 10, 0),
            durationMinutes: 60,
            location: 'Thư viện tầng 3',
            mode: SessionMode.offline,
            status: SessionStatus.cancelled,
          ),
        ],
      ),
    ];
  }
}
