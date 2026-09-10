<?php

declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';

$matchId = filter_input(INPUT_GET, 'match_id', FILTER_VALIDATE_INT);
if (!$matchId) {
    $active = current_active_match();
    if ($active) {
        $matchId = (int) $active['id'];
    } else {
        json_response([
            'ok' => true,
            'has_active_match' => false,
            'message' => 'Tidak ada pertandingan yang sedang berlangsung.',
            'data' => null,
        ]);
    }
}

$payload = match_payload((int) $matchId);
if (!$payload) {
    json_response(['ok' => false, 'message' => 'Pertandingan tidak ditemukan.'], 404);
}

$payload['match']['status_label'] = status_label($payload['match']['status']);
json_response(['ok' => true, 'data' => $payload]);

