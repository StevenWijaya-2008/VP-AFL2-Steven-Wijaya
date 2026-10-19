# Struktur Arsitektur & Pemisahan Kode

Proyek ini menerapkan kombinasi Clean Architecture dan Feature-First Organization. Direktori dipisah secara tegas berdasarkan tanggung jawabnya untuk menjaga keterbacaan, keterpeliharaannya (*maintainability*), serta mematuhi kriteria penilai AFL 1.

---

## 📁 Pohon Direktori Repositori (`lib/`)

```text
lib/
├── app.dart                        # Root widget & konfigurasi MaterialApp
├── main.dart                       # Entry point utama aplikasi
├── core/                           # Kode terbagi yang bersifat global
│   ├── theme/
│   │   └── app_theme.dart          # Konfigurasi Tema Material 3 (ColorScheme, Typography)
│   └── widgets/                    # Komponen UI bersama lintas fitur
├── data/
│   └── dummy_data.dart             # Sumber data terpusat (Mock dataset)
└── features/
    └── watchlist/                  # Modul Fitur Utamanya (Watchlist & Drama Explorer)
        ├── domain/
        │   └── drama_model.dart    # Model entitas data murni (Immutable)
        └── presentation/
            ├── screens/
            │   ├── drama_detail_screen.dart
            │   ├── home_screen.dart
            │   ├── main_navigation_screen.dart
            │   └── watchlist_screen.dart
            └── widgets/
                ├── category_filter_chips.dart
                ├── drama_card.dart
                ├── empty_watchlist.dart
                ├── home_header.dart
                ├── responsive_drama_view.dart
                ├── watchlist_header.dart
                └── watchlist_search.dart

```

#  Keputusan Arsitektur Utama

## 1. Peran Direktori `core/`
Folder `core/` hanya berisi kode yang digunakan secara global:
- **core/theme/app_theme.dart**  
  Menampung central tema Material 3 (ColorScheme, pengaturan font, CardThemeData, dan NavigationBarThemeData).
- **core/widgets/**  
  Menampung widget pembantu generik yang siap dipakai di luar modul *watchlist*.

---

## 2. Modul Fitur Berbasis `features/` (Feature-First)
Seluruh layar dan komponen bisnis diletakkan dalam direktori spesifik `features/watchlist/`.  
Pemisahan ini menjaga:
- **Lapisan domain** → `domain/drama_model.dart`
- **Lapisan tampilan** → `presentation/screens/` & `presentation/widgets/`

Sehingga perubahan UI tidak berdampak pada logika data utama.

---

## 3. Eliminasi "God Widgets"
- Setiap layar tidak ditulis dalam satu file raksasa.  
- Komponen UI dipecah menjadi widget kecil berskala tunggal, misalnya:
  - `HomeHeader`
  - `WatchlistSearch`
  - `CategoryFilterChips`
  - `DramaCard`
- Setiap berkas dalam proyek dijaga di bawah ~200 baris kode.

---

## 4. Strategi Tata Letak Responsif (`ResponsiveDramaView`)
- Mengisolasi logika pendeteksian ukuran layar menggunakan **SliverLayoutBuilder**.  
- Dinamis beralih antara:
  - **SliverList** → layar ponsel `< 600dp`
  - **SliverGrid** → layar tablet `≥ 600dp`
- Seluruh target sentuh memenuhi syarat minimal **48dp**.

---

## 5. Konsistensi Penamaan & Kebersihan Proyek
- Konvensi penamaan Dart baku:
  - **snake_case** untuk nama file
  - **PascalCase** untuk kelas
- File konfigurasi `.gitignore` sudah dipasang dengan benar sehingga folder `build/` dan `.dart_tool/` tidak masuk riwayat komit.
