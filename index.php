<?php

declare(strict_types=1);

require_once __DIR__ . '/includes/auth.php';

$pdo = db();

// Ambil pertandingan aktif yang disesuaikan dengan kegiatan yang sedang aktif/berlangsung
$activeMatch = current_active_match();

// Ambil riwayat pertandingan yang sudah selesai (Arsip Hari-Hari Perayaan Islami)
$finishedMatchesStmt = $pdo->query(
    "SELECT m.id, m.finished_at, r.name AS round_name,
            e.name AS event_name, e.location, e.event_date
     FROM matches m
     JOIN rounds r ON r.id = m.round_id
     JOIN events e ON e.id = r.event_id
     WHERE m.status = 'finished'
     ORDER BY e.event_date DESC, m.finished_at DESC, m.id DESC
     LIMIT 6"
);
$finishedMatches = $finishedMatchesStmt->fetchAll();

// Ambil podium juara untuk setiap pertandingan yang selesai
$matchIds = array_column($finishedMatches, 'id');
$podiumsByMatch = [];
if (!empty($matchIds)) {
    $inClause = implode(',', array_map('intval', $matchIds));
    $podiumStmt = $pdo->query(
        "SELECT mt.match_id, mt.score, t.name AS team_name, t.members
         FROM match_teams mt
         JOIN teams t ON t.id = mt.team_id
         WHERE mt.match_id IN ($inClause)
         ORDER BY mt.match_id, mt.score DESC"
    );
    while ($row = $podiumStmt->fetch()) {
        $podiumsByMatch[(int) $row['match_id']][] = $row;
    }
}

// Statistik ringkas sistem
$statsStmt = $pdo->query(
    "SELECT 
        (SELECT COUNT(*) FROM events) AS total_events,
        (SELECT COUNT(*) FROM teams) AS total_teams,
        (SELECT COUNT(*) FROM matches WHERE status = 'finished') AS total_completed_matches"
);
$stats = $statsStmt->fetch() ?: ['total_events' => 0, 'total_teams' => 0, 'total_completed_matches' => 0];

// Helper kategori perayaan Islami berdasarkan nama acara
function get_islamic_badge(string $eventName): array
{
    $lower = mb_strtolower($eventName, 'UTF-8');
    if (str_contains($lower, 'ramadhan') || str_contains($lower, 'ramadan')) {
        return ['icon' => '🌙', 'label' => 'Semarak Ramadhan', 'class' => 'badge-ramadhan'];
    }
    if (str_contains($lower, 'maulid')) {
        return ['icon' => '🕌', 'label' => 'Maulid Nabi SAW', 'class' => 'badge-maulid'];
    }
    if (str_contains($lower, 'muharram') || str_contains($lower, 'tahun baru')) {
        return ['icon' => '✨', 'label' => '1 Muharram Hijriyah', 'class' => 'badge-muharram'];
    }
    if (str_contains($lower, 'isra') || str_contains($lower, 'mi\'raj') || str_contains($lower, 'miraj')) {
        return ['icon' => '⭐', 'label' => 'Isra Mi\'raj', 'class' => 'badge-isra'];
    }
    if (str_contains($lower, 'milad') || str_contains($lower, 'harlah') || str_contains($lower, 'hut')) {
        return ['icon' => '🎖️', 'label' => 'Milad & Harlah', 'class' => 'badge-milad'];
    }
    return ['icon' => '🕋', 'label' => 'Hari Besar Islam (PHBI)', 'class' => 'badge-phbi'];
}

$pageTitle = 'Sistem Cerdas Cermat Islami Digital';
$bodyClass = 'landing-page';
$showAppHeader = false;
require __DIR__ . '/includes/header.php';
?>

