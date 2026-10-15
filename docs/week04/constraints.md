# Laporan Diagnosa Kendala Layout (Constraint Diagnosis) - Drama Vault

Dokumen ini berisi dokumentasi 3 kasus layout overflow yang berpotensi terjadi pada aplikasi Drama Vault, analisis teknis berdasarkan aturan Constraint Flutter, serta solusi implementasi kode akhirnya.

---

## Kasus 1: Horizontal Overflow pada Judul Kartu (`DramaCard`)

### 1. Deskripsi & Gejala
- **Komponen:** `DramaCard`.
- **Skenario:** Judul drama memiliki teks yang sangat panjang (misal: `'Crash Landing on You ' * 30`).
- **Gejala Visual:** Garis-garis kuning-hitam (`RenderFlex overflowed horizontally`) di sisi kanan kartu jika lebar teks melampaui batas layar horizontal.

### 2. Diagnosis Constraint
- Dalam Flutter, jika komponen teks diletakkan di dalam kontainer horizontal tanpa batasan baris atau pembatas lebar, `Text` akan meminta lebar seluas panjang string-nya (*unbounded width*).
- Karena `ListTile` / `Row` memiliki batas lebar fisik layar, teks yang melebihinya akan memicu error *horizontal overflow*.

### 3. Solusi Kode Final
Menerapkan batasan baris (`maxLines`) dan pemotongan teks (`TextOverflow.ellipsis`) pada widget `Text` di dalam `ListTile`.

**Sebelum (Potensi Overflow):**
```dart
// Tanpa pembatasan baris dan overflow
Text(
  drama.title,
  style: theme.textTheme.titleMedium,
)
```

**Sesudah (Kode Final):**
```dart
Text(
  drama.title,
  maxLines: 2,
  overflow: TextOverflow.ellipsis, // Menambahkan titik-titik (...) jika teks terlalu panjang
  style: theme.textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.onSurface,
  ),
)
```

---

## Kasus 2: Vertical Overflow pada Layout Header (`WatchlistHeader`)

### 1. Deskripsi & Gejala
- **Komponen:** `WatchlistHeader` dan `WatchlistScreen`.
- **Skenario:** Aplikasi dibuka pada layar dengan tinggi terbatas (seperti mode *landscape* atau layar *smartphone* berukuran kecil 320 dp).
- **Gejala Visual:** Tampilan header dan statistik terpotong di bagian bawah dengan indikator `RenderFlex overflowed vertically`.

### 2. Diagnosis Constraint
- Kumpulan widget vertikal yang diletakkan di dalam `Column` biasa bersifat kaku (*rigid*).
- `Column` memberikan constraint tinggi maksimum sesuai tinggi viewport. Jika total tinggi `WatchlistHeader` + `WatchlistSearch` + konten lainnya melebihi tinggi layar, `Column` tidak dapat menggeser elemennya sendiri (*non-scrollable*), sehingga terjadi *vertical overflow*.

### 3. Solusi Kode Final
Mengubah struktur layout utama pada `WatchlistScreen` menggunakan `CustomScrollView` dan membungkus header di dalam `SliverToBoxAdapter`.

**Sebelum (Potensi Overflow pada Column Kaku):**
```dart
// Column biasa tidak bisa di-scroll saat layar pendek
Column(
  children: [
    const WatchlistHeader(),
    WatchlistSearch(...),
    Expanded(child: ListView(...)),
  ],
)
```

**Sesudah (Kode Final):**
```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(
      child: Column(
        children: [
          const WatchlistHeader(),
          const SizedBox(height: 16),
          WatchlistSearch(...),
        ],
      ),
    ),
    // Slivers untuk daftar drama/empty state
  ],
)
```

---

## Kasus 3: Bottom Overflow akibat Keyboard Virtual (`WatchlistSearch`)

### 1. Deskripsi & Gejala
- **Komponen:** `WatchlistSearch`.
- **Skenario:** Pengguna mengklik kolom pencarian (`TextField`) sehingga keyboard virtual Android/iOS muncul di layar.
- **Gejala Visual:** Muncul garis overflow kuning-hitam di bagian bawah layar (`BOTTOM OVERFLOWED BY X PIXELS`) karena keyboard mengambil sekitar 300dp area vertikal.

### 2. Diagnosis Constraint
- Ketika keyboard virtual muncul, tinggi area kerja (*viewport height*) aplikasi mengecil secara drastis.
- Jika elemen halaman tidak berada di dalam konteks *scrollable view*, elemen-elemen di bawah `TextField` terdorong keluar dari sisa viewport yang tersedia.

### 3. Solusi Kode Final
Memastikan seluruh struktur halaman berada di dalam `CustomScrollView`, sehingga viewport otomatis menyesuaikan dan area layar dapat digeser saat keyboard aktif.

**Kode Final pada `WatchlistScreen`:**
Arsitektur CustomScrollView pada kode final otomatis menyesuaikan susutan viewport. Elemen-elemen seperti WatchlistSearch di dalam SliverToBoxAdapter serta EmptyWatchlist di dalam SliverFillRemaining secara otomatis menjadi scrollable sehingga terhindar dari overflow.

---

## Ringkasan Perbandingan Solusi

| Kasus Overflow | Tipe Constraint | Solusi Flutter yang Diterapkan |
| :--- | :--- | :--- |
| **DramaCard** | *Unbounded Horizontal Width* | `maxLines: 2` & `overflow: TextOverflow.ellipsis` |
| **WatchlistHeader** | *Unbounded Vertical Height* | `CustomScrollView` + `SliverToBoxAdapter` |
| **WatchlistSearch** | *Reduced Viewport (Keyboard)* | `CustomScrollView` |