# Drama Vault - Collection & Log Tracker

Aplikasi manajemen dan pelacak drama Asia (K-Drama & C-Drama) berbasis Flutter yang dikembangkan untuk tugas **AFL 1 (Visual Programming)**. Aplikasi ini menerapkan prinsip **Clean Architecture**, desain **Material 3**, serta kustomisasi tata letak adaptif untuk berbagai ukuran layar.

---

## 📌 Domain Track & Use Case
- **Domain Track:** Track A - The Fandom Vault (Collection & Log Tracker)
- **Use Case:** Drama Watchlist & Episode Tracker
- **Target Pengguna:** Penggemar drama yang ingin mengorganisasi koleksi tontonan, melacak progres episode, memberi rating, serta menyaring drama berdasarkan genre dan kiasan (*tropes*).

---

## ✨ Fitur Utama

1. **Eksplorasi Katalog (`HomeScreen`):**
    - Pencarian drama secara *real-time*.
    - Filter cepat berdasarkan genre dan asal drama (*K-Drama*, *C-Drama*, *Romance*, *Fantasy*, *Action*).
    - Fitur *bookmark* untuk menambahkan drama ke daftar tontonan.

2. **Daftar Tontonan (`WatchlistScreen`):**
    - Pelacakan episode yang sudah ditonton.
    - Akses cepat penambahan episode (+1 Episode) langsung dari kartu drama.
    - Penanganan *empty state* dan pencarian khusus di dalam watchlist.

3. **Detail Drama (`DramaDetailScreen`):**
    - Indikator progres menonton interaktif (*progress bar*).
    - Informasi lengkap: rating, asal negara, genre, sinopsis, dan daftar tag *tropes*.
    - Tombol *increment* episode yang responsif dan tervalidasi.

4. **Desain & Arsitektur:**
    - **Material Design 3:** Konsistensi pewarnaan menggunakan `Theme.of(context).colorScheme` tanpa *hardcoded color* atau *font size*.
    - **Tata Letak Adaptif:** Transisi otomatis antara `SliverList` pada perangkat *mobile* dan `SliverGrid` pada perangkat *tablet* (lebar layar ≥ 600dp).
    - **Clean Code:** Tidak ada berkas UI yang melebihi batas ~200 baris kode (*Killing the God Widget*).

---

## Tangkapan Layar Aplikasi

| Layar Eksplorasi (`HomeScreen`) | Layar Detail (`DramaDetailScreen`) | Layar Watchlist (`WatchlistScreen`) |
| :---: | :---: | :---: |
| <img src="docs/screenshots/home.png" width="220" alt="Home Screen"> | <img src="docs/screenshots/detail.png" width="220" alt="Detail Screen"> | <img src="docs/screenshots/watchlist.png" width="220" alt="Watchlist Screen"> |

---

##  Cara Menjalankan Proyek

### Prasyarat
- Flutter SDK (Versi `>=3.3.0`)
- Dart SDK (Versi `>=3.3.0`)

### Langkah-Langkah Instalasi

1. **Clone Repositori**
   ```bash
   git clone https://github.com/USERNAME_ANDA/warung_digital.git
   cd warung_digital
2. **Unduh Dependensi**
    ```bash
    flutter pub get
   ```
3. **Jalankan Verifikasi Kode**
    ```bash
    flutter analyze
   ```
    Pastikan output menunjukkan 0 issue/clean.`

4. **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## Dokumentasi Terkait
- Penjelasan Struktur Arsitektur: docs/structure.md
- Refleksi Arsitektural Minggu 5: docs/week05/reflection.md
