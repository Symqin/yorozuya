<p align="center">
  <img src="assets/icon/yoro.png" width="100" alt="Yorozuya Logo">
</p>

<h1 align="center">Yorozuya</h1>

<p align="center">
  <em>Everything you need, in one place.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10.8-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase">
  <img src="https://img.shields.io/badge/State-BLoC%20%2F%20Cubit-blueviolet" alt="BLoC">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

---

## ✨ Overview

**Yorozuya** adalah aplikasi e-commerce sederhana yang dibangun dengan **Flutter** dan **Firebase**. Produk diambil dari API publik [DummyJSON](https://dummyjson.com), sementara keranjang, transaksi, dan profil pengguna disimpan di **Cloud Firestore**.

---

## 🚀 Features

| Fitur | Deskripsi |
|---|---|
| 🎬 **Splash Screen** | Logo animasi fade-in + scale, auto-navigate ke login/home |
| 🔐 **Autentikasi** | Login email/password, Google Sign-In, registrasi, auto-login |
| 🏠 **Home** | Header user, search, banner promo, kategori filter, grid produk |
| 📦 **Produk** | Grid produk + search, detail (gambar, harga, rating, stok) |
| 🛒 **Keranjang** | Tambah/hapus item, update qty, total otomatis, checkout |
| 📝 **Riwayat** | List transaksi dari Firestore dengan detail lengkap |
| 👤 **Profil** | Edit nama, membership card, tentang app, link sosial media |

---

## 🛠 Tech Stack

| Teknologi | Kegunaan |
|---|---|
| **Flutter** | Framework UI cross-platform |
| **Firebase Auth** | Autentikasi (email/password + Google) |
| **Cloud Firestore** | Database (cart, transaksi, profil) |
| **flutter_bloc** | State management (Cubit pattern) |
| **GoRouter** | Navigasi terpusat + auth redirect |
| **Dio** | HTTP client untuk REST API |

---

## 🎨 Design System

<table>
  <tr>
    <td>🟢 <b>Primary</b></td>
    <td><code>#5D8C76</code> Sage Green</td>
    <td>🟠 <b>Accent</b></td>
    <td><code>#FF7043</code> Persimmon Orange</td>
  </tr>
  <tr>
    <td>🤎 <b>Secondary</b></td>
    <td><code>#D7CCC8</code> Wood Beige</td>
    <td>⬜ <b>Background</b></td>
    <td><code>#F5F5F0</code> Warm Off-white</td>
  </tr>
</table>

---

## 📁 Project Structure

```
lib/
├── main.dart                     # Entry point + MultiBlocProvider
├── core/
│   ├── routes/app_router.dart    # GoRouter + auth redirect
│   └── utils/                    # Reusable widgets & design tokens
└── features/
    ├── auth/                     # Splash, Login, Register + AuthCubit
    ├── home/                     # Home page (header, promo, kategori, produk)
    ├── product/                  # Product list, detail + ProductCubit
    ├── cart/                     # Cart page + CartCubit (Firestore)
    ├── transaction/              # History page + TransactionCubit
    ├── profile/                  # Profile page (edit nama, about)
    └── navigation/               # MainPage + BottomNavigationBar
```

---

## 🗺 Navigation

```
/splash  →  Splash Screen (initial)
/login   →  Login Page
/register → Register Page
/        →  Main Page (Home | History | Profile)
/products → Product List
/products/:id → Product Detail
/cart    →  Cart Page
```

> **Auth redirect**: Belum login → paksa ke `/login`. Sudah login + buka `/login` → redirect ke `/`.

---

## ⚡ Quick Start

```bash
# Clone
git clone https://github.com/Symqin/yorozuya.git
cd yorozuya

# Install dependencies
flutter pub get

# Run
flutter run
```

> **Prasyarat**: Flutter SDK ^3.10.8, Firebase project yang sudah dikonfigurasi, `firebase_options.dart` dari `flutterfire configure`.

---

## 📄 Documentation

Dokumentasi lengkap tersedia di [**DOCS.md**](DOCS.md), mencakup:
- Arsitektur & state management
- Firestore schema & security rules
- Reusable widgets reference
- Design system detail

---

## 👨‍💻 Developer

<p>
  <a href="https://github.com/Symqin"><img src="https://img.shields.io/badge/GitHub-Symqin-181717?logo=github" alt="GitHub"></a>
  <a href="https://www.instagram.com/symqin_/"><img src="https://img.shields.io/badge/Instagram-@symqin__-E4405F?logo=instagram&logoColor=white" alt="Instagram"></a>
  <a href="https://www.linkedin.com/in/syahril-mutaqin/"><img src="https://img.shields.io/badge/LinkedIn-Syahril%20Mutaqin-0A66C2?logo=linkedin" alt="LinkedIn"></a>
</p>
