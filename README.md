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

---

## 9. Phân công nhóm & nghiệm thu

### 9.1. Thành viên và tỉ lệ đóng góp

| Thành viên | Vai trò | Mảng phụ trách chính | Trạng thái | Tỉ lệ đóng góp |
|---|---|---|---|---:|
| Hoàng Quốc Khánh | Nhóm trưởng | Kiến trúc, state, matching, lời mời, lịch hẹn, tích hợp, Git/README | Hoàn thành | 40% |
| Đặng Tuấn Ngọc | Thành viên | Hồ sơ, onboarding, chi tiết, đánh giá, dữ liệu mẫu | Hoàn thành | 35% |
| Đinh Trung Kiên | Thành viên | Báo cáo Word & PowerPoint thuyết trình | Chờ bàn giao | 15% |
| Lê Quốc Anh | Thành viên | Khám phá, swipe card | Hoàn thành | 10% |
| **Tổng** | | | | **100%** |

> Tỉ lệ đóng góp dựa trên khối lượng và độ phức tạp thực tế của từng mảng. Đinh Trung Kiên không phụ trách code; phụ trách tài liệu và thuyết trình.

> Các nhân vật trong dữ liệu mẫu (Ngọc Anh, Minh Thư, Phương Thảo…) là hồ sơ giả lập phục vụ demo, không phải thành viên nhóm.

### 9.2. Chi tiết công việc

#### Hoàng Quốc Khánh — Nhóm trưởng — 40%

- **Phụ trách:** phân tích yêu cầu, chốt phạm vi; thiết kế kiến trúc và state machine; matching; màn lời mời; màn lịch hẹn và form đặt lịch; tích hợp toàn bộ sản phẩm; quản lý Git/GitHub; viết README và kịch bản demo.
- **Đầu việc:** mô hình `Skill`/`User`/`SwapRequest`/`SwapSession`/`Review`; `AppState` + `AppScope`; matching hai chiều; vòng đời accept/reject/expire/reschedule/cancel/complete/review; 3 tab *Nhận được / Đã gửi / Lịch sử*; màn *Lịch hẹn* (2 tab); form đặt lịch (ngày, giờ, thời lượng, hình thức, địa điểm, ghi chú); validate quá khứ 15 phút và trùng lịch; `HomeShell` + timer hết hạn; widget điểm phù hợp; hộp thoại dùng chung; review chéo và sửa lỗi cuối.
- **File chính:** `lib/models/*`, `lib/state/*`, `lib/services/matching_service.dart`, `lib/screens/home_shell.dart`, `requests_screen.dart`, `schedule_screen.dart`, `schedule_session_screen.dart`, `lib/widgets/status_badge.dart`, `match_score_ring.dart`, `match_timeline.dart`, `match_detail_sheet.dart`, `lib/utils/actions.dart`, `lib/app.dart`, `README.md`, `test/app_state_test.dart`, `test/matching_service_test.dart`.
- **Nghiệm thu:** 7 trạng thái lời mời hoạt động đúng; 3 tab lời mời; cảnh báo trùng giờ; `flutter analyze` sạch; 14 test pass; demo đủ 6 nhánh; repo public có hướng dẫn chạy.

#### Đặng Tuấn Ngọc — 35%

- **Phụ trách:** luồng hồ sơ, onboarding, chi tiết hồ sơ, đánh giá và dữ liệu mẫu.
- **Đầu việc:** đăng nhập demo; tạo hồ sơ 3 bước (thông tin → kỹ năng dạy → kỹ năng học); validate và nút *Dùng mẫu*; hồ sơ cá nhân, thống kê, đánh giá nhận được; chỉnh sửa hồ sơ; multi-select chips; avatar; 18 hồ sơ + 19 ảnh đại diện; trang chi tiết hồ sơ (header gradient, `TabBar` kỹ năng/đánh giá, sheet gửi lời mời); `RatingBar`; sheet đánh giá hai chiều.
- **File chính:** `lib/screens/login_screen.dart`, `profile_setup_screen.dart`, `profile_screen.dart`, `edit_profile_screen.dart`, `user_detail_screen.dart`, `lib/widgets/skill_picker_sheet.dart`, `skill_chip.dart`, `user_avatar.dart`, `rating_bar.dart`, `review_sheet.dart`, `lib/services/sample_data.dart`, `assets/avatars/`.
- **Nghiệm thu:** tạo hồ sơ mới và *Dùng mẫu* đúng nhân vật Minh Thư; chọn/bỏ chọn nhiều kỹ năng; sửa hồ sơ; chi tiết có 2 tab; chấm 1–5 sao, chọn nhãn, gửi nhận xét; hiển thị đánh giá của cả hai bên; đủ 18 hồ sơ.

