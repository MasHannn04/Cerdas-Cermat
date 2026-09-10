<?php

declare(strict_types=1);

require_once __DIR__ . '/includes/functions.php';

$matchId = filter_input(INPUT_GET, 'match_id', FILTER_VALIDATE_INT)
    ?: filter_input(INPUT_POST, 'match_id', FILTER_VALIDATE_INT);

// Jika ID tidak diisi di URL, otomatis deteksi pertandingan yang sedang aktif pada kegiatan yang aktif
if (!$matchId) {
    $active = current_active_match();
    if ($active) {
        $matchId = (int) $active['id'];
    }
}

$payload = $matchId ? match_payload((int) $matchId) : null;
$selectedTeam = null;
$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $code = strtoupper(trim((string) ($_POST['access_code'] ?? '')));
    if ($matchId < 1 || !$payload) {
        $error = 'ID Pertandingan tidak valid atau tidak ditemukan.';
    } else {
        $statement = db()->prepare(
            'SELECT t.id, t.name, t.access_code
             FROM match_teams mt JOIN teams t ON t.id = mt.team_id
             WHERE mt.match_id = ? AND t.access_code = ? LIMIT 1'
        );
        $statement->execute([$matchId, $code]);
        $selectedTeam = $statement->fetch() ?: null;
        if (!$selectedTeam) {
            $error = 'Kode akses tidak cocok dengan regu pada pertandingan ID #' . $matchId . '.';
        }
    }
} elseif (!$payload) {
    $error = 'Belum ada pertandingan aktif. Masukkan ID Pertandingan dari operator.';
}

$pageTitle = 'Bel Regu';
$bodyClass = 'buzzer-page public-page';
$showAppHeader = false;
require __DIR__ . '/includes/header.php';
?>
<section class="buzzer-shell">
    <?php if (!$selectedTeam): ?>
        <div class="buzzer-intro">
            <span class="brand-mark brand-mark-large" aria-hidden="true">CCI</span>
            <span class="eyebrow">Bel digital regu</span>
            <h1><?= $payload ? e($payload['match']['event_name']) : 'Hubungkan ke pertandingan' ?></h1>
            <?php if ($payload): ?>
                <div class="buzzer-match-tag">
                    <span>ID Pertandingan: <strong>#<?= (int) $matchId ?></strong></span>
                    <span>Babak: <strong><?= e($payload['match']['round_name']) ?></strong></span>
                </div>
            <?php endif; ?>
            <p>Masukkan kode regu yang diberikan operator untuk membuka tombol bel.</p>
        </div>
        <?php if ($error): ?><div class="notice notice-error" role="alert"><?= e($error) ?></div><?php endif; ?>
        <form method="post" class="buzzer-code-form">
            <?php if ($payload): ?>
                <input type="hidden" name="match_id" value="<?= (int) $matchId ?>">
            <?php else: ?>
                <label><span>ID Pertandingan</span><input type="number" name="match_id" placeholder="Contoh: 5" required autofocus></label>
            <?php endif; ?>
            <label><span>Kode akses regu</span><input type="text" name="access_code" minlength="3" maxlength="12" placeholder="Contoh: ABU01" autocomplete="off" required autofocus></label>
            <button class="button button-primary button-block" type="submit">Buka tombol bel</button>
            <?php if ($payload): ?>
                <span class="portal-hint text-center">Ganti pertandingan? <a href="/buzzer.php?match_id=" class="text-link">Ketik ID lain</a> atau kembali ke <a href="/" class="text-link">Landing Page</a></span>
            <?php endif; ?>
        </form>
    <?php else: ?>
        <div class="team-buzzer" data-team-buzzer data-match-id="<?= (int) $matchId ?>" data-team-id="<?= (int) $selectedTeam['id'] ?>" data-access-code="<?= e($selectedTeam['access_code']) ?>">
            <span class="eyebrow"><?= e($payload['match']['round_name']) ?></span>
            <h1><?= e($selectedTeam['name']) ?></h1>
            <p id="buzzer-instruction">Tunggu sampai operator membuka soal.</p>
            <button class="big-buzzer" id="big-buzzer" type="button" disabled>
                <span>TEKAN BEL</span>
                <small id="buzzer-state">Bel belum dibuka</small>
            </button>
            <div class="buzzer-feedback" id="buzzer-feedback" role="status" aria-live="assertive"></div>
        </div>
    <?php endif; ?>
</section>
<?php require __DIR__ . '/includes/footer.php'; ?>