<!-- Navbar Publik -->
<header class="landing-header">
    <div class="landing-header-inner">
        <a class="brand" href="/" aria-label="Beranda CCI An Nuur">
            <span class="brand-mark" aria-hidden="true">CCI</span>
            <div class="brand-text">
                <span class="brand-name">CCI An Nuur</span>
                <span class="brand-sub">Sistem Cerdas Cermat</span>
            </div>
        </a>

        <nav class="landing-nav" aria-label="Navigasi Utama">
            <a href="#portal">Pintu Masuk</a>
            <a href="#live-match" class="nav-live-link" id="nav-live-link" <?= $activeMatch ? '' : 'style="display:none;"' ?>>
                <span class="pulse-dot" aria-hidden="true"></span>
                Pertandingan Aktif
            </a>
            <a href="#riwayat">Arsip Juara PHBI</a>
            <a href="#fitur">Kenapa Pakai Ini?</a>
            <a href="#alur">Alur Lomba</a>
        </nav>

        <div class="landing-header-actions">
            <?php if (user()): ?>
                <a class="button button-primary button-sm" href="/operator.php">Konsol Operator &rarr;</a>
            <?php else: ?>
                <a class="button button-secondary button-sm" href="/login.php">Masuk Operator</a>
            <?php endif; ?>
        </div>
    </div>
</header>

<!-- Hero Section -->
<section class="landing-hero">
    <div class="landing-hero-backdrop" aria-hidden="true"></div>
    <div class="landing-hero-content">
        <div class="hero-badge">
            <span class="hero-badge-icon">🕌</span>
            <span>Aplikasi Bel & Papan Skor Cerdas Cermat</span>
        </div>
        <h1 class="hero-title">
            Kunci Bel Pertama <span class="text-gradient">Tanpa Perdebatan</span>, Langsung di Layar Panggung.
        </h1>
        <p class="hero-description">
            Satu aplikasi untuk juri di meja panggung, operator di laptop panitia, dan santri yang siap memencet bel dari HP. Saat jawaban dinilai, skor di proyektor aula langsung terbarui otomatis.
        </p>

        <!-- Aksi Utama -->
        <div class="hero-actions">
            <a class="button button-primary button-large" href="#portal">
                Buka Bel atau Layar Skor &darr;
            </a>
            <a class="button button-accent button-large" id="hero-live-btn" href="<?= $activeMatch ? '/scoreboard.php?match_id=' . (int) $activeMatch['id'] : '#' ?>" target="_blank" rel="noopener" <?= $activeMatch ? '' : 'style="display:none;"' ?>>
                <span class="pulse-dot" aria-hidden="true"></span>
                Buka Skor Panggung Live
            </a>
            <a class="button button-secondary button-large" id="hero-history-btn" href="#riwayat" <?= $activeMatch ? 'style="display:none;"' : '' ?>>
                Lihat Rekap Pemenang
            </a>
        </div>

        <!-- Strip Angka Ringkas -->
        <div class="hero-stats">
            <div class="stat-item">
                <span class="stat-number"><?= (int) $stats['total_events'] ?></span>
                <span class="stat-label">Acara Terlaksana</span>
            </div>
            <div class="stat-divider" aria-hidden="true"></div>
            <div class="stat-item">
                <span class="stat-number"><?= (int) $stats['total_completed_matches'] ?></span>
                <span class="stat-label">Babak Selesai</span>
            </div>
            <div class="stat-divider" aria-hidden="true"></div>
            <div class="stat-item">
                <span class="stat-number"><?= (int) $stats['total_teams'] ?></span>
                <span class="stat-label">Regu Terdaftar</span>
            </div>
            <div class="stat-divider" aria-hidden="true"></div>
            <div class="stat-item">
                <span class="stat-number">0,001s</span>
                <span class="stat-label">Presisi Kunci Bel</span>
            </div>
        </div>
    </div>
</section>

