# Refleksi Arsitektural (AFL 1)

## Pertanyaan 1: Keputusan struktural mana dari Minggu 1 yang paling membantu Anda di Minggu 5?
Keputusan di Minggu 1 untuk menerapkan struktur folder modular yang rapi (memisahkan `domain/`, `data/`, dan direktori khusus `presentation/widgets/`) serta mengisolasi model data `Drama` secara terpusat.

Keputusan ini menjadi fondasi utama ketika aplikasi berkembang dari 1 layar utama menjadi 3 layar penuh (`HomeScreen`, `WatchlistScreen`, dan `DramaDetailScreen`) di Minggu 5:
- **Mendukung Minggu 2 (Killing the God Widget):** Karena folder `widgets/` sudah disiapkan sejak Minggu 1, proses memecah widget raksasa menjadi komponen-komponen kecil (seperti `HomeHeader`, `DramaCard`, dan `WatchlistSearch`) memiliki lokasi yang jelas dan tidak menumpuk di file layar utama.
- **Memudahkan Minggu 3 (Material Design 3):** Model data dan widget yang terpisah memudahkan penerapan sistem warna M3 (`colorScheme`) dan komponen M3 secara konsisten di ketiga layar tanpa menyentuh logika data.
- **Memperlancar Minggu 4 (Responsivitas & Overflow):** Komponen UI yang sudah terpecah rapi memudahkan pembungkusan tata letak ke dalam `SliverLayoutBuilder` / `ResponsiveDramaView` untuk menangani layar tablet dan mencegah *text overflow* di ke-3 layar sekaligus.

## Pertanyaan 2: Keputusan struktural mana yang menyita waktu Anda, dan apa yang akan Anda lakukan secara berbeda?
Keputusan awal di Minggu 2 yang terlalu berfokus pada struktur 1 layar utama tanpa merancang komponen kartu yang benar-benar *reusable* untuk layar lainnya.

Akibatnya, saat menambah 2 layar baru dan menerapkan materi Minggu 2 (pembasmian *god widget*) serta Minggu 4 (responsivitas), sempat tercipta komponen kartu yang duplikat dengan penanganan *overflow* yang berbeda-beda. Hal ini menyita waktu untuk melakukan *refactoring* ulang demi menyatukan kartu UI menjadi satu `DramaCard` yang fleksibel dan mengekstrak `ResponsiveDramaView`. Ke depannya, saya akan merancang komponen UI dasar agar *reusable* untuk multi-layar sejak Minggu 1.

## Pertanyaan 3: Di manakah posisi state aplikasi Anda saat ini, dan apa hal yang sulit saat memindahkannya di Modul 2?
Saat ini, *state* aplikasi masih dikelola secara lokal menggunakan `StatefulWidget` dan `setState()` yang tersebar di masing-masing dari 3 layar (`HomeScreen`, `WatchlistScreen`, dan `DramaDetailScreen`).

Kelemahan *local state* ini sangat terasa ketika aplikasi memiliki 3 layar yang saling berhubungan: perubahan data pada satu layar (seperti menambah episode di `DramaDetailScreen` atau merubah bookmark di `HomeScreen`) tidak otomatis memperbarui tampilan di `WatchlistScreen` secara *real-time*.

Tantangan utama saat berpindah ke Modul 2 (*State Management* terpusat seperti Provider, BLoC, atau Riverpod) adalah mencabut seluruh logika `setState()` dari ketiga layar tersebut, memindahkan manipulasi daftar data ke lapisan *repository*, serta membangun satu *single source of truth* reaktif yang terhubung ke ketiga layar sekaligus.