# SkillSwap Campus

Ứng dụng Flutter demo cho bài tập môn học: **ghép cặp và hẹn lịch trao đổi kỹ năng giữa sinh viên trong cùng trường**.

Mỗi sinh viên vừa là người dạy, vừa là người học. Ứng dụng tìm những người có kỹ năng mình cần và đang cần kỹ năng mình có, gửi lời mời, thống nhất lịch học, hoàn thành buổi học và đánh giá hai chiều.

> Toàn bộ dữ liệu là dữ liệu giả lập trong bộ nhớ, phục vụ mục đích demo. Không có backend, không có tài khoản thật.

---

## 1. Phạm vi

Ứng dụng tập trung đúng vào luồng **ghép cặp → hẹn lịch → đánh giá**, không phải mạng xã hội:

- Không có bảng tin, follow, nhắn tin tự do.
- Mọi tương tác đều xoay quanh một `SwapRequest` (lời mời trao đổi) và `SwapSession` (buổi học).
- Sau buổi học, hai bên đánh giá nhau để tính điểm uy tín.

---

## 2. Tính năng chính

### Hồ sơ cá nhân
- Hồ sơ sinh viên: ảnh đại diện, họ tên, chuyên ngành, khóa, bio, thời gian phản hồi.
- Danh sách **kỹ năng có thể dạy** và **kỹ năng muốn học**.
- Chỉnh sửa hồ sơ, thêm/bớt kỹ năng.
- Thống kê: số buổi hoàn thành, số đối tác, điểm đánh giá trung bình, số đánh giá đang chờ.
- Xem các đánh giá đã nhận.

### Khám phá người phù hợp
- Bộ lọc theo kỹ năng, chuyên ngành, hình thức học.
- Tính điểm phù hợp dựa trên:
  - kỹ năng họ dạy trùng với kỹ năng mình muốn học,
  - kỹ năng mình dạy trùng với kỹ năng họ muốn học (ghép hai chiều),
  - điểm uy tín và số đánh giá.
- **Thẻ swipe kiểu Tinder** để bỏ qua hoặc mở hồ sơ.
- Xem chi tiết: điểm phù hợp, lý do ghép cặp, kỹ năng, đánh giá, gửi lời mời kèm lời nhắn.

### Lời mời kết nối
- 3 tab: **Nhận được**, **Đã gửi**, **Lịch sử**.
- Chấp nhận / từ chối lời mời.
- Lời mời tự động **hết hạn sau 48 giờ**.
- Hủy lời mời đã gửi.
- Trạng thái rõ ràng: chờ phản hồi, đã chấp nhận, đã đặt lịch, hoàn thành, bị từ chối, hết hạn, đã hủy.

### Lịch hẹn
- 2 tab: **Sắp diễn ra**, **Đã hoàn thành**.
- Đặt lịch: chọn ngày, giờ, thời lượng, hình thức online/offline, địa điểm, ghi chú.
- Kiểm tra trùng lịch trước khi xác nhận.
- Đổi lịch, hủy buổi học, đánh dấu hoàn thành.

### Đánh giá sau buổi học
- Đánh giá **hai chiều**: mình đánh giá đối phương và xem đánh giá đối phương dành cho mình.
- Chấm điểm sao, chọn nhãn nhận xét, viết cảm nhận.
- Điểm trung bình của mỗi người được cập nhật sau khi nhận đánh giá.

---

## 3. Widget đặc trưng theo yêu cầu môn học

| Yêu cầu | Vị trí triển khai |
|---|---|
| **Multi-select chips** | `profile_setup_screen.dart` (bước chọn kỹ năng), `widgets/skill_picker_sheet.dart`, `edit_profile_screen.dart` |
| **Swipe card** | `screens/discover_screen.dart` dùng `Dismissible` + xoay thẻ + hiệu ứng "Bỏ qua"/"Xem hồ sơ" |
| **TabBar** | `user_detail_screen.dart` (Kỹ năng / Đánh giá), `requests_screen.dart` (3 tab), `schedule_screen.dart` (2 tab), `profile_screen.dart` (2 tab) |
| **RatingBar** | `widgets/rating_bar.dart`, dùng trong `widgets/review_sheet.dart` và phần hiển thị đánh giá |