<!-- Banner Pertandingan Aktif -->
<section class="live-spotlight-section" id="live-match" aria-labelledby="live-heading" <?= $activeMatch ? '' : 'hidden style="display:none;"' ?>>
    <div class="live-spotlight-card">
        <div class="live-badge-group">
            <span class="live-pulse-badge">
                <span class="pulse-dot-red" aria-hidden="true"></span>
                PERTANDINGAN SEDANG BERLANGSUNG
            </span>
            <span class="live-round-badge" id="live-round-badge"><?= e($activeMatch ? status_label($activeMatch['status']) : '') ?></span>
        </div>
        <div class="live-spotlight-body">
            <div>
                <span class="eyebrow" id="live-event-name"><?= e($activeMatch ? ($activeMatch['event_name'] . ($activeMatch['location'] ? ' • ' . $activeMatch['location'] : '')) : '') ?></span>
                <h2 id="live-heading" class="live-title"><?= e($activeMatch ? $activeMatch['round_name'] : '') ?></h2>
                <p class="live-meta" id="live-meta">
                    Memainkan <strong id="live-question-num">Soal ke-<?= (int) ($activeMatch['current_question'] ?? 1) ?></strong> • Diikuti oleh <strong id="live-team-count"><?= (int) ($activeMatch['team_count'] ?? 0) ?> Regu</strong>
                </p>
            </div>
            <div class="live-spotlight-buttons">
                <a class="button button-primary" id="live-btn-scoreboard" href="<?= $activeMatch ? '/scoreboard.php?match_id=' . (int) $activeMatch['id'] : '#' ?>" target="_blank" rel="noopener">
                    Buka Layar Proyektor &rarr;
                </a>
                <a class="button button-secondary" id="live-btn-buzzer" href="<?= $activeMatch ? '/buzzer.php?match_id=' . (int) $activeMatch['id'] : '#' ?>" target="_blank" rel="noopener">
                    Buka Bel Peserta
                </a>
            </div>
        </div>
    </div>
</section>

<!-- 3 Pintu Masuk Peran -->
<section class="portal-section" id="portal" aria-labelledby="portal-heading">
    <div class="section-container">
        <div class="section-title-wrap text-center">
            <span class="eyebrow">Pintu Masuk Cepat</span>
            <h2 id="portal-heading">Pilih Sesuai Posisi Anda di Lomba</h2>
            <p>Peserta menekan bel dari HP masing-masing, proyektor aula menayangkan papan skor, dan panitia mengendalikan alur soal dari laptop.</p>
        </div>

        <div class="portal-grid">
            <!-- Kartu 1: Bel Digital Peserta -->
            <article class="portal-card portal-card-buzzer">
                <div class="portal-card-header">
                    <div class="portal-icon-box">🔔</div>
                    <div>
                        <span class="portal-badge badge-role-team">Untuk HP Peserta</span>
                        <h3>Tombol Bel Regu</h3>
                    </div>
                </div>
                <p>Buka tombol bel lewat browser HP. Begitu operator membuka soal, tombol langsung menyala. Klik tercepat otomatis mengunci regu lawan.</p>
                
                <form action="/buzzer.php" method="get" class="portal-quick-form">
                    <div class="form-row">
                        <label>
                            <span class="form-label-mini">ID Pertandingan</span>
                            <input type="number" id="portal-buzzer-match-id" name="match_id" value="<?= $activeMatch ? (int) $activeMatch['id'] : '' ?>" placeholder="Contoh: 3" required>
                        </label>
                    </div>
                    <button class="button button-primary button-block" type="submit">
                        Buka Tombol Bel &rarr;
                    </button>
                </form>
                <span class="portal-hint">Panitia akan membagikan ID Pertandingan dan Kode Regu sebelum lomba dimulai.</span>
            </article>

            <!-- Kartu 2: Layar Panggung Penonton -->
            <article class="portal-card portal-card-scoreboard">
                <div class="portal-card-header">
                    <div class="portal-icon-box">📺</div>
                    <div>
                        <span class="portal-badge badge-role-screen">Untuk Proyektor Aula</span>
                        <h3>Layar Skor Panggung</h3>
                    </div>
                </div>
                <p>Tampilan layar penuh tanpa tombol kontrol. Angka skor besar dan countdown waktu menjawab jelas terbaca sampai baris belakang aula.</p>
                
                <form action="/scoreboard.php" method="get" class="portal-quick-form" target="_blank">
                    <div class="form-row">
                        <label>
                            <span class="form-label-mini">ID Pertandingan</span>
                            <input type="number" id="portal-scoreboard-match-id" name="match_id" value="<?= $activeMatch ? (int) $activeMatch['id'] : '' ?>" placeholder="Contoh: 3" required>
                        </label>
                    </div>
                    <button class="button button-secondary button-block" type="submit">
                        Buka Layar Panggung &rarr;
                    </button>
                </form>
                <span class="portal-hint">Skor dan penanda hak jawab langsung berubah tanpa perlu refresh browser.</span>
            </article>

            <!-- Kartu 3: Operator & Juri -->
            <article class="portal-card portal-card-operator">
                <div class="portal-card-header">
                    <div class="portal-icon-box">🎛️</div>
                    <div>
                        <span class="portal-badge badge-role-admin">Untuk Panitia & Juri</span>
                        <h3>Konsol Operator</h3>
                    </div>
                </div>
                <p>Kendali penuh satu layar dari laptop: siapkan babak, buka soal, beri nilai benar (+100) atau salah (-50), serta batalkan nilai jika keliru.</p>
                
                <div class="portal-quick-form">
                    <?php if (user()): ?>
                        <a class="button button-primary button-block" href="/operator.php">
                            Lanjut ke Konsol Lomba &rarr;
                        </a>
                        <a class="button button-secondary button-block button-subtle" href="/admin/events.php">
                            Kelola Kegiatan & Babak
                        </a>
                    <?php else: ?>
                        <a class="button button-primary button-block" href="/login.php">
                            Masuk Konsol Panitia &rarr;
                        </a>
                        <span class="portal-hint">Masuk dengan akun operator panitia yang sudah dibuat.</span>
                    <?php endif; ?>
                </div>
            </article>
        </div>
    </div>
