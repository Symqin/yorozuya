# 📖 Dokumentasi Aplikasi Yorozuya

Aplikasi e-commerce sederhana yang dibangun dengan **Flutter** dan **Firebase**. Produk diambil dari API publik [DummyJSON](https://dummyjson.com), sementara keranjang, transaksi, dan profil pengguna disimpan di **Cloud Firestore**.

---

## 📋 Daftar Isi

- [Tech Stack](#-tech-stack)
- [Struktur Folder](#-struktur-folder)
- [API & Data Source](#-api--data-source)
- [Arsitektur & State Management](#-arsitektur--state-management)
- [Navigasi (GoRouter)](#-navigasi-gorouter)
- [Fitur Aplikasi](#-fitur-aplikasi)
- [Reusable Widgets](#-reusable-widgets)
- [Design System](#-design-system)
- [Firestore Schema](#-firestore-schema)
- [Firestore Security Rules](#-firestore-security-rules)
- [Cara Menjalankan](#-cara-menjalankan)

---

## 🛠 Tech Stack

| Teknologi | Versi | Kegunaan |
|---|---|---|
| Flutter | SDK ^3.10.8 | Framework UI cross-platform |
| Dart | (bundled) | Bahasa pemrograman |
| Firebase Auth | ^6.1.4 | Autentikasi (email/password + Google) |
| Cloud Firestore | ^6.1.2 | Database realtime (cart, transaksi, profil) |
| GoRouter | ^17.1.0 | Navigasi terpusat |
| flutter_bloc | ^9.1.1 | State management (Cubit pattern) |
| Dio | ^5.9.1 | HTTP client untuk REST API |
| Google Sign-In | ^6.2.1 | Login via Google |
| url_launcher | ^6.3.2 | Buka link sosial media di browser |
| intl | ^0.20.2 | Formatting angka (harga, mata uang) |

---

## 📁 Struktur Folder

```
lib/
├── main.dart                          # Entry point, MultiBlocProvider, MaterialApp.router
├── firebase_options.dart              # Konfigurasi Firebase (auto-generated)
│
├── core/
│   ├── routes/
│   │   └── app_router.dart            # GoRouter config + auth redirect
│   └── utils/
│       ├── color.dart                 # AppColors (primary, secondary, accent, background, textDark)
│       ├── customtexfield.dart        # CustomTextFormField (input form login/register)
│       ├── product_card.dart          # ProductCard (kartu produk di grid)
│       ├── category_item.dart         # CategoryItem (ikon kategori dengan state aktif)
│       ├── primary_button.dart        # PrimaryButton (tombol utama konsisten)
│       ├── empty_state.dart           # EmptyStateWidget (state kosong + ikon besar)
│       ├── menu_tile.dart             # MenuTile (item menu profil)
│       └── section_title.dart         # SectionTitle (judul seksi + action link)
│
├── features/
│   ├── auth/
│   │   ├── cubit/
│   │   │   ├── auth_cubit.dart        # Login, register, Google sign-in, logout, updateDisplayName
│   │   │   └── auth_state.dart        # AuthInitial, AuthLoading, AuthSuccess, AuthError
│   │   └── pages/
│   │       ├── login_page.dart        # Halaman login (email/password + Google)
│   │       └── register_page.dart     # Halaman registrasi
│   │
│   ├── home/
│   │   └── home_page.dart             # Halaman utama (header, search, promo, kategori, produk)
│   │
│   ├── product/
│   │   ├── cubit/
│   │   │   ├── product_cubit.dart     # Fetch produk dari DummyJSON API
│   │   │   └── product_state.dart     # ProductInitial, ProductLoading, ProductLoaded, ProductError
│   │   ├── models/
│   │   │   └── product_model.dart     # Model produk (id, title, price, category, rating, dll)
│   │   └── pages/
│   │       ├── product_list_page.dart # Grid semua produk + search bar
│   │       └── product_detail_page.dart # Detail produk + tambah ke keranjang
│   │
│   ├── cart/
│   │   ├── cubit/
│   │   │   ├── cart_cubit.dart        # CRUD keranjang via Firestore
│   │   │   └── cart_state.dart        # CartState (items, totalPrice, totalItems)
│   │   ├── models/
│   │   │   └── cart_item.dart         # Model item keranjang
│   │   └── pages/
│   │       └── cart_page.dart         # Halaman keranjang + checkout
│   │
│   ├── transaction/
│   │   ├── cubit/
│   │   │   └── transaction_cubit.dart # Simpan transaksi ke Firestore
│   │   └── pages/
│   │       └── history_page.dart      # Riwayat transaksi dari Firestore
│   │
│   ├── profile/
│   │   └── profile_page.dart          # Profil user, edit nama (Firestore), tentang app, logout
│   │
│   └── navigation/
│       └── pages/
│           └── main_page.dart         # BottomNavigationBar + IndexedStack (Home, History, Profile)
```

---

## 🌐 API & Data Source

### 1. DummyJSON — Produk (REST API)

| Item | Detail |
|---|---|
| **Base URL** | `https://dummyjson.com` |
| **Endpoint** | `GET /products` |
| **HTTP Client** | Dio |
| **Cubit** | `ProductCubit.fetchProducts()` |

**Response fields yang dipakai:**

```json
{
  "id": 1,
  "title": "iPhone 9",
  "description": "An apple mobile...",
  "category": "smartphones",
  "price": 549,
  "rating": 4.69,
  "stock": 94,
  "thumbnail": "https://...",
  "images": ["https://...", "https://..."]
}
```

### 2. Firebase Auth — Autentikasi

| Method | Fungsi |
|---|---|
| `createUserWithEmailAndPassword` | Registrasi email/password |
| `signInWithEmailAndPassword` | Login email/password |
| `signInWithCredential` (Google) | Login via Google |
| `signOut` | Logout |
| `updateDisplayName` | Update nama tampilan |

### 3. Cloud Firestore — Database

Digunakan untuk menyimpan data yang perlu persisten per-user:

| Collection | Kegunaan | Cubit |
|---|---|---|
| `users/{uid}` | Profil user (displayName, email) | `AuthCubit` |
| `carts/{uid}` | Keranjang belanja | `CartCubit` |
| `transactions/{id}` | Riwayat transaksi | `TransactionCubit` |

---

## 🧠 Arsitektur & State Management

Aplikasi menggunakan **BLoC/Cubit pattern** dari `flutter_bloc`:

```
UI (Widget) → Cubit → Data Source (API / Firestore)
     ↑                          ↓
     └──── State (emit) ────────┘
```

### Cubit yang tersedia:

| Cubit | State | Fungsi |
|---|---|---|
| `AuthCubit` | `AuthState` (Initial, Loading, Success, Error) | Login, register, Google sign-in, logout, update nama |
| `ProductCubit` | `ProductState` (Initial, Loading, Loaded, Error) | Fetch produk dari DummyJSON |
| `CartCubit` | `CartState` (items list) | CRUD keranjang via Firestore |
| `TransactionCubit` | `bool` (loading) | Simpan transaksi checkout |

Semua Cubit di-provide di `main.dart` via `MultiBlocProvider`.

---

## 🗺 Navigasi (GoRouter)

Navigasi terpusat di `lib/core/routes/app_router.dart`:

| Route | Halaman | Akses |
|---|---|---|
| `/` | `MainPage` (Home + History + Profile) | Harus login |
| `/login` | `LoginPage` | Public |
| `/register` | `RegisterPage` | Public |
| `/products` | `ProductListPage` | Harus login |
| `/products/:id` | `ProductDetailPage` | Harus login (extra: ProductModel) |
| `/cart` | `CartPage` | Harus login |

### Auth Redirect Logic:

```
Belum login + bukan /login atau /register  →  redirect ke /login
Sudah login + akses /login                 →  redirect ke /
```

### Navigasi di kode:

```dart
context.go('/login');          // Replace seluruh stack
context.push('/products');     // Push ke stack
context.pop();                 // Kembali
```

---

## ✨ Fitur Aplikasi

### 🔐 Autentikasi
- Login via **email/password**
- Login via **Google Sign-In**
- Registrasi akun baru
- Auto-login (cek session)
- Logout dengan konfirmasi dialog

### 🏠 Home Page
- Header dengan **nama user dari Firestore** (realtime)
- Search bar → navigasi ke halaman produk
- Banner promo
- **Kategori filter** (Smartphones, Laptops, Tops, Furniture, dll)
- Grid produk (max 6, filtered by kategori)
- **Cart badge** dengan jumlah item
- Pull-to-refresh

### 📦 Produk
- Grid produk dari DummyJSON API
- **Search bar** fungsional (filter by judul)
- Detail produk (gambar, deskripsi, harga, rating, stok)
- Tambah ke keranjang

### 🛒 Keranjang
- List item keranjang
- Update quantity (+/-)
- Hapus item
- Total harga otomatis
- **Checkout** → simpan ke Firestore sebagai transaksi

### 📝 Riwayat Transaksi
- List transaksi dari Firestore
- Detail: tanggal, total harga, daftar item
- Empty state jika belum ada transaksi

### 👤 Profil
- Info profil (avatar, nama, email)
- Membership card (Gold Tier)
- **Edit nama** → simpan ke Firestore + Firebase Auth
- **Tentang Aplikasi** (bottom sheet):
  - Deskripsi app
  - Link GitHub, Instagram, LinkedIn
- Logout

---

## 🧩 Reusable Widgets

Semua widget reusable ada di `lib/core/utils/`:

| Widget | File | Deskripsi |
|---|---|---|
| `PrimaryButton` | `primary_button.dart` | Tombol hijau utama dengan loading state & optional icon |
| `EmptyStateWidget` | `empty_state.dart` | Ikon besar + judul + subtitle + optional action |
| `MenuTile` | `menu_tile.dart` | Item menu settings (icon + title + chevron) |
| `SectionTitle` | `section_title.dart` | Judul seksi + optional "Lihat Semua" link |
| `ProductCard` | `product_card.dart` | Kartu produk untuk grid (gambar, judul, harga, rating) |
| `CategoryItem` | `category_item.dart` | Ikon kategori bulat dengan state aktif/non-aktif |
| `CustomTextFormField` | `customtexfield.dart` | Input form styled untuk login/register |

---

## 🎨 Design System

### Warna (`AppColors`)

| Nama | Hex | Kegunaan |
|---|---|---|
| `primary` | `#5D8C76` | Sage Green — tombol, aksen utama |
| `secondary` | `#D7CCC8` | Wood Beige — border, pendukung |
| `accent` | `#FF7043` | Persimmon Orange — diskon, highlight |
| `background` | `#F5F5F0` | Warm Off-white — background halaman |
| `textDark` | `#37474F` | Blue Grey — teks utama |
| `textLight` | `#FAFAFA` | Putih — teks di atas tombol berwarna |

### Konsistensi UI

- Semua halaman menggunakan `AppColors.background` sebagai scaffold color
- AppBar: `backgroundColor: AppColors.background`, `elevation: 0`, `foregroundColor: AppColors.textDark`
- Border radius: `12` untuk card/button, `16` untuk banner/container besar
- Shadow: `Colors.black.withOpacity(0.03-0.04)`, blur 5-10

---

## 🗄 Firestore Schema

### Collection: `users/{uid}`

```json
{
  "displayName": "Syahril",
  "email": "syahril@example.com"
}
```

### Collection: `carts/{uid}`

```json
{
  "updatedAt": "Timestamp",
  "items": [
    {
      "productId": 1,
      "title": "iPhone 9",
      "price": 549.0,
      "quantity": 2,
      "thumbnail": "https://..."
    }
  ]
}
```

### Collection: `transactions/{auto-id}`

```json
{
  "userId": "W6eO1Ff...",
  "totalPrice": 1098.0,
  "createdAt": "Timestamp",
  "items": [
    {
      "productId": 1,
      "title": "iPhone 9",
      "price": 549.0,
      "quantity": 2,
      "thumbnail": "https://..."
    }
  ]
}
```

---

## 🔒 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }

    match /carts/{userId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }

    match /transactions/{transactionId} {
      allow create: if request.auth != null
        && request.resource.data.userId == request.auth.uid;
      allow read: if request.auth != null
        && resource.data.userId == request.auth.uid;
      allow update, delete: if false;
    }

    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 🚀 Cara Menjalankan

### Prasyarat

- Flutter SDK ^3.10.8
- Firebase project yang sudah dikonfigurasi
- Android/iOS emulator atau device

### Langkah

```bash
# 1. Clone repo
git clone https://github.com/Symqin/yorozuya.git
cd yorozuya

# 2. Install dependencies
flutter pub get

# 3. Pastikan firebase_options.dart sudah ada
#    (generate via: flutterfire configure)

# 4. Jalankan
flutter run
```

### Build APK

```bash
flutter build apk --release
```

---

## 👨‍💻 Developer

- **GitHub**: [Symqin](https://github.com/Symqin)
- **Instagram**: [@symqin_](https://www.instagram.com/symqin_/)
- **LinkedIn**: [Syahril Mutaqin](https://www.linkedin.com/in/syahril-mutaqin/)