Ngoài ra còn có: `NavigationBar`, `InheritedNotifier`, `AnimatedBuilder`, `PageView`, `BottomSheet`, `showDatePicker`/`showTimePicker` có bản địa hóa tiếng Việt.

---

## 4. Kịch bản demo gợi ý (khoảng 3–5 phút)

1. **Đăng nhập demo** → chọn *Vào bằng tài khoản demo*. Tài khoản là **Ngọc Anh**, CNTT K18, dạy Flutter/HTML/Tiếng Anh, muốn học Java/UI-UX/Public Speaking.
2. **Khám phá**: mở tab *Khám phá*, thử bộ lọc và swipe vài thẻ (kéo sang phải để gửi lời mời, sang trái để bỏ qua). Mở hồ sơ một người để xem điểm phù hợp và lý do ghép cặp.
3. **Chấp nhận lời mời**: tab *Yêu cầu* → *Nhận được* → mở lời mời của **Khánh Linh** → *Chấp nhận*.
4. **Đặt lịch**: từ hộp thoại đã ghép đôi, chọn *Chọn lịch ngay*. Form đã gợi ý khung giờ trống gần nhất; chọn ngày/giờ, hình thức, địa điểm → *Lưu lịch học*. Thử chọn trùng giờ với buổi của Thảo Vy để thấy cảnh báo.
5. **Quản lý lịch**: tab *Lịch hẹn* → mở buổi với **Thảo Vy** để **đổi lịch** hoặc **hủy** (hủy sẽ hỏi lý do và chuyển vào Lịch sử).
6. **Hoàn thành & đánh giá**: tab *Đã xong* → buổi với **Phương Thảo** đang chờ mình đánh giá → *Đánh giá*, chấm sao, chọn nhãn và gửi. Hộp thoại cảm ơn hiển thị luôn đánh giá đối phương dành cho mình.
7. **Nhánh từ chối / hết hạn**: tab *Yêu cầu* → *Nhận được* → từ chối lời mời của **Hoàng Nam**; mở *Lịch sử* để xem lời mời bị từ chối, đã hủy và đã hết hạn (Yến Nhi).
8. **Hồ sơ**: tab *Hồ sơ* → xem thống kê, đánh giá đã nhận; thử *Chỉnh sửa hồ sơ* hoặc *Reset dữ liệu*.

> Mẹo: nút *Demo: đồng ý* ở tab *Đã gửi* mô phỏng đối phương chấp nhận lời mời, dùng khi muốn trình diễn nhanh mà không chờ 48 giờ.
> Khi tạo hồ sơ mới, nút *Dùng mẫu* điền sẵn một nhân vật khác (**Minh Thư**, K19, dạy Video Editing/Marketing/Photoshop) để bạn không phải gõ tay.

### Dữ liệu mẫu
- **18 hồ sơ sinh viên** (`assets/avatars/u01.png` … `u18.png`), đa dạng ngành: CNTT, thiết kế, ngôn ngữ, marketing, kinh tế, âm nhạc, tâm lý…
- **11 lời mời mẫu** phủ đủ các trạng thái: chờ phản hồi (nhận/ gửi), đã chấp nhận, đã đặt lịch (online + offline), hoàn thành (đã đánh giá / chờ đánh giá), bị từ chối, hết hạn, đã hủy.
- Một số nhân vật chính trong kịch bản demo:

| Mã | Nhân vật | Vai trò trong demo |
|---|---|---|
| `u16` | Khánh Linh | Lời mời đang chờ → chấp nhận → đặt lịch |
| `u03` | Thảo Vy | Buổi đã đặt lịch → đổi lịch / hủy |
| `u02` | Gia Huy | Buổi online đã đặt lịch |
| `u18` | Phương Thảo | Buổi đã hoàn thành, chờ mình đánh giá |
| `u01` | Minh Anh | Buổi đã hoàn thành, đã đánh giá hai chiều |
| `u11` | Hoàng Nam | Lời mời sắp hết hạn → từ chối / để hết hạn |
| `u14` | Yến Nhi | Lời mời đã hết hạn |
| `u17` | Nhật Minh | Lời mời đã hủy sau khi đặt lịch |