</section>

<!-- Section Riwayat Pelaksanaan Cerdas Cermat Hari Besar Islam -->
<section class="history-section" id="riwayat" aria-labelledby="riwayat-heading">
    <div class="section-container">
        <div class="section-title-wrap">
            <span class="eyebrow">Rekam Jejak Juara</span>
            <h2 id="riwayat-heading">Riwayat Cerdas Cermat Hari Besar Islam</h2>
            <p>
                Dokumentasi hasil babak final dari lomba pada momentum hari-hari besar Islam. Nilai akhir, podium pemenang, dan rincian keputusan dewan juri tersimpan rapi untuk arsip bersama.
            </p>
        </div>

        <?php if (empty($finishedMatches)): ?>
            <div class="empty-history-box">
                <span class="empty-icon" aria-hidden="true">📜</span>
                <h3>Belum Ada Riwayat Pertandingan Selesai</h3>
                <p>Setelah operator mengakhiri babak di konsol, rekapitulasi poin dan nama regu pemenang otomatis tercatat di sini.</p>
                <a class="button button-secondary" href="/operator.php">Buka Konsol Pertandingan</a>
            </div>
        <?php else: ?>
            <div class="history-cards-grid">
                <?php foreach ($finishedMatches as $item): ?>
                    <?php
                    $badge = get_islamic_badge($item['event_name']);
                    $matchId = (int) $item['id'];
                    $podium = $podiumsByMatch[$matchId] ?? [];
                    $dateStr = $item['event_date'] ? date('d F Y', strtotime($item['event_date'])) : 'Tanggal tercatat';
                    ?>
                    <article class="history-card">
                        <div class="history-card-top">
                            <span class="history-event-tag <?= e($badge['class']) ?>">
                                <span class="tag-icon" aria-hidden="true"><?= $badge['icon'] ?></span>
                                <?= e($badge['label']) ?>
                            </span>
                            <span class="history-date"><?= e($dateStr) ?></span>
                        </div>

                        <h3 class="history-event-name"><?= e($item['event_name']) ?></h3>
                        <p class="history-round-name">
                            <strong>Babak:</strong> <?= e($item['round_name']) ?>
                            <?php if ($item['location']): ?>
                                • <span class="history-loc"><?= e($item['location']) ?></span>
                            <?php endif; ?>
                        </p>

                        <!-- Mini Podium Juara -->
                        <div class="history-podium">
                            <span class="podium-title">Podium Skor Akhir:</span>
                            <?php if (empty($podium)): ?>
                                <p class="muted">Nilai tersimpan pada arsip kegiatan.</p>
                            <?php else: ?>
                                <ol class="podium-list">
                                    <?php foreach (array_slice($podium, 0, 3) as $idx => $team): ?>
                                        <li class="podium-item podium-item-<?= $idx + 1 ?>">
                                            <span class="podium-medal" aria-hidden="true">
                                                <?= $idx === 0 ? '🥇' : ($idx === 1 ? '🥈' : '🥉') ?>
                                            </span>
                                            <div class="podium-team-wrap">
                                                <strong class="podium-team"><?= e($team['team_name']) ?></strong>
                                                <?php if (!empty($team['members'])): ?>
                                                    <small class="podium-members"><?= e($team['members']) ?></small>
                                                <?php endif; ?>
                                            </div>
                                            <span class="podium-score"><?= (int) $team['score'] ?> poin</span>
                                        </li>
                                    <?php endforeach; ?>
                                </ol>
                            <?php endif; ?>
                        </div>

                        <!-- Card Action Links -->
                        <div class="history-actions">
                            <a class="button button-secondary button-sm" href="/results.php?match_id=<?= $matchId ?>">
                                Papan Skor Lengkap &rarr;
                            </a>
                            <a class="button button-secondary button-sm button-quiet" href="/export-results.php?match_id=<?= $matchId ?>" title="Unduh file spreadsheet CSV">
                                📥 CSV
                            </a>
                        </div>
                    </article>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </div>
