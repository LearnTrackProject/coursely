## Testing Guide - Course Management System

### قبل البدء

تأكد من:

- ✅ Firebase مُعدّ بشكل صحيح
- ✅ Collections موجودة: `instructor`, `courses`, `student`
- ✅ المستخدمون مُسجّلين بنجاح

---

## Test Case 1: إضافة كورس من قِبل المدرس

### الخطوات:

1. سجّل دخولك كمدرس
2. اذهب إلى **Instructor Dashboard**
3. اضغط **"Add Course"**

### املأ البيانات التالية:

```
Course Title: Flutter Basics
Price: 99.99
Category: Programming
Image URL: https://example.com/flutter.jpg
```

### أضف روابط الفيديو:

```
Link 1: https://youtube.com/watch?v=dQw4w9WgXcQ
Link 2: https://youtube.com/watch?v=9bZkp7q19f0
Link 3: https://youtube.com/watch?v=jNQXAC9IVRw
```

### النتائج المتوقعة:

✅ الكورس يظهر في قائمة الكورسات
✅ في Firebase `courses` collection يكون لديك مستند جديد بـ videoLinks
✅ في `instructor` collection، يكون لديك مصفوفة courses بـ courseName و videoLinks

---

## Test Case 2: البحث عن الكورسات

### الخطوات:

1. سجّل دخولك كطالب
2. اذهب إلى **Courses Tab**
3. في مربع البحث، اكتب "Flutter"

### النتائج المتوقعة:

✅ الكورس "Flutter Basics" يظهر في النتائج
✅ الكورسات الأخرى تختفي
✅ البحث يعمل فوراً مع كل حرف

### اختبار البحث الفارغ:

```
اكتب اسم كورس غير موجود: "XYZ123"
```

✅ جملة "No courses found" تظهر

---

## Test Case 3: التسجيل في الكورس

### الخطوات:

1. في قائمة الكورسات، شوف أي كورس
2. لاحظ الزر **"Enroll Now"** بلون أزرق
3. اضغط **"Enroll Now"**

### النتائج المتوقعة:

✅ SnackBar يظهر: "Successfully enrolled in course!"
✅ الزر يتغيّر إلى **"Enrolled"** بلون بني فاتح
✅ في Firebase `student` collection، courseId يُضاف إلى `enrolledCourses`
✅ تأثير الحجب (overlay) يختفي

---

## Test Case 4: عرض الكورسات المسجلة

### الخطوات:

1. اذهب إلى التبويب **"Enrolled"**

### النتائج المتوقعة:

✅ فقط الكورسات المسجل فيها الطالب تظهر
✅ جميع الكورسات لها زر "Enrolled"
✅ إذا لم يكن هناك كورسات مسجلة: "No enrolled courses yet"

---

## Test Case 5: مشاهدة الفيديوهات

### الخطوات:

1. من قائمة الكورسات، اضغط على كورس مسجل فيه
2. يجب أن تُفتح صفحة **CourseVideoPlayer**

### في صفحة الفيديوهات:

1. شوف قائمة الدروس على اليسار
2. اضغط على أي درس
3. شاهد رابط الفيديو يتغيّر

### النتائج المتوقعة:

✅ قائمة الدروس تظهر مع أرقام (Lesson 1, 2, 3...)
✅ الدرس المختار يُظهّر بتأثير بصري (لون أزرق)
✅ رابط الفيديو يظهر في المنتصف
✅ يمكن تبديل الدروس بسهولة

---

## Test Case 6: محاولة الوصول لكورس غير مسجل

### الخطوات:

1. في قائمة الكورسات، اضغط على كورس **لم تسجل فيه**

### النتائج المتوقعة:

❌ لا يجب أن تُفتح صفحة الفيديوهات
✅ تبقى في نفس الصفحة أو يرجع الضغط بدون تأثير

---

## Test Case 7: البحث مع عدم التسجيل

### الخطوات:

1. ابحث عن كورس ("Flutter Basics")
2. النتيجة تظهر لكنك لم تسجل فيه

### النتائج المتوقعة:

✅ الكورس يظهر مع overlay داكن
✅ الزر "Enroll Now" يظهر
✅ يمكنك الضغط على الزر فقط، وليس على الكورس نفسه

---

## Test Case 8: تعديل الكورسات كمدرس

### الخطوات:

1. في Instructor Dashboard، أضف كورس آخر بروابط مختلفة
2. شاهد أن جميع الكورسات تظهر في القائمة

### النتائج المتوقعة:

✅ جميع الكورسات تظهر في Dashboard
✅ عدد الدروس يُعدّل تلقائياً
✅ الأسعار تظهر بشكل صحيح

---

## Firebase Console Verification

### في Firestore:

#### 1. اختبر Instructor Document:

```
Path: /instructor/{uid}
Expected Fields:
- name: "أحمد علي"
- email: "ahmed@example.com"
- courses: [
    {
      courseName: "Flutter Basics",
      videoLinks: ["link1", "link2", "link3"]
    }
  ]
```

#### 2. اختبر Course Document:

```
Path: /courses/{courseId}
Expected Fields:
- title: "Flutter Basics"
- instructorId: "{uid}"
- videoLinks: ["link1", "link2", "link3"]
- price: 99.99
- category: "Programming"
```

#### 3. اختبر Student Document:

```
Path: /student/{uid}
Expected Fields:
- name: "محمد أحمد"
- email: "mohammed@example.com"
- enrolledCourses: ["courseId1", "courseId2"]
```

---

## Edge Cases (حالات خاصة)

### Edge Case 1: كورس بدون فيديوهات

```dart
videoLinks: []
```

**المتوقع**: "No videos available for this course"

### Edge Case 2: تسجيل مزدوج

```
الضغط على "Enroll Now" مرتين بسرعة
```

**المتوقع**: Firebase arrayUnion يمنع التكرار تلقائياً

### Edge Case 3: حذف الكورس من Firestore

```
حذف courseId من courses collection
```

**المتوقع**:

- الكورس لا يظهر في قائمة الطلاب
- enrolledCourses قد يكون بـ courseId غير موجود (يمكن تنظيفه)

### Edge Case 4: فقدان الاتصال

```
قطع الاتصال أثناء الـ Enroll
```

**المتوقع**: SnackBar بخطأ، والتسجيل لا يحدث

---

## Performance Testing

### اختبر مع عدد كبير من الكورسات:

```
أضف 50+ كورس
```

**المتوقع**:

- الصفحة تحميل سريعاً
- البحث يعمل بسلاسة
- لا freezing في UI

---

## Debugging Tips

### عرض الـ logs:

```dart
print('Enrolled Courses: $_enrolledCourses');
print('Search Query: $_searchQuery');
```

### في Firebase Console:

- شوف Firestore logs
- تحقق من network requests
- شاهد document snapshots

### في Chrome DevTools:

```javascript
firebase.firestore().enableLogging(true);
```

---

## Checklist للإطلاق

- [ ] جميع الملفات بدون أخطاء
- [ ] جميع Test Cases تمرّت
- [ ] Firebase collections موجودة
- [ ] النصوص والألوان صحيحة
- [ ] البحث يعمل
- [ ] التسجيل يعمل
- [ ] عرض الفيديوهات يعمل
- [ ] Error handling يعمل
- [ ] SnackBars تظهر صحيحة
- [ ] Navigation سليمة

---

**آخر تحديث**: 14 نوفمبر 2025