---

## 5. Cấu trúc thư mục

```
lib/
├── main.dart                 # entry point
├── app.dart                  # MaterialApp, locale tiếng Việt, theme
├── models/
│   ├── skill.dart            # Skill, danh mục kỹ năng
│   ├── user.dart             # User, kỹ năng dạy/học, uy tín
│   └── swap_request.dart     # SwapRequest, SwapSession, Review, enums
├── services/
│   ├── matching_service.dart # tính điểm & lý do ghép cặp
│   └── sample_data.dart      # 18 hồ sơ + 11 lời mời mẫu
├── state/
│   ├── app_state.dart        # ChangeNotifier: dữ liệu, vòng đời, đánh giá
│   └── app_scope.dart        # InheritedNotifier
├── screens/
│   ├── login_screen.dart
│   ├── profile_setup_screen.dart
│   ├── home_shell.dart       # 4 tab + badge + timer hết hạn
│   ├── discover_screen.dart
│   ├── user_detail_screen.dart
│   ├── requests_screen.dart
│   ├── schedule_screen.dart
│   ├── schedule_session_screen.dart
│   ├── profile_screen.dart
│   └── edit_profile_screen.dart
├── widgets/                  # avatar, chip, badge, rating, swipe card, sheet…
├── theme/app_theme.dart
└── utils/                    # formatters, action flows dùng chung

assets/avatars/               # 19 ảnh đại diện sinh (ảnh giả lập)
test/
├── app_state_test.dart       # vòng đời lời mời, hết hạn, đổi lịch, hủy, đánh giá
├── matching_service_test.dart
└── widget_test.dart
```

### Kiến trúc trạng thái
- `AppState extends ChangeNotifier` giữ toàn bộ dữ liệu demo và các chuyển trạng thái.
- `AppScope extends InheritedNotifier<AppState>` cung cấp state cho toàn cây widget, không cần package ngoài.
- Hết hạn lời mời được tính **lazy** qua `statusOf()` và được áp dụng thật khi timer/pull-to-refresh gọi `expireOverdueRequests()`.

---

## 6. Cách chạy

Yêu cầu: Flutter 3.35+ (dự án đang chạy ổn với Flutter 3.47 / Dart 3.13).

```bash
cd skillswap_campus
flutter pub get
flutter run
```

Chạy trên web:

```bash
flutter run -d chrome
# hoặc
flutter run -d web-server --web-port 8091
```

Build bản phát hành:

```bash
flutter build web
flutter build apk --release
```

---

## 7. Kiểm thử & phân tích

```bash
flutter analyze
flutter test
```

- `flutter analyze`: không có issue.
- `flutter test`: 14 test pass, bao gồm:
  - tính điểm và ghép cặp hai chiều,
  - gửi/chấp nhận/từ chối lời mời,
  - hết hạn sau 48 giờ,
  - đặt lịch, đổi lịch, hủy lịch,
  - hoàn thành buổi học và đánh giá hai chiều,
  - luồng đăng nhập demo ở mức widget.

---

## 8. Ghi chú triển khai

- Ảnh đại diện được sinh cục bộ và đóng gói trong `assets/avatars/`, ứng dụng không gọi mạng.
- Toàn bộ copy trong app là tiếng Việt; `flutter_localizations` bật locale `vi` cho date/time picker.
- Dữ liệu chỉ nằm trong bộ nhớ: khởi động lại app sẽ trở về dữ liệu demo ban đầu. Tab *Hồ sơ* có nút **Reset dữ liệu** (hộp thoại “Đặt lại dữ liệu demo?”).
- Các nút có nhãn *Demo* (ví dụ “Demo: đồng ý”, “Kết thúc”) dùng để trình diễn nhanh các nhánh vòng đời mà không cần chờ thời gian thật.