</section>

<!-- Fitur Unggulan Sistem: Kenapa Pakai Ini? -->
<section class="features-section" id="fitur" aria-labelledby="fitur-heading">
    <div class="section-container">
        <div class="section-title-wrap text-center">
            <span class="eyebrow">Didesain Praktis</span>
            <h2 id="fitur-heading">Menyelesaikan Masalah Nyata di Panggung Lomba</h2>
            <p>Nggak ada lagi perdebatan siapa yang angkat tangan lebih dulu, salah hitung manual di papan tulis, atau panitia bingung meralat nilai.</p>
        </div>

        <div class="feature-grid">
            <article class="feature-card">
                <div class="feature-icon-wrap">⚡</div>
                <h3>Kunci Bel di Server</h3>
                <p>Ketika dua regu memencet bel di detik yang nyaris sama, server mengunci selisih mikrodetik lewat transaksi database. Hak jawab jatuh ke penekan tercepat tanpa ragu.</p>
            </article>

            <article class="feature-card">
                <div class="feature-icon-wrap">📺</div>
                <h3>Layar Panggung Otomatis</h3>
                <p>Skor dan jatah jawab langsung berganti di proyektor saat juri memberi keputusan. Penonton di aula langsung tahu kondisi angka tanpa nunggu operator merefresh layar.</p>
            </article>

            <article class="feature-card">
                <div class="feature-icon-wrap">🛡️</div>
                <h3>Bisa Batalkan Nilai (Undo)</h3>
                <p>Operator salah klik tombol nilai? Ada tombol batalkan keputusan terakhir. Skor kembali ke posisi semula dan riwayat koreksi tetap tercatat rapi.</p>
            </article>

            <article class="feature-card">
                <div class="feature-icon-wrap">💻</div>
                <h3>Mode Gladi Bersih Satu Laptop</h3>
                <p>Mau uji coba alur tanpa mengumpulkan HP peserta? Operator punya tombol simulasi bel untuk tiap regu langsung di layar konsol laptop.</p>
            </article>

            <article class="feature-card">
                <div class="feature-icon-wrap">⚙️</div>
                <h3>Dukungan Skor Minus</h3>
                <p>Atur penambahan poin benar (+100) dan penalti salah (-50) sesuai petunjuk teknis babak rebutan. Waktu menjawab juga bisa dibatasi per babak.</p>
            </article>

            <article class="feature-card">
                <div class="feature-icon-wrap">📊</div>
                <h3>Cetak & Arsip Berita Acara</h3>
                <p>Selesai lomba, hasil akhir langsung bisa dicetak rapi untuk ditandatangani dewan juri atau diunduh sebagai berkas CSV arsip panitia.</p>
            </article>
        </div>
    </div>
