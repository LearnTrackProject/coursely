## API Reference - Course Management System

### Instructor Cubit Methods

#### `addCourse()`

```dart
Future<void> addCourse({
  required String title,
  required double price,
  required String category,
  String? imageUrl,
  List<String>? videoLinks,
})
```

**الوصف**: إضافة كورس جديد مع روابط الفيديو
**المعاملات**:

- `title`: اسم الكورس
- `price`: سعر الكورس
- `category`: فئة الكورس
- `imageUrl`: رابط صورة الكورس (اختياري)
- `videoLinks`: قائمة روابط الفيديو (اختياري)

**الإرجاع**: Future<void>
**الأخطاء**: يتم إصدار state بـ error إذا فشل

---

### Course Page Methods

#### `_loadEnrolledCourses()`

```dart
Future<void> _loadEnrolledCourses()
```

**الوصف**: تحميل قائمة الكورسات المسجل فيها الطالب من Firestore
**المعاملات**: لا توجد
**الإرجاع**: Future<void>

---

#### `_enrollCourse()`

```dart
Future<void> _enrollCourse(String courseId)
```

**الوصف**: تسجيل الطالب في كورس جديد
**المعاملات**:

- `courseId`: معرّف الكورس المراد التسجيل فيه

**الإرجاع**: Future<void>
**الآثار**:

- تحديث Firestore بإضافة courseId إلى enrolledCourses
- عرض SnackBar بتأكيد التسجيل
- تحديث UI محلياً

---

### Course Video Player

#### `_fetchCourseWithVideos()`

```dart
Future<Map<String, dynamic>> _fetchCourseWithVideos()
```

**الوصف**: جلب بيانات الكورس مع روابط الفيديو من Firestore
**المعاملات**: لا توجد
**الإرجاع**: `Future<Map<String, dynamic>>` يحتوي على بيانات الكورس

---

## Firestore Queries

### 1. جلب كورسات المدرس

```dart
await firestore
  .collection('instructor')
  .doc(uid)
  .get()
```

**النتيجة**: مستند يحتوي على قائمة الكورسات

### 2. جلب بيانات كورس محدد

```dart
await firestore
  .collection('courses')
  .doc(courseId)
  .get()
```

**النتيجة**: بيانات الكورس مع روابط الفيديو

### 3. تحديث الكورسات المسجلة

```dart
await firestore
  .collection('student')
  .doc(uid)
  .update({
    'enrolledCourses': FieldValue.arrayUnion([courseId]),
  })
```

**النتيجة**: إضافة courseId إلى مصفوفة enrolledCourses

---

## UI Components

### CourseWidget (Enhanced)

عرض بطاقة الكورس مع:

- الصورة
- الاسم
- السعر
- حالة التسجيل (Enrolled / Enroll Now)
- تأثير الحجب عند عدم التسجيل

### CourseVideoPlayer

عرض كامل للفيديوهات مع:

- محرّك الفيديو (placeholder)
- قائمة الدروس
- اختيار الدرس الحالي
- عرض رابط الفيديو

---

## State Management

### InstructorState

```dart
class InstructorState {
  final String? name;
  final String? email;
  final String? bio;
  final List<Course> courses;
  final bool loading;
  final bool updating;
  final String? error;
}
```

### CoursesState

```dart
class CoursesState {
  final CoursesStatus status;
  final List<Course> courses;
  final String? errorMessage;
}
```

---

## Error Handling

### try-catch في `_loadEnrolledCourses()`

```dart
try {
  // جلب البيانات
} catch (e) {
  print('Error loading enrolled courses: $e');
}
```

### SnackBar للأخطاء

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Error: ...')),
);
```

---

## Data Models

### Instructor Course

```dart
{
  'courseName': String,
  'videoLinks': List<String>
}
```

### Course

```dart
{
  'id': String,
  'title': String,
  'price': double,
  'category': String,
  'instructorId': String,
  'imageUrl': String,
  'videoLinks': List<String>,
  'lessons': List,
  'createdAt': Timestamp
}
```

### Student Enrolled Courses

```dart
{
  'enrolledCourses': List<String> // قائمة معرّفات الكورسات
}
```

---

## Performance Considerations

1. **Lazy Loading**: الكورسات تُحمّل عند فتح الصفحة فقط
2. **Caching**: الحالة المحلية تُحتفظ بها في \_CoursePageState
3. **Efficient Queries**: استخدام doc queries بدلاً من collection queries
4. **UI Optimization**: استخدام `setState()` بشكل انتقائي

---

## Testing Checklist

- [ ] المدرس يمكنه إضافة كورس مع روابط الفيديو
- [ ] تظهر الكورسات في قائمة الطالب
- [ ] البحث يعمل على اسم الكورس
- [ ] الطالب يمكنه التسجيل في كورس
- [ ] الكورسات غير المسجلة تظهر مع overlay داكن
- [ ] بعد التسجيل، يمكن فتح الكورس ومشاهدة الفيديوهات
- [ ] اختيار فيديو من القائمة يحدّث الفيديو الحالي
- [ ] Tab "Enrolled" يعرض فقط الكورسات المسجلة

---

**آخر تحديث**: 14 نوفمبر 2025