#### Đinh Trung Kiên — 15%

- **Phụ trách:** báo cáo Word và PowerPoint thuyết trình; không phụ trách code.
- **Đầu việc:** tổng hợp nội dung từ README và kết quả demo; viết báo cáo đủ mục 1–9; chụp ảnh minh họa các màn hình; làm slide 10–12 trang; soạn kịch bản thuyết trình 3–5 phút; rà soát chính tả, định dạng và thống nhất số liệu với nhóm.
- **File bàn giao:** báo cáo Word + slide PowerPoint (file nộp kèm).
- **Nghiệm thu:** báo cáo đủ mục, có ảnh minh họa; slide bám đúng kịch bản demo; thuyết trình đúng thời lượng; số liệu khớp với app.

#### Lê Quốc Anh — 10%

- **Phụ trách:** khám phá và swipe card.
- **Đầu việc:** tìm kiếm/lọc/sắp xếp; bộ thẻ swipe `Dismissible` (trái bỏ qua, phải gửi lời mời); giao diện thẻ ứng viên; trạng thái rỗng khi hết người phù hợp; callback mở chi tiết hồ sơ (phối hợp với Đặng Tuấn Ngọc).
- **File chính:** `lib/screens/discover_screen.dart`, `lib/widgets/swap_candidate_card.dart`, `lib/widgets/empty_state.dart`.
- **Nghiệm thu:** tìm kiếm/lọc đúng; swipe hai hướng; không lỗi key khi thẻ đổi; mở được chi tiết; có trạng thái rỗng.

### 9.3. Tiêu chí nghiệm thu chung

- [x] `flutter analyze` không có issue.
- [x] `flutter test` pass 14/14.
- [x] Chạy được bằng `flutter run -d chrome` và `flutter run -d web-server`.
- [x] Demo đủ 6 nhánh: từ chối, hết hạn, đổi lịch, huỷ, hoàn thành, đánh giá hai chiều.
- [x] Repo public, không commit `build/`, `.dart_tool/`, `.idea/`.
- [x] README có phạm vi, tính năng, widget đặc trưng, kịch bản demo, cách chạy và kiểm thử.

### 9.4. Kết quả nghiệm thu

| Mảng | Người thực hiện | Người nghiệm thu | Kết quả |
|---|---|---|---|
| Kiến trúc, matching, lời mời & lịch hẹn | Hoàng Quốc Khánh | Tập thể nhóm | Đạt |
| Hồ sơ, chi tiết & đánh giá | Đặng Tuấn Ngọc | Hoàng Quốc Khánh | Đạt |
| Báo cáo Word & PowerPoint | Đinh Trung Kiên | Hoàng Quốc Khánh | Chờ bàn giao |
| Khám phá & swipe card | Lê Quốc Anh | Hoàng Quốc Khánh | Đạt |

> Nhóm trưởng nghiệm thu ngày 14/11/2026. Các thành viên đối chiếu chéo phần của nhau trước khi merge.

### 9.5. Kiểm thử & QA

**Phân công kiểm thử**

| Thành viên | Vai trò QA | Nội dung chính |
|---|---|---|
| Hoàng Quốc Khánh | Chủ trì | Chạy `flutter analyze` + `flutter test`; test vòng đời, matching, đặt/đổi/huỷ lịch; regression trước khi push |
| Đặng Tuấn Ngọc | Test chéo | Onboarding, hồ sơ, sửa kỹ năng, đánh giá; thử text scale và màn hình nhỏ |
| Lê Quốc Anh | Test chéo | Khám phá: tìm kiếm, lọc, swipe hai hướng, lỗi key, trạng thái rỗng |
| Đinh Trung Kiên | Đối chiếu tài liệu | Chạy kịch bản demo để kiểm tra ảnh minh họa, số liệu và nội dung Word/PowerPoint |

**Đã kiểm tra**

- [x] `flutter analyze`: không issue.
- [x] `flutter test`: 14/14 pass.
- [x] Sáu nhánh vòng đời: từ chối, hết hạn, đổi lịch, huỷ, hoàn thành, đánh giá hai chiều.
- [x] Đặt lịch quá khứ và trùng giờ bị chặn.
- [x] Swipe hai hướng, tìm kiếm/lọc, mở chi tiết, gửi đánh giá.
- [x] Chạy trên Chrome desktop, không có lỗi console.

**Cần kiểm tra trước khi nộp**

- [ ] Chạy trên Android/iOS thật.
- [ ] Màn hình 360×800 và text scale 2.0.
- [ ] Timer hết hạn khi app xuống background rồi quay lại.
- [ ] Đối chiếu số liệu Word/PowerPoint với app.

> Nguyên tắc: người viết code không tự test một mình; mỗi màn hình phải được một thành viên khác test chéo.
