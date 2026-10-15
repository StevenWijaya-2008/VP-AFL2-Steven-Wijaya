# Responsive Test Matrix - Drama Vault

| Screen | Test Case | Status | Fix / Note                                                                |
| :--- | :--- | :--- |:--------------------------------------------------------------------------|
| **WatchlistScreen** | Small phone (320 dp) | PASS | Teks judul header & card disesuaikan dengan `maxLines` & `ellipsis`.      |
| **WatchlistScreen** | Large phone (430 dp) | PASS | Tampilan 1 kolom berjalan normal.                                         |
| **WatchlistScreen** | Tablet (800 dp) | PASS | `LayoutBuilder` mengubah struktur menjadi `SliverGrid` 2 kolom.           |
| **WatchlistScreen** | Landscape Mode | PASS | Menggunakan `CustomScrollView` sehingga seluruh layar dapat di-scroll.    |
| **WatchlistScreen** | Long text (200 chars) | PASS | `DramaCard` memotong nama panjang dengan titik-titik tanpa overflow.      |
| **WatchlistScreen** | Empty state (0 items) | PASS | Menampilkan `EmptyWatchlist` dengan ikon, pesan, dan tombol clear search. |
| **WatchlistScreen** | Long list (500 items) | PASS | Menggunakan `SliverChildBuilderDelegate` untuk *lazy loading*.            |
| **WatchlistScreen** | Keyboard open | PASS | Konten tidak terpotong saat input pencarian aktif di layar pendek.        |
| **WatchlistScreen** | Dark mode | PASS | Menggunakan warna dari `Theme.of(context).colorScheme`.                   |