/// Bộ dịch nhẹ cho toàn bộ giao diện.
///
/// Khoá là chuỗi tiếng Việt gốc, giá trị là bản dịch tiếng Anh. Cách này giữ
/// cho call-site ngắn (`tr('Khám phá')`) và không cần sinh file ARB, phù hợp
/// với đồ án demo một ngôn ngữ gốc.
class AppText {
  AppText._();

  static String language = 'vi';

  static bool get isEnglish => language == 'en';

  static String t(String vi) {
    if (!isEnglish) return vi;
    return _en[vi] ?? vi;
  }

  /// Dịch một câu có tham số dạng `{name}`.
  static String a(String vi, Map<String, String> values) {
    var out = t(vi);
    for (final entry in values.entries) {
      out = out.replaceAll('{${entry.key}}', entry.value);
    }
    return out;
  }

  static const Map<String, String> _en = {
    // ------------------------------------------------------------------ chung
    'Khám phá': 'Discover',
    'Yêu cầu': 'Requests',
    'Lịch hẹn': 'Schedule',
    'Hồ sơ': 'Profile',
    'Cài đặt': 'Settings',
    'Huỷ': 'Cancel',
    'Lưu': 'Save',
    'Lưu thay đổi': 'Save changes',
    'Đóng': 'Close',
    'Chọn': 'Choose',
    'Tất cả': 'All',
    'Đánh giá': 'Review',
    'Xem chi tiết': 'View details',
    'Đổi lịch': 'Reschedule',
    'Kết thúc': 'End',
    'Bạn đánh giá': 'Your review',
    'Gửi lời mời': 'Send request',
    'Bỏ qua': 'Skip',
    'Chi tiết': 'Details',
    'Kết nối': 'Connect',
    'Hoàn tác': 'Undo',
    'Xoá bộ lọc': 'Clear filters',
    'Trực tiếp': 'In person',
    'Trực tuyến': 'Online',
    'Sắp tới': 'Upcoming',
    'Đã xong': 'Completed',
    'Tháng': 'Month',
    'Đang chờ': 'Pending',
    'Đã chấp nhận': 'Accepted',
    'Đã đặt lịch': 'Scheduled',
    'Đã hoàn thành': 'Completed',
    'Đã từ chối': 'Declined',
    'Hết hạn': 'Expired',
    'Đã huỷ': 'Cancelled',
    'Đang chờ phản hồi': 'Awaiting response',
    'Chờ phản hồi': 'Awaiting response',
    'Sắp diễn ra': 'Upcoming',
    'Đã ghép đôi': 'Matched',
    'Chờ bạn đánh giá': 'Your review is due',
    'Chưa đánh giá': 'No review yet',
    'Chưa có đánh giá': 'No reviews yet',
    'Bạn đã đánh giá buổi học': 'You reviewed this session',
    'Đối phương chưa đánh giá': 'Partner has not reviewed yet',
    'Bạn chưa đánh giá buổi học này': "You haven't reviewed this session",
    'Buổi học': 'Session',
    'Buổi học đã kết thúc': 'The session has ended',
    'Buổi học đã kết thúc · Chờ bạn đánh giá':
        'Session ended · Your review is due',
    'Buổi trao đổi đã bị huỷ': 'The swap was cancelled',
    'Buổi trao đổi đã được lên lịch': 'The swap is scheduled',
    'Hai bạn đã ghép đôi, hãy chọn lịch học':
        "You're matched — pick a schedule",
    'Lời mời đã bị từ chối': 'The request was declined',
    'Lời mời quá hạn phản hồi': 'The request expired',
    'Lời mời không được chấp nhận': 'The request was not accepted',
    'Hết hạn phản hồi': 'Request expired',
    'Đã huỷ buổi trao đổi': 'Swap cancelled',
    'Đã hoàn thành buổi trao đổi': 'Swap completed',
    'Đã ghép đôi · chưa chọn lịch': 'Matched · no schedule yet',
    'Đã ghép đôi · chọn lịch học trong tab Lịch hẹn':
        'Matched · pick a schedule in the Schedule tab',
    'Chưa đặt lịch': 'Not scheduled',
    'Hai bạn chưa chọn thời gian': 'No time selected yet',
    'Sau khi buổi học kết thúc': 'After the session ends',
    'Hoàn thành & đánh giá': 'Complete & review',
    'Đổi lịch học': 'Reschedule',
    'Đặt lịch học': 'Schedule session',
    'Chọn lịch học': 'Pick a schedule',
    'Vòng đời ghép đôi': 'Match timeline',
    'Lời nhắn': 'Message',
    'Chấp nhận ghép đôi': 'Accept match',
    'Demo: đối phương đồng ý': 'Demo: partner accepts',
    'Huỷ buổi': 'Cancel session',
    'Huỷ kết nối': 'Cancel match',
    'Kết thúc (demo)': 'End (demo)',
    'Đánh giá hai chiều': 'Two-way review',
    'Đánh giá ngay': 'Review now',
    'Thu hồi lời mời': 'Withdraw request',

    // ---------------------------------------------------------------- đăng nhập
    'Chào mừng trở lại': 'Welcome back',
    'Dùng email sinh viên để tiếp tục': 'Use your student email to continue',
    'Email chưa đúng định dạng': 'Invalid email format',
    'Mật khẩu': 'Password',
    'Mật khẩu cần ít nhất 6 ký tự': 'Password must be at least 6 characters',
    'Tối thiểu 6 ký tự': 'At least 6 characters',
    'Vui lòng nhập email': 'Please enter your email',
    'Đăng nhập': 'Sign in',
    'hoặc': 'or',
    'Tạo hồ sơ sinh viên mới': 'Create a new student profile',
    'Vào bằng tài khoản demo': 'Continue with demo account',
    'Dữ liệu trong app là hồ sơ giả lập phục vụ demo môn học.':
        'All data is simulated for a course demo.',
    'Kết nối – trao đổi – cùng tiến bộ\nngay trong lớp học của bạn':
        'Connect – swap – grow together\nright in your classroom',

    // --------------------------------------------------------------- khám phá
    'Tìm tên, ngành hoặc kỹ năng...': 'Search name, major or skill...',
    'Trao đổi 2 chiều': 'Two-way swap',
    'Sắp xếp theo độ phù hợp': 'Sorted by match',
    'Không tìm thấy hồ sơ phù hợp': 'No matching profiles',
    'Thử xoá bộ lọc hoặc tìm bằng tên kỹ năng khác nhé.':
        'Try clearing filters or searching another skill.',
    'Bạn đã xem hết hồ sơ rồi!': "You've seen every profile!",
    'Các hồ sơ đã bỏ qua sẽ được đưa trở lại nếu bạn muốn xem lại.':
        'Skipped profiles can be brought back anytime.',
    'Xem lại tất cả hồ sơ': 'Review all profiles',
    'Gợi ý cho bạn': 'Suggested for you',
    'Họ dạy bạn': 'They teach you',
    'Bạn dạy họ': 'You teach them',
    'Có thể dạy': 'Can teach',
    'Muốn học: ': 'Wants to learn: ',
    'Chưa có kỹ năng trùng': 'No matching skills',
    'Thử kỹ năng khác': 'Try another skill',
    'Xem hồ sơ': 'View profile',

    // ----------------------------------------------------------- hồ sơ / sửa
    'Hồ sơ của tôi': 'My profile',
    'Chỉnh sửa hồ sơ': 'Edit profile',
    'Chỉnh sửa hồ sơ của tôi': 'Edit my profile',
    'Kỹ năng của tôi': 'My skills',
    'Đánh giá nhận được': 'Reviews received',
    'Đánh giá TB': 'Avg rating',
    'Buổi hoàn thành': 'Sessions',
    'Đối tác học': 'Partners',
    'Chờ đánh giá': 'Awaiting review',
    'Chưa có đánh giá nào. Hoàn thành buổi học đầu tiên để nhận đánh giá từ đối phương.':
        'No reviews yet. Complete your first session to get one.',
    'Chưa có kỹ năng dạy': 'No teaching skills yet',
    'Chưa có kỹ năng muốn học': 'No learning skills yet',
    'Chưa có giới thiệu. Bấm chỉnh sửa để thêm vài dòng về bạn.':
        'No bio yet. Tap edit to add a few lines.',
    'Cập nhật kỹ năng': 'Update skills',
    'Kịch bản demo': 'Demo script',
    'Dùng các nút bên dưới để thuyết trình.':
        'Use the buttons below for your presentation.',
    'Dữ liệu demo đã bao gồm đủ các nhánh: chờ phản hồi, đã ghép đôi, ':
        'Demo data covers every branch: pending, matched, ',
    'đã đặt lịch, hoàn thành, bị từ chối, hết hạn và đã huỷ. ':
        'scheduled, completed, declined, expired and cancelled. ',
    'Reset dữ liệu': 'Reset data',
    'Đặt lại dữ liệu demo?': 'Reset demo data?',
    'Toàn bộ lời mời, lịch học và đánh giá sẽ trở về trạng thái ban đầu. ':
        'All requests, sessions and reviews return to their initial state. ',
    'Hồ sơ của bạn vẫn được giữ nguyên.': 'Your profile stays unchanged.',
    'Đặt lại': 'Reset',
    'Đăng xuất': 'Sign out',
    'Khôi phục hồ sơ': 'Restore profiles',
    'Đã khôi phục các hồ sơ đã bỏ qua.': 'Skipped profiles restored.',
    'Đã reset dữ liệu demo về ban đầu.': 'Demo data reset.',
    'SkillSwap Campus · bản demo môn học\nDữ liệu sinh viên là giả lập':
        'SkillSwap Campus · course demo\nStudent data is simulated',
    'Họ và tên': 'Full name',
    'Họ và tên không được để trống.': "Full name can't be empty.",
    'Ngành học': 'Major',
    'Vui lòng nhập ngành học.': 'Please enter your major.',
    'Khoá': 'Cohort',
    'Giới thiệu bản thân': 'About you',
    'Kỹ năng có thể dạy': 'Skills you can teach',
    'Kỹ năng muốn học': 'Skills you want to learn',
    'Thông tin cá nhân': 'Personal info',
    'Chọn những gì bạn tự tin chia sẻ':
        "Pick what you're confident sharing",
    'Chọn những gì bạn muốn trao đổi': "Pick what you'd like to swap",
    'Hãy chọn ít nhất một kỹ năng có thể dạy.':
        'Choose at least one skill you can teach.',
    'Hãy chọn ít nhất một kỹ năng muốn học.':
        'Choose at least one skill you want to learn.',
    'Chưa có kỹ năng nào. Bấm “Chọn” để thêm.':
        'No skills yet. Tap "Choose" to add.',
    'Ảnh đại diện tự động': 'Automatic avatar',
    'Ảnh đại diện được tạo tự động từ tên trong bản demo.':
        'Avatar is generated from your name in this demo.',
    'Ảnh đại diện được tạo tự động từ tên của bạn trong bản demo.':
        'Avatar is generated from your name in this demo.',
    'Đã cập nhật hồ sơ của bạn.': 'Your profile has been updated.',

    // ------------------------------------------------------------ tạo hồ sơ
    'Tạo hồ sơ sinh viên': 'Create student profile',
    'Hoàn tất hồ sơ': 'Complete profile',
    'Thông tin': 'Info',
    'Kỹ năng dạy': 'Teaching',
    'Kỹ năng học': 'Learning',
    'Tiếp tục': 'Continue',
    'Dùng mẫu': 'Use sample',
    'Họ và tên *': 'Full name *',
    'Ngành học *': 'Major *',
    'Bạn có thể dạy gì?': 'What can you teach?',
    'Bạn muốn học gì?': 'What do you want to learn?',
    'Bạn đang học gì, có kinh nghiệm gì và muốn trao đổi điều gì?':
        'What are you studying, what experience do you have, and what would you like to swap?',
    'Chọn ít nhất một kỹ năng bạn có thể dạy.':
        'Choose at least one skill you can teach.',
    'Chọn ít nhất một kỹ năng bạn muốn học.':
        'Choose at least one skill you want to learn.',
    'Chọn những kỹ năng bạn tự tin chia sẻ cho bạn học. ':
        "Pick skills you're confident teaching others. ",
    'Chọn kỹ năng bạn muốn trao đổi. App sẽ ưu tiên gợi ý ':
        "Pick skills you'd like to swap. We'll prioritise ",
    'người có thể dạy đúng những kỹ năng này.':
        'people who can teach exactly these.',
    'Không cần là chuyên gia, chỉ cần hơn người cần học một chút!':
        'No need to be an expert — just a step ahead of your learner!',
    'Mẹo: hồ sơ càng cụ thể càng dễ được ghép cặp. ':
        'Tip: the more specific your profile, the better your matches. ',
    'Bạn có thể chỉnh sửa kỹ năng bất cứ lúc nào trong Hồ sơ.':
        'You can edit skills anytime in Profile.',
    'Vui lòng nhập họ và tên của bạn.': 'Please enter your full name.',
    'Vui lòng nhập ngành học của bạn.': 'Please enter your major.',
    'Ví dụ “mình biết Flutter, muốn học Java”.':
        'E.g. "I know Flutter, I want to learn Java".',
    'Ví dụ: Ngọc Anh': 'E.g. Ngoc Anh',
    'Đã điền hồ sơ mẫu, bạn có thể chỉnh lại.':
        'Sample profile filled in — feel free to adjust.',
    'Kỹ thuật phần mềm': 'Software Engineering',
    'Truyền thông đa phương tiện': 'Multimedia Communications',
    'Minh Thư': 'Minh Thu',
    'Mình làm content và dựng video cho CLB. Muốn học Flutter để tự làm app quản lý lịch học và portfolio.':
        'I create content and edit videos for my club. I want to learn Flutter to build my own schedule and portfolio app.',
    'Mình mới tham gia SkillSwap Campus và đang tìm người cùng trao đổi kỹ năng.':
        "I'm new to SkillSwap Campus and looking for skill-swap partners.",

    // ---------------------------------------------------------------- yêu cầu
    'Yêu cầu ghép đôi': 'Swap requests',
    'Nhận được': 'Incoming',
    'Đã gửi': 'Sent',
    'Lịch sử': 'History',
    'Chưa có lời mời nào': 'No requests yet',
    'Chưa gửi lời mời nào': 'No sent requests',
    'Chưa có lịch sử ghép đôi': 'No match history',
    'Chấp nhận': 'Accept',
    'Từ chối': 'Decline',
    'Thu hồi': 'Withdraw',
    'Demo: đồng ý': 'Demo: accept',
    'Bạn có 48 giờ để phản hồi trước khi lời mời hết hạn.':
        'You have 48 hours to respond before this request expires.',
    'Bạn có thể thu hồi bất cứ lúc nào.': 'You can withdraw anytime.',
    'Hãy sang tab Khám phá, vuốt sang phải hoặc bấm Kết nối để gửi lời mời tới người phù hợp.':
        'Go to Discover, swipe right or tap Connect to send a request.',
    'Khi có bạn học muốn trao đổi kỹ năng, lời mời sẽ xuất hiện ở đây. ':
        'Requests from study partners will appear here. ',
    'Lời mời nhận được có hiệu lực 48 giờ. Bạn có thể chấp nhận, ':
        'Incoming requests are valid for 48 hours. You can accept, ',
    'từ chối hoặc để hết hạn — mọi nhánh đều được lưu vào Lịch sử.':
        'decline or let them expire — every branch is saved in History.',
    'Lời mời đã gửi sẽ tự động hết hạn sau 48 giờ nếu chưa có phản hồi. ':
        'Sent requests expire automatically after 48 hours without a response. ',
    'Các lời mời đã chấp nhận, từ chối, hết hạn, huỷ hoặc hoàn thành sẽ được lưu ở đây.':
        'Accepted, declined, expired, cancelled or completed requests are saved here.',

    // ---------------------------------------------------------------- lịch hẹn
    'Chưa có buổi học nào': 'No sessions yet',
    'Chưa có buổi học hoàn thành': 'No completed sessions',
    'Khi lời mời được chấp nhận, bạn có thể chọn thời gian, địa điểm ':
        'Once a request is accepted, choose a time and place ',
    'và buổi học sẽ xuất hiện trong lịch.':
        'and the session appears on your schedule.',
    'Sau khi buổi học kết thúc, bạn và đối phương có thể gửi đánh giá hai chiều tại đây.':
        'After a session ends, both of you can review each other here.',
    'Đổi lịch hoặc huỷ trước ít nhất 2 giờ để giữ điểm uy tín nhé.':
        'Reschedule or cancel at least 2 hours ahead to protect your reputation.',
    'Ngày học': 'Date',
    'Chọn ngày': 'Choose date',
    'Chọn ngày học': 'Choose session date',
    'Thời gian': 'Time',
    'Bắt đầu': 'Start',
    'Chọn giờ': 'Choose time',
    'Chọn giờ bắt đầu': 'Choose start time',
    'Thời lượng': 'Duration',
    'Hình thức & địa điểm': 'Format & location',
    'Địa điểm': 'Location',
    'Link phòng học': 'Meeting link',
    'Nhập địa điểm hoặc link học trực tuyến.':
        'Enter a location or online meeting link.',
    'Ghi chú cho buổi học': 'Session notes',
    'Ví dụ: mang laptop, chuẩn bị file thiết kế, học phần 1 về Java...':
        'E.g. bring a laptop, prepare design files, cover Java part 1...',
    'Lưu lịch học': 'Save schedule',
    'Xác nhận đổi lịch': 'Confirm reschedule',
    'Chọn thời gian sau ít nhất 15 phút nữa nhé.':
        'Pick a time at least 15 minutes from now.',
    'Bạn đã có một buổi học khác trùng khung giờ này.':
        'You already have another session at this time.',
    'Đổi lịch sẽ gửi thông báo mới cho đối phương (demo). ':
        'Rescheduling notifies your partner (demo). ',
    'Lịch cũ vẫn được lưu trong lịch sử đổi lịch.':
        'The old time is kept in reschedule history.',
    'Lịch học sẽ xuất hiện trong tab Lịch hẹn của cả hai sinh viên.':
        "The session appears in both students' Schedule tabs.",
    'Thư viện tầng 2 · Phòng học nhóm 4': 'Library, 2nd floor · Group room 4',
    'Thư viện tầng 3 · Bàn 12': 'Library, 3rd floor · Table 12',
    'Căng tin A · Khu ngoài trời': 'Canteen A · Outdoor area',
    'Phòng học B2-201': 'Room B2-201',
    'Thư viện tầng 3': 'Library, 3rd floor',

    // ------------------------------------------------------------ chi tiết hồ sơ
    'Hồ sơ sinh viên': 'Student profile',
    'Giới thiệu': 'About',
    'Vì sao phù hợp?': 'Why you match',
    'Đánh giá gần đây': 'Recent reviews',
    'Gửi lời mời kết nối': 'Send connection request',
    'Họ có thể dạy bạn': 'They can teach you',
    'Bạn có thể dạy họ': 'You can teach them',
    'Chưa có kỹ năng nào': 'No skills yet',
    'Chưa có kỹ năng trùng với mục tiêu của bạn':
        'No skills matching your goals',
    'Chưa có đánh giá chi tiết. Một số đánh giá được ẩn trong bản demo.':
        'No detailed reviews yet. Some are hidden in the demo.',
    'Sinh viên này chưa cập nhật phần giới thiệu.':
        "This student hasn't added a bio.",
    'Đối phương chưa cần kỹ năng bạn đang có':
        "They don't need your current skills",
    'Đối phương có 48 giờ để chấp nhận, từ chối hoặc để lời mời hết hạn.':
        'They have 48 hours to accept, decline or let it expire.',
    'Chào bạn! Mình đang tìm người học cùng để tiến bộ nhanh hơn. Bạn thấy thế nào?':
        "Hi! I'm looking for a study partner to improve faster. How about you?",
    'Chào bạn, mình thấy chúng ta có thể trao đổi kỹ năng. Bạn có rảnh buổi chiều thứ 5 không?':
        "Hi, I think we could swap skills. Are you free Thursday afternoon?",
    'Mình muốn học kỹ năng của bạn và có thể dạy lại kỹ năng bạn đang cần. Cùng thử một buổi nhé?':
        "I'd like to learn your skill and can teach one you need. Shall we try a session?",
    'Viết lời nhắn ngắn: bạn muốn học gì, có thể dạy lại gì và thời gian rảnh...':
        'Write a short note: what you want to learn, what you can teach, and your availability...',

    // ---------------------------------------------------------------- đánh giá
    'Đánh giá buổi học': 'Rate this session',
    '2 chiều': 'Two-way',
    'Điều gì làm buổi học tốt?': 'What made it great?',
    'Chia sẻ cụ thể điều bạn thích hoặc cần cải thiện...':
        'Share what you liked or what could improve...',
    'Gửi đánh giá': 'Submit review',
    'Cảm ơn bạn đã đánh giá!': 'Thanks for your review!',
    'Đánh giá hai chiều: sau khi gửi, bạn cũng sẽ nhận được ':
        "Two-way reviews: after sending, you'll also receive ",
    'đánh giá từ đối phương.': 'a review from your partner.',
    'Tuyệt vời': 'Excellent',
    'Tốt': 'Good',
    'Bình thường': 'Okay',
    'Cần cải thiện': 'Needs improvement',
    'Chưa hài lòng': 'Unsatisfied',
    'Chạm để chọn số sao': 'Tap to rate',
    'Đúng giờ': 'On time',
    'Giải thích dễ hiểu': 'Explains clearly',
    'Thân thiện': 'Friendly',
    'Chuẩn bị chu đáo': 'Well prepared',
    'Kiên nhẫn': 'Patient',
    'Truyền cảm hứng': 'Inspiring',
    'Cần đúng giờ hơn': 'Needs better punctuality',
    'Chưa chuẩn bị kỹ': 'Not well prepared',
    'Cần nói chậm hơn': 'Needs to speak slower',

    // -------------------------------------------------------------- ghép cặp
    'Rất phù hợp': 'Great match',
    'Phù hợp': 'Good match',
    'Có tiềm năng': 'Potential match',
    'Gợi ý mở rộng': 'Wider suggestion',
    'Cùng quan tâm đến kỹ năng trong lớp': 'Shared interest in class skills',
    'phù hợp': 'match',

    // -------------------------------------------------------------- hộp thoại
    'Đã ghép đôi!': "It's a match!",
    'Chọn lịch ngay': 'Pick a schedule',
    'Để sau': 'Later',
    'Bạn có thể chọn lịch học ngay bây giờ.':
        'You can pick a schedule right now.',
    'Đây là phản hồi mô phỏng cho buổi demo. ':
        'This is a simulated response for the demo. ',
    'Từ chối lời mời?': 'Decline this request?',
    'Giữ lại': 'Keep',
    'Bạn có thể gửi lời mời mới sau.': 'You can send a new request later.',
    'Huỷ buổi trao đổi?': 'Cancel this swap?',
    'Giữ lịch': 'Keep session',
    'Xác nhận huỷ': 'Confirm cancel',
    'Lý do huỷ': 'Cancellation reason',
    'Ví dụ: bận lịch thi giữa kỳ': 'E.g. midterm exam',
    'Bận lịch cá nhân': 'Personal schedule conflict',
    'Đối phương sẽ nhận được thông báo huỷ kèm lý do. ':
        'Your partner will be notified with the reason. ',
    'Đã huỷ buổi trao đổi.': 'Swap cancelled.',
    'Kết thúc buổi học?': 'End this session?',
    'Chưa kết thúc': 'Not yet',
    'Sau đó cả hai có thể đánh giá nhau (demo).':
        'Both of you can then review each other (demo).',
    'Đánh giá của bạn đã được ghi lại.': 'Your review has been saved.',
    'Đã lưu lịch học và thông báo cho đối phương (demo).':
        'Schedule saved and partner notified (demo).',
    'Bạn vẫn có thể gửi lời mời mới sau này.':
        'You can still send a new request later.',
    'Bạn có thể gửi lời mời mới sau': 'You can send a new request later',

    // --------------------------------------------------------------- cài đặt
    'Ngôn ngữ': 'Language',
    'Giao diện': 'Appearance',
    'Sáng': 'Light',
    'Tối': 'Dark',
    'Tiếng Việt': 'Vietnamese',
    'English': 'English',
    'Chế độ giao diện': 'Theme',
    'Thông tin nhóm': 'Development team',
    'Nhóm 12': 'Group 12',
    'Nhóm phát triển': 'Development team',
    '4 thành viên · Flutter': '4 members · Flutter',
    'Phiên bản': 'Version',
    'Mã nguồn': 'Source code',
    'Đồ án môn Lập trình thiết bị di động':
        'Mobile Programming course project',
    'Trường Đại học': 'University',
    'Thành viên': 'Members',
    'Vai trò': 'Role',
    'Đóng góp': 'Contribution',
    'Nhóm trưởng': 'Team lead',
    'Thành viên nhóm': 'Team member',
    'Kiến trúc, state, matching, lời mời, lịch hẹn, Git/README':
        'Architecture, state, matching, requests, scheduling, Git/README',
    'Hồ sơ, onboarding, chi tiết, đánh giá, dữ liệu mẫu':
        'Profile, onboarding, details, reviews, sample data',
    'Báo cáo Word & PowerPoint': 'Word report & PowerPoint',
    'Khám phá, swipe card': 'Discover, swipe cards',
    'Giao diện sáng': 'Light mode',
    'Giao diện tối': 'Dark mode',
    'Áp dụng ngay cho toàn bộ ứng dụng.':
        'Applied across the whole app instantly.',
    'Chọn ngôn ngữ hiển thị của ứng dụng.':
        'Choose the app display language.',
    'Thông tin nhóm phát triển và kênh mã nguồn.':
        'Development team and source repository.',
    'Dữ liệu trong app là giả lập, không có backend.':
        'All data is simulated; there is no backend.',
    'Xem thông tin nhóm': 'View team info',
    'Đội ngũ phát triển': 'Development team',
    'Dự án': 'Project',
    'Môn học': 'Course',
    'Giảng viên hướng dẫn': 'Lecturer',
    'Thông tin dự án': 'Project info',
    'Mô tả': 'Description',
    'Ứng dụng ghép cặp và hẹn lịch trao đổi kỹ năng giữa sinh viên trong cùng trường.':
        'A skill-swap matching and scheduling app for students on the same campus.',
    'Mã nguồn mở trên GitHub': 'Open source on GitHub',

    // --------------------------------------------------- bổ sung sau khi rà soát
    '  ·  Bạn dạy họ ': '  ·  You teach them ',
    'Họ dạy bạn ': 'They teach you ',
    'Chào buổi sáng': 'Good morning',
    'Chào buổi trưa': 'Good afternoon',
    'Chào buổi chiều': 'Good afternoon',
    'Chào buổi tối': 'Good evening',
    'Chọn kỹ năng bạn muốn trao đổi. App sẽ ưu tiên gợi ý người có thể dạy đúng những kỹ năng này.':
        'Pick skills you want to swap. We prioritise people who can teach exactly these.',
    'Chọn lịch': 'Pick a schedule',
    'Chọn những kỹ năng bạn tự tin chia sẻ cho bạn học. Không cần là chuyên gia, chỉ cần hơn người cần học một chút!':
        "Pick skills you're confident teaching. No need to be an expert — just a step ahead of your learner!",
    'Dịu mắt khi học buổi tối': 'Easy on the eyes at night',
    'Dữ liệu': 'Data',
    'Dữ liệu demo đã bao gồm đủ các nhánh: chờ phản hồi, đã ghép đôi, đã đặt lịch, hoàn thành, bị từ chối, hết hạn và đã huỷ. Dùng các nút bên dưới để thuyết trình.':
        'Demo data covers every branch: pending, matched, scheduled, completed, declined, expired and cancelled. Use the buttons below for your presentation.',
    'Giả lập, không có backend': 'Simulated, no backend',
    'Hôm nay': 'Today',
    'Hôm qua': 'Yesterday',
    'Khi có bạn học muốn trao đổi kỹ năng, lời mời sẽ xuất hiện ở đây. Bạn có 48 giờ để phản hồi trước khi lời mời hết hạn.':
        'Requests from study partners will appear here. You have 48 hours to respond before they expire.',
    'Khi lời mời được chấp nhận, bạn có thể chọn thời gian, địa điểm và buổi học sẽ xuất hiện trong lịch.':
        'Once a request is accepted, choose a time and place and the session appears on your schedule.',
    'Không tìm thấy AppScope trong widget tree':
        'AppScope not found in the widget tree',
    'Lời mời nhận được có hiệu lực 48 giờ. Bạn có thể chấp nhận, từ chối hoặc để hết hạn — mọi nhánh đều được lưu vào Lịch sử.':
        'Incoming requests are valid for 48 hours. You can accept, decline or let them expire — every branch is saved in History.',
    'Lời mời đã gửi sẽ tự động hết hạn sau 48 giờ nếu chưa có phản hồi. Bạn có thể thu hồi bất cứ lúc nào.':
        'Sent requests expire automatically after 48 hours without a response. You can withdraw anytime.',
    'Muốn học': 'Wants to learn',
    'Mẹo: hồ sơ càng cụ thể càng dễ được ghép cặp. Ví dụ “mình biết Flutter, muốn học Java”.':
        'Tip: the more specific your profile, the better your matches. E.g. "I know Flutter, I want to learn Java".',
    'Ngày kia': 'In 2 days',
    'Ngày mai': 'Tomorrow',
    'Nhóm 12 · 4 thành viên · Flutter': 'Group 12 · 4 members · Flutter',
    'Nền sáng, dễ đọc ban ngày': 'Light background, easy by day',
    'Phiên bản 1.0.0': 'Version 1.0.0',
    'Sao chép liên kết': 'Copy link',
    'SkillSwap Campus · Flutter · 4 thành viên':
        'SkillSwap Campus · Flutter · 4 members',
    'Toàn bộ lời mời, lịch học và đánh giá sẽ trở về trạng thái ban đầu. Hồ sơ của bạn vẫn được giữ nguyên.':
        'All requests, sessions and reviews return to their initial state. Your profile stays unchanged.',
    'Tuỳ chỉnh ngôn ngữ, giao diện và xem thông tin nhóm.':
        'Customise language, theme and view team info.',
    'Tìm kỹ năng...': 'Search skills...',
    'Tỷ lệ đóng góp theo thống nhất của nhóm.':
        'Contribution shares agreed by the team.',
    'Vừa xong': 'Just now',
    'trong 2 giờ': 'within 2 hours',
    'Đang chờ bạn đánh giá': 'Your review is due',
    'Đánh giá hai chiều: sau khi gửi, bạn cũng sẽ nhận được đánh giá từ đối phương.':
        "Two-way reviews: after sending, you'll also receive a review from your partner.",
    'Đây là phản hồi mô phỏng cho buổi demo. Bạn có thể chọn lịch học ngay bây giờ.':
        'This is a simulated response for the demo. You can pick a schedule right now.',
    'Đã hết hạn': 'Expired',
    'Đã sao chép liên kết mã nguồn.': 'Source link copied.',
    'Đối phương sẽ nhận được thông báo huỷ kèm lý do. Bạn có thể gửi lời mời mới sau.':
        'Your partner will be notified with the reason. You can send a new request later.',
    'Đổi lịch sẽ gửi thông báo mới cho đối phương (demo). Lịch cũ vẫn được lưu trong lịch sử đổi lịch.':
        'Rescheduling notifies your partner (demo). The old time is kept in reschedule history.',

    // --------------------------------------------------- câu có tham số
    'Đã bỏ qua {name}': 'Skipped {name}',
    'Đã gửi lời mời tới {name} · chờ phản hồi trong 48 giờ':
        'Request sent to {name} · awaiting response for 48 hours',
    '{count} hồ sơ phù hợp': '{count} matching profiles',
    '{rating} · {count} đánh giá': '{rating} · {count} reviews',
    'Dạy {count}': 'Teaches {count}',
    'Học {count}': 'Learning {count}',
    'Tôi dạy ({count})': 'I teach ({count})',
    'Tôi muốn học ({count})': 'I want to learn ({count})',
    'Đánh giá {time}': 'Reviewed {time}',
    'Đã chọn {count} kỹ năng': '{count} skills selected',
    'Nhận được ({count})': 'Incoming ({count})',
    'Đã gửi ({count})': 'Sent ({count})',
    'Bạn → {name}': 'You → {name}',
    'Đã gửi {time} · ': 'Sent {time} · ',
    'Hoàn thành {time}': 'Completed {time}',
    'Đã từ chối {time}': 'Declined {time}',
    'Hết hạn {time}': 'Expired {time}',
    'Lý do: {reason}': 'Reason: {reason}',
    '{count} chờ đánh giá': '{count} awaiting review',
    'Bạn có {count} buổi trao đổi sắp tới':
        'You have {count} upcoming sessions',
    'Tháng {month}': 'Month {month}',
    'Đã đổi {count} lần': 'Rescheduled {count} times',
    'Ghi chú: {note}': 'Note: {note}',
    '{name} đánh giá bạn': '{name} reviewed you',
    'Đổi lịch lần {count}': 'Reschedule #{count}',
    'Kết thúc {time}': 'Ends {time}',
    'Bạn đã có lời mời với {name}.': 'You already have a request with {name}.',
    'Đã gửi lời mời tới {name}.': 'Request sent to {name}.',
    '({count} đánh giá)': '({count} reviews)',
    'Phản hồi {time}': 'Responds {time}',
    'Đang chờ {name} phản hồi': 'Waiting for {name} to respond',
    'Đã có lịch học với {name}': 'Session scheduled with {name}',
    '{count} đánh giá chi tiết': '{count} detailed reviews',
    'Tới {name} · hết hạn sau 48 giờ': 'To {name} · expires in 48 hours',
    'Gợi ý {count}': 'Suggestion {count}',
    'Trao đổi hai chiều: {a} ↔ {b}': 'Two-way swap: {a} ↔ {b}',
    '{name} có thể dạy bạn {skill}': '{name} can teach you {skill}',
    '{name} muốn học {skill} từ bạn': '{name} wants to learn {skill} from you',
    'Chào {name}, mình thấy chúng ta có thể trao đổi kỹ năng. Mình có thể dạy {teach}, học lại {learn}. Bạn thấy thế nào?':
        "Hi {name}, I think we could swap skills. I can teach {teach} and learn {learn}. How does that sound?",
    'Đã huỷ bởi {name}': 'Cancelled by {name}',
    'Buổi trao đổi rất chất lượng! {name} giải thích {skill} rõ ràng, đúng giờ và chuẩn bị tốt.':
        'Great swap! {name} explained {skill} clearly, was on time and well prepared.',
    'Buổi học ổn, {name} giải thích dễ hiểu. Lần sau mình muốn có thêm bài tập thực hành.':
        'Good session. {name} explained things clearly. Next time I would like more hands-on exercises.',
    'Bạn và {name} đã đồng ý trao đổi kỹ năng. ':
        'You and {name} agreed to swap skills. ',
    '{name} đã đồng ý!': '{name} accepted!',
    'Lời mời của {name} sẽ chuyển vào mục Lịch sử. ':
        "{name}'s request moves to History. ",
    'Đã từ chối lời mời của {name}.': "Declined {name}'s request.",
    'Xác nhận buổi học với {name} đã diễn ra. ':
        'Confirm that the session with {name} took place. ',
    'Buổi học đã hoàn thành · {name} cũng đã gửi đánh giá.':
        '{name} has also submitted a review. ',
    'Đổi lịch {count} lần': 'Rescheduled {count} times',
    'Lý do huỷ: {reason}': 'Cancellation reason: {reason}',
    'Bạn đánh giá {name}': 'Your review of {name}',
    '{time} · hết hạn sau 48 giờ': '{time} · expires in 48 hours',
    'Lời mời hết hạn {time}': 'Request expired {time}',
    'Với {name}': 'With {name}',
    'Bạn đã chấm {rating}/5 sao cho {name}.': 'You rated {name} {rating}/5.',
    '{name} đã đánh giá bạn': '{name} reviewed you',
    '{count} đã chọn': '{count} selected',
    'Lưu {count} kỹ năng': 'Save {count} skills',
    'Đã gửi {time} · {left}': 'Sent {time} · {left}',
    'Bạn và {name} đã đồng ý trao đổi kỹ năng. Hãy chọn thời gian để buổi học diễn ra thuận lợi nhé.':
        'You and {name} agreed to swap skills. Pick a time so the session goes smoothly.',
    'Lời mời của {name} sẽ chuyển vào mục Lịch sử. Bạn vẫn có thể gửi lời mời mới sau này.':
        "{name}'s request moves to History. You can still send a new request later.",
    'Xác nhận buổi học với {name} đã diễn ra. Sau đó cả hai có thể đánh giá nhau (demo).':
        'Confirm that the session with {name} took place. Both of you can then review each other (demo).',
    'kỹ năng của mình': 'my skills',
    'điều bạn đang có': 'what you already know',
    'buổi học': 'the session',
    'sinh viên': 'student',
    'Ngôn ngữ mặc định của ứng dụng': 'Default app language',
  };
}

/// Tiện dụng: `tr('Khám phá')` ở bất kỳ đâu.
String tr(String vi) => AppText.t(vi);

/// Tiện dụng cho câu có tham số: `trArgs('Chào {name}', {'name': name})`.
String trArgs(String vi, Map<String, String> values) => AppText.a(vi, values);