</section>

<!-- Alur Lomba Tiga Langkah -->
<section class="workflow-section" id="alur" aria-labelledby="alur-heading">
    <div class="section-container">
        <div class="section-title-wrap text-center">
            <span class="eyebrow">Mudah Dipelajari</span>
            <h2 id="alur-heading">Tiga Langkah Menjalankan Lomba</h2>
            <p>Panitia baru bisa menguasai alur ini hanya dalam satu kali simulasi.</p>
        </div>

        <div class="workflow-steps">
            <div class="workflow-step">
                <div class="step-badge">1</div>
                <h3>Isi Data Acara & Regu</h3>
                <p>Bikin kegiatan di admin, masukkan nama regu, dan tentukan aturan poin babak (nilai benar, salah, dan batas waktu).</p>
            </div>
            <div class="step-arrow" aria-hidden="true">&rarr;</div>
            <div class="workflow-step">
                <div class="step-badge">2</div>
                <h3>Buka Proyektor & Bel Regu</h3>
                <p>Tampilkan papan skor di layar panggung aula. Bagikan tautan dan kode akses ke regu santri untuk membuka bel di HP.</p>
            </div>
            <div class="step-arrow" aria-hidden="true">&rarr;</div>
            <div class="workflow-step">
                <div class="step-badge">3</div>
                <h3>Buka Soal & Beri Nilai</h3>
                <p>Moderator membacakan soal, operator membuka bel. Saat bel berbunyi, juri menilai jawaban dan skor panggung langsung berubah.</p>
            </div>
        </div>
    </div>
</section>

<!-- Footer Halaman -->
<footer class="landing-footer">
    <div class="section-container">
        <div class="footer-top">
            <div class="footer-brand">
                <div class="brand">
                    <span class="brand-mark" aria-hidden="true">CCI</span>
                    <span class="brand-name">CCI An Nuur</span>
                </div>
                <p>Aplikasi cerdas cermat berbasis PHP native dan MySQL untuk perlombaan santri, madrasah, dan peringatan hari besar Islam.</p>
            </div>

            <div class="footer-links-group">
                <h4>Pintu Halaman</h4>
                <ul>
                    <li><a href="#portal">Pintu Masuk Lomba</a></li>
                    <li><a href="#riwayat">Arsip Juara PHBI</a></li>
                    <li><a href="#fitur">Kenapa Pakai Ini?</a></li>
                    <li><a href="#alur">Alur Tiga Langkah</a></li>
                </ul>
            </div>

            <div class="footer-links-group">
                <h4>Panel Panitia</h4>
                <ul>
                    <li><a href="/login.php">Masuk Operator</a></li>
                    <li><a href="/admin/events.php">Daftar Kegiatan</a></li>
                    <li><a href="/admin/teams.php">Daftar Regu</a></li>
                    <li><a href="/admin/rounds.php">Pengaturan Babak</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <span>&copy; <?= date('Y') ?> CCI An Nuur. develop by Sisttem Informasi ITATS</span>
            <span>Server Lokal Aktif (PHP <?= PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION ?> &amp; MariaDB)</span>
        </div>
    </div>
</footer>

<?php
$hideGlobalFooter = true;
require __DIR__ . '/includes/footer.php';
?>
